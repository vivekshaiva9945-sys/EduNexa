import datetime
from typing import List, Optional
from uuid import UUID
from sqlalchemy import select, func, case, delete
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.exceptions import EntityNotFoundException
from app.models.academic import Course, Timetable
from app.models.attendance import Attendance
from app.models.grade import Grade
from app.models.portal import Announcement, AcademicCalendar, CourseMaterial
from app.models.user import Faculty, Student
from app.schemas.admin import (
    AttendanceSummaryItem,
    AttendanceSummaryResponse,
    AttendanceTrendItem,
    FacultyActivityItem,
    FacultyAttendanceLogItem,
)
from app.schemas.portal import (
    AnnouncementCreate,
    AnnouncementUpdate,
    AcademicCalendarCreate,
)


class AdminService:
    @staticmethod
    async def get_attendance_summary(db: AsyncSession, college_id: UUID) -> AttendanceSummaryResponse:
        """College-wide student attendance breakdown and aggregated statistics (ADM-01)."""
        stmt = (
            select(
                Course.course_id,
                Course.course_code,
                Course.course_name,
                Course.department,
                func.count(Attendance.attendance_id).label("total_records"),
                func.count(
                    case((Attendance.status == "PRESENT", Attendance.attendance_id), else_=None)
                ).label("present_count"),
                func.count(
                    case((Attendance.status == "ABSENT", Attendance.attendance_id), else_=None)
                ).label("absent_count"),
            )
            .outerjoin(Attendance, (Course.course_id == Attendance.course_id) & (Attendance.college_id == college_id))
            .where(Course.college_id == college_id)
            .group_by(Course.course_id, Course.course_code, Course.course_name, Course.department)
        )
        result = await db.execute(stmt)
        rows = result.all()

        total_records_all = 0
        total_present_all = 0
        by_course: List[AttendanceSummaryItem] = []

        for row in rows:
            tot = row.total_records or 0
            pres = row.present_count or 0
            pct = round((pres / tot * 100.0), 2) if tot > 0 else 0.0
            total_records_all += tot
            total_present_all += pres
            by_course.append(
                AttendanceSummaryItem(
                    course_id=row.course_id,
                    course_code=row.course_code,
                    course_name=row.course_name,
                    department=row.department,
                    total_records=tot,
                    present_count=pres,
                    absent_count=row.absent_count or 0,
                    attendance_percentage=pct,
                )
            )

        overall_pct = (
            round((total_present_all / total_records_all * 100.0), 2)
            if total_records_all > 0
            else 0.0
        )

        return AttendanceSummaryResponse(
            college_id=college_id,
            overall_percentage=overall_pct,
            total_records=total_records_all,
            by_course=by_course,
        )

    @staticmethod
    async def get_attendance_trends(db: AsyncSession, college_id: UUID) -> List[AttendanceTrendItem]:
        """Historical attendance trends grouped by date and academic department (ADM-01)."""
        stmt = (
            select(
                Attendance.date_recorded,
                Course.department,
                func.count(Attendance.attendance_id).label("total_records"),
                func.count(
                    case((Attendance.status == "PRESENT", Attendance.attendance_id), else_=None)
                ).label("present_count"),
            )
            .join(Course, (Attendance.course_id == Course.course_id) & (Course.college_id == college_id))
            .where(Attendance.college_id == college_id)
            .group_by(Attendance.date_recorded, Course.department)
            .order_by(Attendance.date_recorded.desc())
            .limit(50)
        )
        result = await db.execute(stmt)
        rows = result.all()

        trends: List[AttendanceTrendItem] = []
        for row in rows:
            tot = row.total_records or 0
            pres = row.present_count or 0
            pct = round((pres / tot * 100.0), 2) if tot > 0 else 0.0
            trends.append(
                AttendanceTrendItem(
                    date_recorded=row.date_recorded,
                    department=row.department,
                    total_records=tot,
                    present_count=pres,
                    attendance_percentage=pct,
                )
            )
        return trends

    @staticmethod
    async def get_faculty_activity(db: AsyncSession, college_id: UUID) -> List[FacultyActivityItem]:
        """Aggregated faculty productivity KPIs and lecture logging counts (ADM-03)."""
        stmt = (
            select(
                Faculty.faculty_id,
                Faculty.employee_code,
                Faculty.first_name,
                Faculty.last_name,
                Faculty.department,
                Faculty.designation,
                func.count(func.distinct(Timetable.timetable_id)).label("classes_scheduled"),
                func.count(func.distinct(Attendance.attendance_id)).label("attendance_sessions_logged"),
                func.count(func.distinct(CourseMaterial.material_id)).label("materials_uploaded"),
                func.count(func.distinct(Grade.grade_id)).label("grades_awarded"),
            )
            .outerjoin(Timetable, (Faculty.faculty_id == Timetable.faculty_id) & (Timetable.college_id == college_id))
            .outerjoin(Attendance, (Faculty.faculty_id == Attendance.faculty_id) & (Attendance.college_id == college_id))
            .outerjoin(CourseMaterial, (Faculty.faculty_id == CourseMaterial.faculty_id) & (CourseMaterial.college_id == college_id))
            .outerjoin(Grade, (Faculty.faculty_id == Grade.faculty_id) & (Grade.college_id == college_id))
            .where(Faculty.college_id == college_id)
            .group_by(
                Faculty.faculty_id,
                Faculty.employee_code,
                Faculty.first_name,
                Faculty.last_name,
                Faculty.department,
                Faculty.designation,
            )
        )
        result = await db.execute(stmt)
        rows = result.all()

        return [
            FacultyActivityItem(
                faculty_id=row.faculty_id,
                employee_code=row.employee_code,
                name=f"{row.first_name} {row.last_name}",
                department=row.department,
                designation=row.designation,
                classes_scheduled=row.classes_scheduled or 0,
                attendance_sessions_logged=row.attendance_sessions_logged or 0,
                materials_uploaded=row.materials_uploaded or 0,
                grades_awarded=row.grades_awarded or 0,
            )
            for row in rows
        ]

    @staticmethod
    async def get_faculty_attendance_logs(
        db: AsyncSession, college_id: UUID, faculty_id: UUID
    ) -> List[FacultyAttendanceLogItem]:
        """Attendance logs marked by a specific faculty member (ADM-03)."""
        stmt = (
            select(
                Attendance.attendance_id,
                Attendance.student_id,
                Student.first_name.label("student_first_name"),
                Student.last_name.label("student_last_name"),
                Attendance.course_id,
                Course.course_code,
                Course.course_name,
                Attendance.date_recorded,
                Attendance.status,
                Attendance.remarks,
                Attendance.created_at,
            )
            .join(Student, (Attendance.student_id == Student.student_id) & (Student.college_id == college_id))
            .join(Course, (Attendance.course_id == Course.course_id) & (Course.college_id == college_id))
            .where(Attendance.college_id == college_id, Attendance.faculty_id == faculty_id)
            .order_by(Attendance.date_recorded.desc(), Attendance.created_at.desc())
            .limit(100)
        )
        result = await db.execute(stmt)
        rows = result.all()

        return [
            FacultyAttendanceLogItem(
                attendance_id=row.attendance_id,
                student_id=row.student_id,
                student_name=f"{row.student_first_name} {row.student_last_name}",
                course_id=row.course_id,
                course_code=row.course_code,
                course_name=row.course_name,
                date_recorded=row.date_recorded,
                status=row.status,
                remarks=row.remarks,
                created_at=row.created_at,
            )
            for row in rows
        ]

    # Announcements Management (ADM-02)
    @staticmethod
    async def create_announcement(
        db: AsyncSession, college_id: UUID, author_id: UUID, data: AnnouncementCreate
    ) -> Announcement:
        announcement = Announcement(
            college_id=college_id,
            author_id=author_id,
            title=data.title,
            content=data.content,
            target_role=data.target_role,
        )
        db.add(announcement)
        await db.commit()
        await db.refresh(announcement)
        return announcement

    @staticmethod
    async def get_announcements(
        db: AsyncSession, college_id: UUID, target_role: Optional[str] = None
    ) -> List[Announcement]:
        stmt = select(Announcement).where(Announcement.college_id == college_id)
        if target_role:
            stmt = stmt.where(Announcement.target_role.in_(["ALL", target_role]))
        stmt = stmt.order_by(Announcement.created_at.desc())
        result = await db.execute(stmt)
        return list(result.scalars().all())

    @staticmethod
    async def update_announcement(
        db: AsyncSession, college_id: UUID, announcement_id: UUID, data: AnnouncementUpdate
    ) -> Announcement:
        stmt = select(Announcement).where(
            Announcement.college_id == college_id, Announcement.announcement_id == announcement_id
        )
        result = await db.execute(stmt)
        announcement = result.scalar_one_or_none()
        if not announcement:
            raise EntityNotFoundException("Announcement", announcement_id)

        if data.title is not None:
            announcement.title = data.title
        if data.content is not None:
            announcement.content = data.content
        if data.target_role is not None:
            announcement.target_role = data.target_role

        await db.commit()
        await db.refresh(announcement)
        return announcement

    @staticmethod
    async def delete_announcement(db: AsyncSession, college_id: UUID, announcement_id: UUID) -> None:
        stmt = delete(Announcement).where(
            Announcement.college_id == college_id, Announcement.announcement_id == announcement_id
        )
        result = await db.execute(stmt)
        if result.rowcount == 0:
            raise EntityNotFoundException("Announcement", announcement_id)
        await db.commit()

    # Academic Calendar Management (ENT-09)
    @staticmethod
    async def create_calendar_event(
        db: AsyncSession, college_id: UUID, data: AcademicCalendarCreate
    ) -> AcademicCalendar:
        event = AcademicCalendar(
            college_id=college_id,
            event_title=data.event_title,
            event_type=data.event_type,
            start_date=data.start_date,
            end_date=data.end_date,
            description=data.description,
        )
        db.add(event)
        await db.commit()
        await db.refresh(event)
        return event

    @staticmethod
    async def get_calendar_events(
        db: AsyncSession,
        college_id: UUID,
        start_date: Optional[datetime.date] = None,
        end_date: Optional[datetime.date] = None,
    ) -> List[AcademicCalendar]:
        stmt = select(AcademicCalendar).where(AcademicCalendar.college_id == college_id)
        if start_date:
            stmt = stmt.where(AcademicCalendar.end_date >= start_date)
        if end_date:
            stmt = stmt.where(AcademicCalendar.start_date <= end_date)
        stmt = stmt.order_by(AcademicCalendar.start_date.asc())
        result = await db.execute(stmt)
        return list(result.scalars().all())
