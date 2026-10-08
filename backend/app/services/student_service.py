import datetime
from typing import List, Optional
from uuid import UUID
from sqlalchemy import select, func, case
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import selectinload

from app.core.exceptions import EntityNotFoundException
from app.models.academic import Course, CourseEnrollment, Timetable
from app.models.attendance import Attendance
from app.models.grade import Grade
from app.models.portal import Announcement, AcademicCalendar, CourseMaterial
from app.models.user import Faculty, Student
from app.schemas.faculty import CourseMaterialResponse
from app.schemas.student import (
    StudentAttendanceItem,
    StudentAttendanceOverview,
    StudentAttendanceDetailItem,
    StudentTimetableSlot,
    StudentGradeItem,
    ProgressReport,
    StudentCourseItem,
)


class StudentService:
    # Attendance Tracking (STD-01)
    @staticmethod
    async def get_student_attendance_overview(
        db: AsyncSession, college_id: UUID, student_id: UUID
    ) -> StudentAttendanceOverview:
        """Personal attendance breakdown by course and overall percentage (STD-01)."""
        stmt = (
            select(
                Course.course_id,
                Course.course_code,
                Course.course_name,
                func.count(Attendance.attendance_id).label("total_classes"),
                func.count(
                    case((Attendance.status == "PRESENT", Attendance.attendance_id), else_=None)
                ).label("attended_classes"),
            )
            .join(CourseEnrollment, (Course.course_id == CourseEnrollment.course_id) & (CourseEnrollment.college_id == college_id))
            .outerjoin(
                Attendance,
                (Course.course_id == Attendance.course_id)
                & (Attendance.student_id == student_id)
                & (Attendance.college_id == college_id),
            )
            .where(CourseEnrollment.student_id == student_id, Course.college_id == college_id)
            .group_by(Course.course_id, Course.course_code, Course.course_name)
        )
        result = await db.execute(stmt)
        rows = result.all()

        total_classes_all = 0
        attended_classes_all = 0
        courses_list: List[StudentAttendanceItem] = []

        for row in rows:
            tot = row.total_classes or 0
            att = row.attended_classes or 0
            pct = round((att / tot * 100.0), 2) if tot > 0 else 0.0
            total_classes_all += tot
            attended_classes_all += att
            courses_list.append(
                StudentAttendanceItem(
                    course_id=row.course_id,
                    course_code=row.course_code,
                    course_name=row.course_name,
                    total_classes=tot,
                    attended_classes=att,
                    percentage=pct,
                )
            )

        overall_pct = (
            round((attended_classes_all / total_classes_all * 100.0), 2)
            if total_classes_all > 0
            else 0.0
        )

        return StudentAttendanceOverview(
            student_id=student_id,
            overall_percentage=overall_pct,
            courses=courses_list,
        )

    @staticmethod
    async def get_student_course_attendance_details(
        db: AsyncSession, college_id: UUID, student_id: UUID, course_id: UUID
    ) -> List[StudentAttendanceDetailItem]:
        """View date-by-date attendance log for enrolled course (STD-01)."""
        stmt = (
            select(
                Attendance.attendance_id,
                Attendance.course_id,
                Attendance.date_recorded,
                Attendance.status,
                Attendance.remarks,
                Faculty.first_name.label("fac_first"),
                Faculty.last_name.label("fac_last"),
            )
            .outerjoin(Faculty, (Attendance.faculty_id == Faculty.faculty_id) & (Faculty.college_id == college_id))
            .where(
                Attendance.college_id == college_id,
                Attendance.student_id == student_id,
                Attendance.course_id == course_id,
            )
            .order_by(Attendance.date_recorded.desc())
        )
        result = await db.execute(stmt)
        rows = result.all()

        return [
            StudentAttendanceDetailItem(
                attendance_id=row.attendance_id,
                course_id=row.course_id,
                date_recorded=row.date_recorded,
                status=row.status,
                remarks=row.remarks,
                faculty_name=f"{row.fac_first} {row.fac_last}" if row.fac_first else None,
            )
            for row in rows
        ]

    # Timetable (STD-02)
    @staticmethod
    async def get_student_timetable(
        db: AsyncSession, college_id: UUID, student_id: UUID
    ) -> List[StudentTimetableSlot]:
        """View personal class and lecture timetable (STD-02)."""
        stmt = (
            select(
                Timetable.timetable_id,
                Timetable.course_id,
                Course.course_code,
                Course.course_name,
                Faculty.first_name.label("fac_first"),
                Faculty.last_name.label("fac_last"),
                Timetable.day_of_week,
                Timetable.start_time,
                Timetable.end_time,
                Timetable.room_number,
            )
            .join(Course, (Timetable.course_id == Course.course_id) & (Course.college_id == college_id))
            .join(CourseEnrollment, (Course.course_id == CourseEnrollment.course_id) & (CourseEnrollment.college_id == college_id))
            .join(Faculty, (Timetable.faculty_id == Faculty.faculty_id) & (Faculty.college_id == college_id))
            .where(CourseEnrollment.student_id == student_id, Timetable.college_id == college_id)
            .order_by(Timetable.day_of_week, Timetable.start_time)
        )
        result = await db.execute(stmt)
        rows = result.all()
        return [
            StudentTimetableSlot(
                timetable_id=row.timetable_id,
                course_id=row.course_id,
                course_code=row.course_code,
                course_name=row.course_name,
                faculty_name=f"{row.fac_first} {row.fac_last}",
                day_of_week=row.day_of_week,
                start_time=row.start_time,
                end_time=row.end_time,
                room_number=row.room_number,
            )
            for row in rows
        ]

    # Grades & Progress Report (STD-03)
    @staticmethod
    async def get_student_grades(
        db: AsyncSession, college_id: UUID, student_id: UUID
    ) -> List[StudentGradeItem]:
        """Access assessment grades and test scores (STD-03)."""
        stmt = (
            select(
                Grade.grade_id,
                Grade.course_id,
                Course.course_code,
                Course.course_name,
                Grade.assessment_name,
                Grade.score,
                Grade.max_score,
                Grade.remarks,
            )
            .join(Course, (Grade.course_id == Course.course_id) & (Course.college_id == college_id))
            .where(Grade.college_id == college_id, Grade.student_id == student_id)
            .order_by(Grade.graded_at.desc())
        )
        result = await db.execute(stmt)
        rows = result.all()
        items: List[StudentGradeItem] = []
        for row in rows:
            sc = float(row.score)
            mx = float(row.max_score)
            pct = round((sc / mx * 100.0), 2) if mx > 0 else 0.0
            items.append(
                StudentGradeItem(
                    grade_id=row.grade_id,
                    course_id=row.course_id,
                    course_code=row.course_code,
                    course_name=row.course_name,
                    assessment_name=row.assessment_name,
                    score=sc,
                    max_score=mx,
                    percentage=pct,
                    remarks=row.remarks,
                )
            )
        return items

    @staticmethod
    async def get_student_progress_report(
        db: AsyncSession, college_id: UUID, student_id: UUID
    ) -> ProgressReport:
        """View semester GPA and progress aggregation (STD-03)."""
        grades = await StudentService.get_student_grades(db, college_id, student_id)

        distinct_courses = {g.course_id for g in grades}
        total_courses = len(distinct_courses)

        if not grades:
            return ProgressReport(
                student_id=student_id,
                total_courses=0,
                gpa=0.0,
                letter_grade="N/A",
                grades=[],
            )

        avg_pct = sum(g.percentage for g in grades) / len(grades)
        # Convert average percentage to 4.0 GPA scale standard
        gpa = round((avg_pct / 100.0) * 4.0, 2)

        if gpa >= 3.7:
            letter = "A"
        elif gpa >= 3.0:
            letter = "B"
        elif gpa >= 2.0:
            letter = "C"
        elif gpa >= 1.0:
            letter = "D"
        else:
            letter = "F"

        return ProgressReport(
            student_id=student_id,
            total_courses=total_courses,
            gpa=gpa,
            letter_grade=letter,
            grades=grades,
        )

    # Enrolled Courses (STD-04)
    @staticmethod
    async def get_enrolled_courses(
        db: AsyncSession, college_id: UUID, student_id: UUID
    ) -> List[StudentCourseItem]:
        """View enrolled courses list (STD-04)."""
        stmt = (
            select(
                Course.course_id,
                Course.course_code,
                Course.course_name,
                Course.department,
                Course.credits,
                Course.semester,
                CourseEnrollment.enrolled_at,
            )
            .join(CourseEnrollment, (Course.course_id == CourseEnrollment.course_id) & (CourseEnrollment.college_id == college_id))
            .where(CourseEnrollment.student_id == student_id, Course.college_id == college_id)
            .order_by(Course.course_code.asc())
        )
        result = await db.execute(stmt)
        rows = result.all()
        return [
            StudentCourseItem(
                course_id=row.course_id,
                course_code=row.course_code,
                course_name=row.course_name,
                department=row.department,
                credits=row.credits,
                semester=row.semester,
                enrolled_at=row.enrolled_at,
            )
            for row in rows
        ]

    # Course Materials (STD-04)
    @staticmethod
    async def get_student_all_materials(
        db: AsyncSession, college_id: UUID, student_id: UUID
    ) -> List[CourseMaterialResponse]:
        """Download and view course materials shared across all enrolled courses (STD-04)."""
        stmt = (
            select(CourseMaterial)
            .join(CourseEnrollment, (CourseMaterial.course_id == CourseEnrollment.course_id) & (CourseEnrollment.college_id == college_id))
            .where(CourseEnrollment.student_id == student_id, CourseMaterial.college_id == college_id)
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
    async def get_student_course_materials(
        db: AsyncSession, college_id: UUID, course_id: UUID
    ) -> List[CourseMaterialResponse]:
        """View materials for a specific course (STD-04)."""
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

    # Academic Calendar (STD-05)
    @staticmethod
    async def get_academic_calendar(
        db: AsyncSession, college_id: UUID
    ) -> List[AcademicCalendar]:
        """View academic calendar (exams and holidays) (STD-05)."""
        stmt = (
            select(AcademicCalendar)
            .where(AcademicCalendar.college_id == college_id)
            .order_by(AcademicCalendar.start_date.asc())
        )
        result = await db.execute(stmt)
        return list(result.scalars().all())

    # Announcements (STD-06)
    @staticmethod
    async def get_student_announcements(
        db: AsyncSession, college_id: UUID
    ) -> List[Announcement]:
        """View global institutional announcements feed where target_role IN ('ALL', 'STUDENT') (STD-06)."""
        stmt = (
            select(Announcement)
            .where(
                Announcement.college_id == college_id,
                Announcement.target_role.in_(["ALL", "STUDENT"]),
            )
            .order_by(Announcement.created_at.desc())
        )
        result = await db.execute(stmt)
        return list(result.scalars().all())
