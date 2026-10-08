import datetime
from typing import List, Optional
from uuid import UUID
from fastapi import APIRouter, Depends, Query, status
from sqlalchemy.ext.asyncio import AsyncSession

from app.api.deps import RequireRole, get_tenant_session
from app.models.user import User
from app.schemas.admin import (
    AttendanceSummaryResponse,
    AttendanceTrendItem,
    FacultyActivityItem,
    FacultyAttendanceLogItem,
)
from app.schemas.common import APIResponse, MessageResponse
from app.schemas.portal import (
    AcademicCalendarCreate,
    AcademicCalendarResponse,
    AnnouncementCreate,
    AnnouncementResponse,
    AnnouncementUpdate,
)
from app.services.admin_service import AdminService

router = APIRouter(prefix="/admin", tags=["Admin Portal"])


# ----------------------------------------------------
# ADM-01: Aggregated Attendance
# ----------------------------------------------------
@router.get("/attendance/summary", response_model=APIResponse[AttendanceSummaryResponse])
async def get_attendance_summary(
    current_user: User = Depends(RequireRole(["ADMIN"])),
    db: AsyncSession = Depends(get_tenant_session),
):
    """View aggregated, college-wide student attendance statistics across departments (ADM-01)."""
    data = await AdminService.get_attendance_summary(db, current_user.college_id)
    return APIResponse(data=data)


@router.get("/attendance/trends", response_model=APIResponse[List[AttendanceTrendItem]])
async def get_attendance_trends(
    current_user: User = Depends(RequireRole(["ADMIN"])),
    db: AsyncSession = Depends(get_tenant_session),
):
    """View daily/weekly attendance trends broken down by department (ADM-01)."""
    data = await AdminService.get_attendance_trends(db, current_user.college_id)
    return APIResponse(data=data)


# ----------------------------------------------------
# ADM-02: Announcements
# ----------------------------------------------------
@router.post("/announcements", response_model=APIResponse[AnnouncementResponse], status_code=status.HTTP_201_CREATED)
async def create_announcement(
    data: AnnouncementCreate,
    current_user: User = Depends(RequireRole(["ADMIN"])),
    db: AsyncSession = Depends(get_tenant_session),
):
    """Publish global announcements to the institutional feed (ADM-02)."""
    announcement = await AdminService.create_announcement(
        db, current_user.college_id, current_user.user_id, data
    )
    return APIResponse(
        message="Announcement published successfully",
        data=AnnouncementResponse.model_validate(announcement),
    )


@router.get("/announcements", response_model=APIResponse[List[AnnouncementResponse]])
async def list_announcements(
    target_role: Optional[str] = Query(None, pattern="^(ALL|FACULTY|STUDENT)$"),
    current_user: User = Depends(RequireRole(["ADMIN"])),
    db: AsyncSession = Depends(get_tenant_session),
):
    """View all institutional announcements ordered by recency (ADM-02)."""
    items = await AdminService.get_announcements(db, current_user.college_id, target_role)
    return APIResponse(data=[AnnouncementResponse.model_validate(item) for item in items])


@router.put("/announcements/{id}", response_model=APIResponse[AnnouncementResponse])
async def update_announcement(
    id: UUID,
    data: AnnouncementUpdate,
    current_user: User = Depends(RequireRole(["ADMIN"])),
    db: AsyncSession = Depends(get_tenant_session),
):
    """Update existing institutional notice (ADM-02)."""
    updated = await AdminService.update_announcement(db, current_user.college_id, id, data)
    return APIResponse(
        message="Announcement updated successfully",
        data=AnnouncementResponse.model_validate(updated),
    )


@router.delete("/announcements/{id}", response_model=MessageResponse)
async def delete_announcement(
    id: UUID,
    current_user: User = Depends(RequireRole(["ADMIN"])),
    db: AsyncSession = Depends(get_tenant_session),
):
    """Delete announcement from institutional feed (ADM-02)."""
    await AdminService.delete_announcement(db, current_user.college_id, id)
    return MessageResponse(message="Announcement deleted successfully")


# ----------------------------------------------------
# ADM-03: Faculty Productivity & Activity Logs
# ----------------------------------------------------
@router.get("/faculty/activity", response_model=APIResponse[List[FacultyActivityItem]])
async def get_faculty_activity(
    current_user: User = Depends(RequireRole(["ADMIN"])),
    db: AsyncSession = Depends(get_tenant_session),
):
    """View faculty attendance and academic activity records (ADM-03)."""
    data = await AdminService.get_faculty_activity(db, current_user.college_id)
    return APIResponse(data=data)


@router.get("/faculty/{id}/attendance-logs", response_model=APIResponse[List[FacultyAttendanceLogItem]])
async def get_faculty_attendance_logs(
    id: UUID,
    current_user: User = Depends(RequireRole(["ADMIN"])),
    db: AsyncSession = Depends(get_tenant_session),
):
    """View attendance logging history for a specific faculty member (ADM-03)."""
    data = await AdminService.get_faculty_attendance_logs(db, current_user.college_id, id)
    return APIResponse(data=data)


# ----------------------------------------------------
# ENT-09: Academic Calendar Management
# ----------------------------------------------------
@router.post("/academic-calendar", response_model=APIResponse[AcademicCalendarResponse], status_code=status.HTTP_201_CREATED)
async def create_calendar_event(
    data: AcademicCalendarCreate,
    current_user: User = Depends(RequireRole(["ADMIN"])),
    db: AsyncSession = Depends(get_tenant_session),
):
    """Create institutional academic calendar event (ENT-09)."""
    event = await AdminService.create_calendar_event(db, current_user.college_id, data)
    return APIResponse(
        message="Academic calendar event created",
        data=AcademicCalendarResponse.model_validate(event),
    )


@router.get("/academic-calendar", response_model=APIResponse[List[AcademicCalendarResponse]])
async def get_calendar_events(
    start_date: Optional[datetime.date] = None,
    end_date: Optional[datetime.date] = None,
    current_user: User = Depends(RequireRole(["ADMIN"])),
    db: AsyncSession = Depends(get_tenant_session),
):
    """View institutional academic calendar events within date range (ENT-09)."""
    events = await AdminService.get_calendar_events(
        db, current_user.college_id, start_date=start_date, end_date=end_date
    )
    return APIResponse(data=[AcademicCalendarResponse.model_validate(e) for e in events])
