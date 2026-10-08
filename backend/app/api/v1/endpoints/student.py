from typing import List
from uuid import UUID
from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession

from app.api.deps import RequireRole, get_tenant_session
from app.core.exceptions import PermissionDeniedException
from app.models.user import User
from app.schemas.common import APIResponse
from app.schemas.faculty import CourseMaterialResponse
from app.schemas.portal import AcademicCalendarResponse, AnnouncementResponse
from app.schemas.student import (
    ProgressReport,
    StudentAttendanceDetailItem,
    StudentAttendanceOverview,
    StudentCourseItem,
    StudentGradeItem,
    StudentTimetableSlot,
)
from app.services.student_service import StudentService

router = APIRouter(prefix="/student", tags=["Student Portal"])


def verify_student_access(student_id: UUID, current_user: User):
    """Ensure student can only view their own personal academic records."""
    if current_user.role == "STUDENT":
        if not current_user.student_profile or current_user.student_profile.student_id != student_id:
            raise PermissionDeniedException("Cannot access another student's academic records")


# ----------------------------------------------------
# STD-01: Attendance Tracking
# ----------------------------------------------------
@router.get("/{id}/attendance", response_model=APIResponse[StudentAttendanceOverview])
async def get_student_attendance_summary(
    id: UUID,
    current_user: User = Depends(RequireRole(["STUDENT", "ADMIN"])),
    db: AsyncSession = Depends(get_tenant_session),
):
    """Track personal attendance records and course percentage breakdown (STD-01)."""
    verify_student_access(id, current_user)
    data = await StudentService.get_student_attendance_overview(
        db, current_user.college_id, id
    )
    return APIResponse(data=data)


@router.get("/{id}/attendance/{course_id}", response_model=APIResponse[List[StudentAttendanceDetailItem]])
async def get_student_course_attendance_log(
    id: UUID,
    course_id: UUID,
    current_user: User = Depends(RequireRole(["STUDENT", "ADMIN"])),
    db: AsyncSession = Depends(get_tenant_session),
):
    """View date-by-date attendance log for enrolled course (STD-01)."""
    verify_student_access(id, current_user)
    data = await StudentService.get_student_course_attendance_details(
        db, current_user.college_id, id, course_id
    )
    return APIResponse(data=data)


# ----------------------------------------------------
# STD-02: Lecture Timetable
# ----------------------------------------------------
@router.get("/{id}/timetable", response_model=APIResponse[List[StudentTimetableSlot]])
async def get_student_lecture_timetable(
    id: UUID,
    current_user: User = Depends(RequireRole(["STUDENT", "ADMIN"])),
    db: AsyncSession = Depends(get_tenant_session),
):
    """View personal class and lecture timetable (STD-02)."""
    verify_student_access(id, current_user)
    slots = await StudentService.get_student_timetable(
        db, current_user.college_id, id
    )
    return APIResponse(data=slots)


# ----------------------------------------------------
# STD-03: Assessment Marks & Academic Progress
# ----------------------------------------------------
@router.get("/{id}/grades", response_model=APIResponse[List[StudentGradeItem]])
async def get_student_assessment_grades(
    id: UUID,
    current_user: User = Depends(RequireRole(["STUDENT", "ADMIN"])),
    db: AsyncSession = Depends(get_tenant_session),
):
    """Access assessment grades and test scores (STD-03)."""
    verify_student_access(id, current_user)
    grades = await StudentService.get_student_grades(
        db, current_user.college_id, id
    )
    return APIResponse(data=grades)


@router.get("/{id}/progress-report", response_model=APIResponse[ProgressReport])
async def get_student_progress_report(
    id: UUID,
    current_user: User = Depends(RequireRole(["STUDENT", "ADMIN"])),
    db: AsyncSession = Depends(get_tenant_session),
):
    """View semester GPA and progress aggregation report (STD-03)."""
    verify_student_access(id, current_user)
    report = await StudentService.get_student_progress_report(
        db, current_user.college_id, id
    )
    return APIResponse(data=report)


# ----------------------------------------------------
# STD-04: Enrolled Courses & Digital Materials
# ----------------------------------------------------
@router.get("/{id}/courses", response_model=APIResponse[List[StudentCourseItem]])
async def get_registered_courses(
    id: UUID,
    current_user: User = Depends(RequireRole(["STUDENT", "ADMIN"])),
    db: AsyncSession = Depends(get_tenant_session),
):
    """View enrolled courses list (STD-04)."""
    verify_student_access(id, current_user)
    courses = await StudentService.get_enrolled_courses(
        db, current_user.college_id, id
    )
    return APIResponse(data=courses)


@router.get("/{id}/materials", response_model=APIResponse[List[CourseMaterialResponse]])
async def get_all_enrolled_materials(
    id: UUID,
    current_user: User = Depends(RequireRole(["STUDENT", "ADMIN"])),
    db: AsyncSession = Depends(get_tenant_session),
):
    """Download and view course materials shared across enrolled courses (STD-04)."""
    verify_student_access(id, current_user)
    materials = await StudentService.get_student_all_materials(
        db, current_user.college_id, id
    )
    return APIResponse(data=materials)


@router.get("/materials/{course_id}", response_model=APIResponse[List[CourseMaterialResponse]])
async def get_course_materials_by_id(
    course_id: UUID,
    current_user: User = Depends(RequireRole(["STUDENT", "ADMIN"])),
    db: AsyncSession = Depends(get_tenant_session),
):
    """View materials for a specific course (STD-04)."""
    materials = await StudentService.get_student_course_materials(
        db, current_user.college_id, course_id
    )
    return APIResponse(data=materials)


# ----------------------------------------------------
# STD-05: Academic Calendar
# ----------------------------------------------------
@router.get("/academic-calendar", response_model=APIResponse[List[AcademicCalendarResponse]])
async def get_academic_calendar(
    current_user: User = Depends(RequireRole(["STUDENT", "FACULTY", "ADMIN"])),
    db: AsyncSession = Depends(get_tenant_session),
):
    """View academic calendar with exams and holidays (STD-05)."""
    events = await StudentService.get_academic_calendar(
        db, current_user.college_id
    )
    return APIResponse(
        data=[AcademicCalendarResponse.model_validate(e) for e in events]
    )


# ----------------------------------------------------
# STD-06: Announcements Feed
# ----------------------------------------------------
@router.get("/announcements", response_model=APIResponse[List[AnnouncementResponse]])
async def get_student_announcements(
    current_user: User = Depends(RequireRole(["STUDENT"])),
    db: AsyncSession = Depends(get_tenant_session),
):
    """View global institutional announcements feed where target_role IN ('ALL', 'STUDENT') (STD-06)."""
    announcements = await StudentService.get_student_announcements(
        db, current_user.college_id
    )
    return APIResponse(
        data=[AnnouncementResponse.model_validate(a) for a in announcements]
    )
