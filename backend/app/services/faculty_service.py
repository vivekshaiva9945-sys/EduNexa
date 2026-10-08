import datetime
from decimal import Decimal
from typing import List, Optional
from uuid import UUID
from sqlalchemy import select, func, case, delete, and_
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import selectinload

from app.core.exceptions import EntityNotFoundException, PermissionDeniedException
from app.models.academic import Course, CourseEnrollment, Timetable
from app.models.attendance import Attendance
from app.models.grade import Grade
from app.models.portal import Announcement, CourseMaterial
from app.models.user import Student
from app.schemas.faculty import (
    BatchAttendanceCreate,
    AttendanceUpdate,
    TimetableSlotResponse,
    AssignedCourseResponse,
    CourseAttendanceMetrics,
    StudentRosterItem,
    BatchGradeCreate,
    GradeResponse,
    GradeUpdate,
    CourseMaterialCreate,
    CourseMaterialResponse,
)


class FacultyService:
    # Attendance Operations (FAC-01, FAC-03)
    @staticmethod
    async def batch_record_attendance(
        db: AsyncSession,
        college_id: UUID,
        faculty_id: UUID,
        data: BatchAttendanceCreate,
    ) -> int:
        """Batch insert/upsert daily section attendance (FAC-01)."""
        created_count = 0
        for item in data.records:
            # Check if record already exists for student on that date & course
            stmt = select(Attendance).where(
                Attendance.college_id == college_id,
                Attendance.course_id == data.course_id,
                Attendance.student_id == item.student_id,
                Attendance.date_recorded == data.date_recorded,
            )
            result = await db.execute(stmt)
            existing = result.scalar_one_or_none()

            if existing:
                existing.status = item.status
                existing.remarks = item.remarks
                existing.faculty_id = faculty_id
            else:
                new_att = Attendance(
                    college_id=college_id,
                    student_id=item.student_id,
                    faculty_id=faculty_id,
                    course_id=data.course_id,
                    date_recorded=data.date_recorded,
                    status=item.status,
                    remarks=item.remarks,
                )
                db.add(new_att)
            created_count += 1

        await db.commit()
        return created_count

    @staticmethod
    async def update_attendance_record(
        db: AsyncSession,
        college_id: UUID,
        attendance_id: UUID,
        data: AttendanceUpdate,
    ) -> Attendance:
        """Update an existing attendance log entry (FAC-01)."""
        stmt = select(Attendance).where(
            Attendance.college_id == college_id,
            Attendance.attendance_id == attendance_id,
        )
        result = await db.execute(stmt)
        record = result.scalar_one_or_none()
        if not record:
            raise EntityNotFoundException("Attendance Record", attendance_id)

        record.status = data.status
        if data.remarks is not None:
            record.remarks = data.remarks

        await db.commit()
        await db.refresh(record)
        return record

    @staticmethod
    async def get_faculty_timetable(
        db: AsyncSession, college_id: UUID, faculty_id: UUID
    ) -> List[TimetableSlotResponse]:
        """Fetch personal teaching schedule for the authenticated faculty member (FAC-02)."""
        stmt = (
            select(
                Timetable.timetable_id,
                Timetable.course_id,
                Course.course_code,
                Course.course_name,
                Timetable.day_of_week,
                Timetable.start_time,
                Timetable.end_time,
                Timetable.room_number,
            )
            .join(Course, (Timetable.course_id == Course.course_id) & (Course.college_id == college_id))
            .where(Timetable.college_id == college_id, Timetable.faculty_id == faculty_id)
            .order_by(Timetable.day_of_week, Timetable.start_time)
        )
        result = await db.execute(stmt)
        rows = result.all()
        return [
            TimetableSlotResponse(
                timetable_id=row.timetable_id,
                course_id=row.course_id,
                course_code=row.course_code,
                course_name=row.course_name,
                day_of_week=row.day_of_week,
                start_time=row.start_time,
                end_time=row.end_time,
                room_number=row.room_number,
            )
            for row in rows
        ]

    @staticmethod
    async def get_assigned_courses(
        db: AsyncSession, college_id: UUID, faculty_id: UUID
    ) -> List[AssignedCourseResponse]:
        """List distinct courses assigned to faculty via timetable schedule (FAC-02, FAC-03)."""
        stmt = (
            select(Course)
            .join(Timetable, (Course.course_id == Timetable.course_id) & (Timetable.college_id == college_id))
            .where(Course.college_id == college_id, Timetable.faculty_id == faculty_id)
            .distinct()
        )
        result = await db.execute(stmt)
        courses = result.scalars().all()
        return [
            AssignedCourseResponse(
                course_id=c.course_id,
                course_code=c.course_code,
                course_name=c.course_name,
                department=c.department,
                credits=c.credits,
                semester=c.semester,
            )
            for c in courses
        ]

    @staticmethod
    async def get_course_attendance_metrics(
        db: AsyncSession, college_id: UUID, course_id: UUID
    ) -> CourseAttendanceMetrics:
        """View course-level attendance summaries for assigned classes (FAC-03)."""
        course_res = await db.execute(
            select(Course).where(Course.college_id == college_id, Course.course_id == course_id)
        )
        course = course_res.scalar_one_or_none()
        if not course:
            raise EntityNotFoundException("Course", course_id)

        enrollments_count = await db.scalar(
            select(func.count(CourseEnrollment.enrollment_id)).where(
                CourseEnrollment.college_id == college_id,
                CourseEnrollment.course_id == course_id,
            )
        ) or 0

        att_stats = await db.execute(
            select(
                func.count(Attendance.attendance_id).label("total"),
                func.count(
                    case((Attendance.status == "PRESENT", Attendance.attendance_id), else_=None)
                ).label("present"),
            ).where(Attendance.college_id == college_id, Attendance.course_id == course_id)
        )
        row = att_stats.one()
        tot = row.total or 0
        pres = row.present or 0
        avg_rate = round((pres / tot * 100.0), 2) if tot > 0 else 0.0

        return CourseAttendanceMetrics(
            course_id=course.course_id,
            course_code=course.course_code,
            course_name=course.course_name,
            total_enrolled=enrollments_count,
            total_records=tot,
            average_attendance_rate=avg_rate,
        )

    @staticmethod
    async def get_course_students(
        db: AsyncSession, college_id: UUID, course_id: UUID
    ) -> List[StudentRosterItem]:
        """Fetch student roster for course (FAC-01, FAC-03, FAC-04)."""
        stmt = (
            select(Student)
            .join(CourseEnrollment, (Student.student_id == CourseEnrollment.student_id) & (CourseEnrollment.college_id == college_id))
            .where(CourseEnrollment.course_id == course_id, Student.college_id == college_id)
            .order_by(Student.roll_number.asc())
        )
        result = await db.execute(stmt)
        students = result.scalars().all()
        return [
            StudentRosterItem(
                student_id=s.student_id,
                roll_number=s.roll_number,
                first_name=s.first_name,
                last_name=s.last_name,
                enrollment_year=s.enrollment_year,
                semester=s.semester,
            )
            for s in students
        ]

    # Grades Operations (FAC-04)
    @staticmethod
    async def batch_upload_grades(
        db: AsyncSession,
        college_id: UUID,
        faculty_id: UUID,
        course_id: UUID,
        data: BatchGradeCreate,
    ) -> int:
        """Batch insert/update student assessment scores (FAC-04)."""
        saved_count = 0
        for item in data.grades:
            new_grade = Grade(
                college_id=college_id,
                student_id=item.student_id,
                course_id=course_id,
                faculty_id=faculty_id,
                assessment_name=item.assessment_name,
                score=Decimal(str(item.score)),
                max_score=Decimal(str(item.max_score)),
                remarks=item.remarks,
            )
            db.add(new_grade)
            saved_count += 1
        await db.commit()
        return saved_count

    @staticmethod
    async def get_course_grades(
        db: AsyncSession, college_id: UUID, course_id: UUID
    ) -> List[GradeResponse]:
        """View submitted assessment marks for a course (FAC-04)."""
        stmt = (
            select(
                Grade.grade_id,
                Grade.student_id,
                Student.first_name,
                Student.last_name,
                Grade.course_id,
                Grade.assessment_name,
                Grade.score,
                Grade.max_score,
                Grade.remarks,
                Grade.graded_at,
            )
            .join(Student, (Grade.student_id == Student.student_id) & (Student.college_id == college_id))
            .where(Grade.college_id == college_id, Grade.course_id == course_id)
            .order_by(Grade.graded_at.desc())
        )
        result = await db.execute(stmt)
        rows = result.all()
        return [
            GradeResponse(
                grade_id=row.grade_id,
                student_id=row.student_id,
                student_name=f"{row.first_name} {row.last_name}",
                course_id=row.course_id,
                assessment_name=row.assessment_name,
                score=float(row.score),
                max_score=float(row.max_score),
                remarks=row.remarks,
                graded_at=row.graded_at,
            )
            for row in rows
        ]

    @staticmethod
    async def update_grade(
        db: AsyncSession,
        college_id: UUID,
        grade_id: UUID,
        data: GradeUpdate,
    ) -> Grade:
        """Modify or correct an assessment grade (FAC-04)."""
        stmt = select(Grade).where(Grade.college_id == college_id, Grade.grade_id == grade_id)
        result = await db.execute(stmt)
        grade = result.scalar_one_or_none()
        if not grade:
            raise EntityNotFoundException("Grade", grade_id)

        if data.score is not None:
            grade.score = Decimal(str(data.score))
        if data.max_score is not None:
            grade.max_score = Decimal(str(data.max_score))
        if data.remarks is not None:
            grade.remarks = data.remarks

        await db.commit()
        await db.refresh(grade)
        return grade

    # Course Materials (FAC-05)
    @staticmethod
    async def upload_course_material(
        db: AsyncSession,
        college_id: UUID,
        faculty_id: UUID,
        data: CourseMaterialCreate,
    ) -> CourseMaterialResponse:
        """Upload and distribute digital course materials to class (FAC-05)."""
        material = CourseMaterial(
            college_id=college_id,
            course_id=data.course_id,
            faculty_id=faculty_id,
            title=data.title,
            description=data.description,
            file_url=data.file_url,
            file_type=data.file_type,
        )
        db.add(material)
        await db.commit()
        await db.refresh(material)
        return CourseMaterialResponse(
            material_id=material.material_id,
            course_id=material.course_id,
            faculty_id=material.faculty_id,
            title=material.title,
            description=material.description,
            file_url=material.file_url,
            file_type=material.file_type,
            uploaded_at=material.uploaded_at,
        )

    @staticmethod
    async def get_course_materials(
        db: AsyncSession, college_id: UUID, course_id: UUID
    ) -> List[CourseMaterialResponse]:
        """List uploaded course materials for specified course (FAC-05)."""
        stmt = (
            select(CourseMaterial)
            .where(CourseMaterial.college_id == college_id, CourseMaterial.course_id == course_id)
            .order_by(CourseMaterial.uploaded_at.desc())
        )
        result = await db.execute(stmt)
        materials = result.scalars().all()
        return [
            CourseMaterialResponse(
                material_id=m.material_id,
                course_id=m.course_id,
                faculty_id=m.faculty_id,
                title=m.title,
                description=m.description,
                file_url=m.file_url,
                file_type=m.file_type,
                uploaded_at=m.uploaded_at,
            )
            for m in materials
        ]

    @staticmethod
    async def delete_course_material(
        db: AsyncSession, college_id: UUID, material_id: UUID
    ) -> None:
        """Remove uploaded course material (FAC-05)."""
        stmt = delete(CourseMaterial).where(
            CourseMaterial.college_id == college_id,
            CourseMaterial.material_id == material_id,
        )
        result = await db.execute(stmt)
        if result.rowcount == 0:
            raise EntityNotFoundException("Course Material", material_id)
        await db.commit()

    # Announcements (FAC-06)
    @staticmethod
    async def get_faculty_announcements(
        db: AsyncSession, college_id: UUID
    ) -> List[Announcement]:
        """View institutional announcements feed where target_role IN ('ALL', 'FACULTY') (FAC-06)."""
        stmt = (
            select(Announcement)
            .where(
                Announcement.college_id == college_id,
                Announcement.target_role.in_(["ALL", "FACULTY"]),
            )
            .order_by(Announcement.created_at.desc())
        )
        result = await db.execute(stmt)
        return list(result.scalars().all())
