from typing import List
from uuid import UUID
from fastapi import APIRouter, Depends, status
from sqlalchemy.ext.asyncio import AsyncSession

from app.api.deps import RequireRole, get_tenant_session
from app.core.exceptions import PermissionDeniedException
from app.models.user import User
from app.schemas.common import APIResponse, MessageResponse
from app.schemas.faculty import (
    AssignedCourseResponse,
    AttendanceUpdate,
    BatchAttendanceCreate,
    BatchGradeCreate,
    CourseAttendanceMetrics,
    CourseMaterialCreate,
    CourseMaterialResponse,
    GradeResponse,
    GradeUpdate,
    StudentRosterItem,
    TimetableSlotResponse,
)
from app.schemas.portal import AnnouncementResponse
from app.services.faculty_service import FacultyService

router = APIRouter(prefix="/faculty", tags=["Faculty Portal"])


def verify_faculty_access(faculty_id: UUID, current_user: User):
    """Ensure faculty can only perform write/read actions for their own assigned profile."""
    if current_user.role == "FACULTY":
        if not current_user.faculty_profile or current_user.faculty_profile.faculty_id != faculty_id:
            raise PermissionDeniedException("Cannot operate on another faculty member's profile")


# ----------------------------------------------------
# FAC-01 & FAC-03: Attendance Operations
# ----------------------------------------------------
@router.post("/{id}/attendance", response_model=APIResponse[dict], status_code=status.HTTP_201_CREATED)
async def record_attendance_batch(
    id: UUID,
    data: BatchAttendanceCreate,
    current_user: User = Depends(RequireRole(["FACULTY", "ADMIN"])),
    db: AsyncSession = Depends(get_tenant_session),
):
    """Record daily attendance for assigned course sections (FAC-01)."""
    verify_faculty_access(id, current_user)
    count = await FacultyService.batch_record_attendance(
        db, current_user.college_id, id, data
    )
    return APIResponse(
        message=f"Successfully recorded attendance for {count} students",
        data={"recorded_count": count},
    )


@router.put("/attendance/{attendance_id}", response_model=APIResponse[dict])
async def update_attendance_log(
    attendance_id: UUID,
    data: AttendanceUpdate,
    current_user: User = Depends(RequireRole(["FACULTY", "ADMIN"])),
    db: AsyncSession = Depends(get_tenant_session),
):
    """Update individual attendance status and remarks (FAC-01)."""
    updated = await FacultyService.update_attendance_record(
        db, current_user.college_id, attendance_id, data
    )
    return APIResponse(
        message="Attendance record updated",
        data={"attendance_id": str(updated.attendance_id), "status": updated.status},
    )


# ----------------------------------------------------
# FAC-02: Teaching Timetable & Course Roster
# ----------------------------------------------------
@router.get("/{id}/timetable", response_model=APIResponse[List[TimetableSlotResponse]])
async def get_teaching_timetable(
    id: UUID,
    current_user: User = Depends(RequireRole(["FACULTY", "ADMIN"])),
    db: AsyncSession = Depends(get_tenant_session),
):
    """Access personal teaching schedule (FAC-02)."""
    verify_faculty_access(id, current_user)
    slots = await FacultyService.get_faculty_timetable(db, current_user.college_id, id)
    return APIResponse(data=slots)


@router.get("/{id}/courses", response_model=APIResponse[List[AssignedCourseResponse]])
async def get_assigned_courses(
    id: UUID,
    current_user: User = Depends(RequireRole(["FACULTY", "ADMIN"])),
    db: AsyncSession = Depends(get_tenant_session),
):
    """List assigned courses and active sections (FAC-02, FAC-03)."""
    verify_faculty_access(id, current_user)
    courses = await FacultyService.get_assigned_courses(db, current_user.college_id, id)
    return APIResponse(data=courses)


@router.get("/courses/{course_id}/attendance-metrics", response_model=APIResponse[CourseAttendanceMetrics])
async def get_course_attendance_metrics(
    course_id: UUID,
    current_user: User = Depends(RequireRole(["FACULTY", "ADMIN"])),
    db: AsyncSession = Depends(get_tenant_session),
):
    """View attendance metrics for assigned course students (FAC-03)."""
    metrics = await FacultyService.get_course_attendance_metrics(
        db, current_user.college_id, course_id
    )
    return APIResponse(data=metrics)


@router.get("/courses/{course_id}/students", response_model=APIResponse[List[StudentRosterItem]])
async def get_course_student_roster(
    course_id: UUID,
    current_user: User = Depends(RequireRole(["FACULTY", "ADMIN"])),
    db: AsyncSession = Depends(get_tenant_session),
):
    """Fetch student roster for course (FAC-01, FAC-03, FAC-04)."""
    students = await FacultyService.get_course_students(
        db, current_user.college_id, course_id
    )
    return APIResponse(data=students)


# ----------------------------------------------------
# FAC-04: Grades & Assessments
# ----------------------------------------------------
@router.post("/{id}/marks", response_model=APIResponse[dict], status_code=status.HTTP_201_CREATED)
async def upload_course_marks(
    id: UUID,
    course_id: UUID,
    data: BatchGradeCreate,
    current_user: User = Depends(RequireRole(["FACULTY", "ADMIN"])),
    db: AsyncSession = Depends(get_tenant_session),
):
    """Upload assessment grades and test scores (FAC-04)."""
    verify_faculty_access(id, current_user)
    count = await FacultyService.batch_upload_grades(
        db, current_user.college_id, id, course_id, data
    )
    return APIResponse(
        message=f"Uploaded {count} grades successfully",
        data={"grades_recorded": count},
    )


@router.get("/courses/{course_id}/grades", response_model=APIResponse[List[GradeResponse]])
async def get_course_grades(
    course_id: UUID,
    current_user: User = Depends(RequireRole(["FACULTY", "ADMIN"])),
    db: AsyncSession = Depends(get_tenant_session),
):
    """View submitted assessment marks for a course (FAC-04)."""
    grades = await FacultyService.get_course_grades(
        db, current_user.college_id, course_id
    )
    return APIResponse(data=grades)


@router.put("/grades/{grade_id}", response_model=APIResponse[dict])
async def update_grade(
    grade_id: UUID,
    data: GradeUpdate,
    current_user: User = Depends(RequireRole(["FACULTY", "ADMIN"])),
    db: AsyncSession = Depends(get_tenant_session),
):
    """Modify or correct an assessment grade (FAC-04)."""
    updated = await FacultyService.update_grade(db, current_user.college_id, grade_id, data)
    return APIResponse(
        message="Grade updated successfully",
        data={
            "grade_id": str(updated.grade_id),
            "score": float(updated.score),
            "max_score": float(updated.max_score),
        },
    )


# ----------------------------------------------------
# FAC-05: Digital Course Materials
# ----------------------------------------------------
@router.post("/materials", response_model=APIResponse[CourseMaterialResponse], status_code=status.HTTP_201_CREATED)
async def upload_course_material(
    data: CourseMaterialCreate,
    current_user: User = Depends(RequireRole(["FACULTY"])),
    db: AsyncSession = Depends(get_tenant_session),
):
    """Distribute digital course materials to class (FAC-05)."""
    faculty_id = current_user.faculty_profile.faculty_id
    material = await FacultyService.upload_course_material(
        db, current_user.college_id, faculty_id, data
    )
    return APIResponse(
        message="Material published successfully",
        data=material,
    )


@router.get("/courses/{course_id}/materials", response_model=APIResponse[List[CourseMaterialResponse]])
async def list_course_materials(
    course_id: UUID,
    current_user: User = Depends(RequireRole(["FACULTY", "ADMIN"])),
    db: AsyncSession = Depends(get_tenant_session),
):
    """List uploaded course materials for course (FAC-05)."""
    materials = await FacultyService.get_course_materials(
        db, current_user.college_id, course_id
    )
    return APIResponse(data=materials)


@router.delete("/materials/{material_id}", response_model=MessageResponse)
async def delete_material(
    material_id: UUID,
    current_user: User = Depends(RequireRole(["FACULTY", "ADMIN"])),
    db: AsyncSession = Depends(get_tenant_session),
):
    """Remove uploaded course material (FAC-05)."""
    await FacultyService.delete_course_material(db, current_user.college_id, material_id)
    return MessageResponse(message="Course material removed successfully")


# ----------------------------------------------------
# FAC-06: Announcements Feed
# ----------------------------------------------------
@router.get("/announcements", response_model=APIResponse[List[AnnouncementResponse]])
async def get_faculty_announcements(
    current_user: User = Depends(RequireRole(["FACULTY"])),
    db: AsyncSession = Depends(get_tenant_session),
):
    """View institutional announcements feed where target_role IN ('ALL', 'FACULTY') (FAC-06)."""
    announcements = await FacultyService.get_faculty_announcements(
        db, current_user.college_id
    )
    return APIResponse(
        data=[AnnouncementResponse.model_validate(a) for a in announcements]
    )
