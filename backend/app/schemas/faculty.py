import datetime
from typing import List, Optional
from uuid import UUID
from pydantic import BaseModel, ConfigDict, Field


class AttendanceRecordEntry(BaseModel):
    student_id: UUID
    status: str = Field(..., pattern="^(PRESENT|ABSENT|LATE|EXCUSED)$")
    remarks: Optional[str] = None


class BatchAttendanceCreate(BaseModel):
    course_id: UUID
    date_recorded: datetime.date
    records: List[AttendanceRecordEntry]


class AttendanceUpdate(BaseModel):
    status: str = Field(..., pattern="^(PRESENT|ABSENT|LATE|EXCUSED)$")
    remarks: Optional[str] = None


class TimetableSlotResponse(BaseModel):
    timetable_id: UUID
    course_id: UUID
    course_code: str
    course_name: str
    day_of_week: str
    start_time: datetime.time
    end_time: datetime.time
    room_number: str

    model_config = ConfigDict(from_attributes=True)


class AssignedCourseResponse(BaseModel):
    course_id: UUID
    course_code: str
    course_name: str
    department: str
    credits: int
    semester: str

    model_config = ConfigDict(from_attributes=True)


class CourseAttendanceMetrics(BaseModel):
    course_id: UUID
    course_code: str
    course_name: str
    total_enrolled: int
    total_records: int
    average_attendance_rate: float


class StudentRosterItem(BaseModel):
    student_id: UUID
    roll_number: str
    first_name: str
    last_name: str
    enrollment_year: str
    semester: str

    model_config = ConfigDict(from_attributes=True)


class GradeEntry(BaseModel):
    student_id: UUID
    assessment_name: str = Field(..., min_length=1, max_length=100)
    score: float = Field(..., ge=0)
    max_score: float = Field(default=100.0, gt=0)
    remarks: Optional[str] = None


class BatchGradeCreate(BaseModel):
    grades: List[GradeEntry]


class GradeResponse(BaseModel):
    grade_id: UUID
    student_id: UUID
    student_name: str
    course_id: UUID
    assessment_name: str
    score: float
    max_score: float
    remarks: Optional[str] = None
    graded_at: datetime.datetime

    model_config = ConfigDict(from_attributes=True)


class GradeUpdate(BaseModel):
    score: Optional[float] = Field(None, ge=0)
    max_score: Optional[float] = Field(None, gt=0)
    remarks: Optional[str] = None


class CourseMaterialCreate(BaseModel):
    course_id: UUID
    title: str = Field(..., min_length=1, max_length=200)
    description: Optional[str] = None
    file_url: str = Field(..., min_length=1, max_length=500)
    file_type: str = Field(..., min_length=1, max_length=50)


class CourseMaterialResponse(BaseModel):
    material_id: UUID
    course_id: UUID
    faculty_id: UUID
    title: str
    description: Optional[str] = None
    file_url: str
    file_type: str
    uploaded_at: datetime.datetime

    model_config = ConfigDict(from_attributes=True)
