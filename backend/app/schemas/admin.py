import datetime
from typing import List, Optional
from uuid import UUID
from pydantic import BaseModel, ConfigDict


class AttendanceSummaryItem(BaseModel):
    course_id: UUID
    course_code: str
    course_name: str
    department: str
    total_records: int
    present_count: int
    absent_count: int
    attendance_percentage: float


class AttendanceSummaryResponse(BaseModel):
    college_id: UUID
    overall_percentage: float
    total_records: int
    by_course: List[AttendanceSummaryItem]

    model_config = ConfigDict(from_attributes=True)


class AttendanceTrendItem(BaseModel):
    date_recorded: datetime.date
    department: str
    total_records: int
    present_count: int
    attendance_percentage: float


class FacultyActivityItem(BaseModel):
    faculty_id: UUID
    employee_code: str
    name: str
    department: str
    designation: Optional[str] = None
    classes_scheduled: int
    attendance_sessions_logged: int
    materials_uploaded: int
    grades_awarded: int


class FacultyAttendanceLogItem(BaseModel):
    attendance_id: UUID
    student_id: UUID
    student_name: str
    course_id: UUID
    course_code: str
    course_name: str
    date_recorded: datetime.date
    status: str
    remarks: Optional[str] = None
    created_at: datetime.datetime

    model_config = ConfigDict(from_attributes=True)
