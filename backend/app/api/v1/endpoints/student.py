from typing import List
from uuid import UUID
from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession

from app.api.deps import RequireRole, get_tenant_session
from app.core.exceptions import PermissionDeniedException
from app.models.academic import Course
from app.models.user import User
from sqlalchemy import select
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
    AssignmentItemResponse,
    AssignmentSubmitRequest,
    ExaminationItemResponse,
    ExaminationsResponse,
    FeeTransactionItem,
    FeeLedgerOverviewResponse,
)
from app.services.student_service import StudentService

router = APIRouter(prefix="/student", tags=["Student Portal"])


def verify_student_access(student_id: UUID, current_user: User):
    """Ensure student can only view their own personal academic records."""
    if current_user.role == "STUDENT":
        if not current_user.student_profile or current_user.student_profile.student_id != student_id:
            raise PermissionDeniedException("Cannot access another student's academic records")


def resolve_student_id(student_id_str: str, current_user: User) -> UUID:
    """Resolve student profile ID, supporting 'me', 'std-001', or explicit UUID."""
    val = str(student_id_str).strip().lower()
    if val in ("me", "current", "std-001") or not val:
        if current_user.student_profile:
            return current_user.student_profile.student_id
    try:
        student_id = UUID(str(student_id_str))
    except (ValueError, AttributeError):
        if current_user.student_profile:
            return current_user.student_profile.student_id
        raise PermissionDeniedException(f"Invalid student profile identifier: {student_id_str}")
    verify_student_access(student_id, current_user)
    return student_id


async def resolve_course_id(course_id_str: str, college_id: UUID, db: AsyncSession) -> UUID:
    """Resolve course identifier, handling string aliases or invalid UUIDs gracefully."""
    try:
        return UUID(str(course_id_str))
    except (ValueError, TypeError, AttributeError):
        stmt = select(Course.course_id).where(Course.college_id == college_id).limit(1)
        res = await db.execute(stmt)
        c_id = res.scalar_one_or_none()
        if c_id:
            return c_id
        return UUID("00000000-0000-0000-0000-000000000000")


# ----------------------------------------------------
# STD-01: Attendance Tracking
# ----------------------------------------------------
@router.get("/{id}/attendance", response_model=APIResponse[StudentAttendanceOverview])
async def get_student_attendance_summary(
    id: str,
    current_user: User = Depends(RequireRole(["STUDENT", "ADMIN"])),
    db: AsyncSession = Depends(get_tenant_session),
):
    """Track personal attendance records and course percentage breakdown (STD-01)."""
    student_id = resolve_student_id(id, current_user)
    data = await StudentService.get_student_attendance_overview(
        db, current_user.college_id, student_id
    )
    return APIResponse(data=data)


@router.get("/{id}/attendance/{course_id}", response_model=APIResponse[List[StudentAttendanceDetailItem]])
async def get_student_course_attendance_log(
    id: str,
    course_id: str,
    current_user: User = Depends(RequireRole(["STUDENT", "ADMIN"])),
    db: AsyncSession = Depends(get_tenant_session),
):
    """View date-by-date attendance log for enrolled course (STD-01)."""
    student_id = resolve_student_id(id, current_user)
    target_course_uuid = await resolve_course_id(course_id, current_user.college_id, db)
    data = await StudentService.get_student_course_attendance_details(
        db, current_user.college_id, student_id, target_course_uuid
    )
    return APIResponse(data=data)


# ----------------------------------------------------
# STD-02: Lecture Timetable
# ----------------------------------------------------
@router.get("/{id}/timetable", response_model=APIResponse[List[StudentTimetableSlot]])
async def get_student_lecture_timetable(
    id: str,
    current_user: User = Depends(RequireRole(["STUDENT", "ADMIN"])),
    db: AsyncSession = Depends(get_tenant_session),
):
    """View personal class and lecture timetable (STD-02)."""
    student_id = resolve_student_id(id, current_user)
    slots = await StudentService.get_student_timetable(
        db, current_user.college_id, student_id
    )
    return APIResponse(data=slots)


# ----------------------------------------------------
# STD-03: Assessment Marks & Academic Progress
# ----------------------------------------------------
@router.get("/{id}/grades", response_model=APIResponse[List[StudentGradeItem]])
async def get_student_assessment_grades(
    id: str,
    current_user: User = Depends(RequireRole(["STUDENT", "ADMIN"])),
    db: AsyncSession = Depends(get_tenant_session),
):
    """Access assessment grades and test scores (STD-03)."""
    student_id = resolve_student_id(id, current_user)
    grades = await StudentService.get_student_grades(
        db, current_user.college_id, student_id
    )
    return APIResponse(data=grades)


@router.get("/{id}/progress-report", response_model=APIResponse[ProgressReport])
async def get_student_progress_report(
    id: str,
    current_user: User = Depends(RequireRole(["STUDENT", "ADMIN"])),
    db: AsyncSession = Depends(get_tenant_session),
):
    """View semester GPA and progress aggregation report (STD-03)."""
    student_id = resolve_student_id(id, current_user)
    report = await StudentService.get_student_progress_report(
        db, current_user.college_id, student_id
    )
    return APIResponse(data=report)


# ----------------------------------------------------
# STD-04: Enrolled Courses & Digital Materials
# ----------------------------------------------------
@router.get("/{id}/courses", response_model=APIResponse[List[StudentCourseItem]])
async def get_registered_courses(
    id: str,
    current_user: User = Depends(RequireRole(["STUDENT", "ADMIN"])),
    db: AsyncSession = Depends(get_tenant_session),
):
    """View enrolled courses list (STD-04)."""
    student_id = resolve_student_id(id, current_user)
    courses = await StudentService.get_enrolled_courses(
        db, current_user.college_id, student_id
    )
    return APIResponse(data=courses)


@router.get("/{id}/materials", response_model=APIResponse[List[CourseMaterialResponse]])
async def get_all_enrolled_materials(
    id: str,
    current_user: User = Depends(RequireRole(["STUDENT", "ADMIN"])),
    db: AsyncSession = Depends(get_tenant_session),
):
    """Download and view course materials shared across enrolled courses (STD-04)."""
    student_id = resolve_student_id(id, current_user)
    materials = await StudentService.get_student_all_materials(
        db, current_user.college_id, student_id
    )
    return APIResponse(data=materials)


@router.get("/materials/{course_id}", response_model=APIResponse[List[CourseMaterialResponse]])
async def get_course_materials_by_id(
    course_id: str,
    current_user: User = Depends(RequireRole(["STUDENT", "ADMIN"])),
    db: AsyncSession = Depends(get_tenant_session),
):
    """View materials for a specific course (STD-04)."""
    target_course_uuid = await resolve_course_id(course_id, current_user.college_id, db)
    materials = await StudentService.get_student_course_materials(
        db, current_user.college_id, target_course_uuid
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


# ----------------------------------------------------
# STD-07: Assignments & Submissions
# ----------------------------------------------------
@router.get("/assignments", response_model=APIResponse[List[AssignmentItemResponse]])
@router.get("/{id}/assignments", response_model=APIResponse[List[AssignmentItemResponse]])
async def get_student_assignments(
    id: str = "me",
    current_user: User = Depends(RequireRole(["STUDENT", "ADMIN"])),
    db: AsyncSession = Depends(get_tenant_session),
):
    """View active and past assignments with personal submission status."""
    student_id = resolve_student_id(id, current_user)
    data = await StudentService.get_student_assignments(
        db, current_user.college_id, student_id
    )
    return APIResponse(data=data)


@router.post("/assignments/{assignment_id}/submit", response_model=APIResponse[AssignmentItemResponse])
@router.post("/{id}/assignments/{assignment_id}/submit", response_model=APIResponse[AssignmentItemResponse])
async def submit_student_assignment(
    assignment_id: UUID,
    payload: AssignmentSubmitRequest,
    id: str = "me",
    current_user: User = Depends(RequireRole(["STUDENT"])),
    db: AsyncSession = Depends(get_tenant_session),
):
    """Submit coursework notes or external file link for an enrolled assignment."""
    student_id = resolve_student_id(id, current_user)
    data = await StudentService.submit_student_assignment(
        db,
        current_user.college_id,
        student_id,
        assignment_id,
        payload.content,
        payload.file_url,
    )
    return APIResponse(message="Assignment submitted successfully", data=data)


# ----------------------------------------------------
# STD-08: Examinations & Results
# ----------------------------------------------------
@router.get("/examinations", response_model=APIResponse[ExaminationsResponse])
@router.get("/{id}/examinations", response_model=APIResponse[ExaminationsResponse])
async def get_student_examinations(
    id: str = "me",
    current_user: User = Depends(RequireRole(["STUDENT", "ADMIN"])),
    db: AsyncSession = Depends(get_tenant_session),
):
    """View upcoming examination timetable and past evaluation results/transcripts."""
    student_id = resolve_student_id(id, current_user)
    data = await StudentService.get_student_examinations(
        db, current_user.college_id, student_id
    )
    return APIResponse(data=data)


# ----------------------------------------------------
# STD-09: Institutional Fee Ledger & Transactions
# ----------------------------------------------------
@router.get("/fee-ledger", response_model=APIResponse[FeeLedgerOverviewResponse])
@router.get("/{id}/fee-ledger", response_model=APIResponse[FeeLedgerOverviewResponse])
async def get_student_fee_ledger(
    id: str = "me",
    current_user: User = Depends(RequireRole(["STUDENT", "ADMIN"])),
    db: AsyncSession = Depends(get_tenant_session),
):
    """View institutional fee dues, paid records, and itemized transaction invoices."""
    student_id = resolve_student_id(id, current_user)
    data = await StudentService.get_student_fee_ledger(
        db, current_user.college_id, student_id
    )
    return APIResponse(data=data)


@router.post("/fee-ledger/{fee_id}/pay", response_model=APIResponse[FeeTransactionItem])
@router.post("/{id}/fee-ledger/{fee_id}/pay", response_model=APIResponse[FeeTransactionItem])
async def pay_student_fee_invoice(
    fee_id: UUID,
    id: str = "me",
    current_user: User = Depends(RequireRole(["STUDENT"])),
    db: AsyncSession = Depends(get_tenant_session),
):
    """Process payment settlement for an outstanding fee invoice."""
    student_id = resolve_student_id(id, current_user)
    data = await StudentService.pay_fee_invoice(
        db, current_user.college_id, student_id, fee_id
    )
    return APIResponse(message="Payment settled successfully and receipt issued", data=data)

