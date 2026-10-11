import datetime
from typing import Any, List, Optional, Union
from uuid import UUID
from pydantic import BaseModel, ConfigDict, Field, field_validator


class AttendanceRecordEntry(BaseModel):
    student_id: Union[UUID, str]
    status: Optional[str] = "PRESENT"
    remarks: Optional[str] = None

    @field_validator("status", mode="before")
    @classmethod
    def normalize_status(cls, v: Any) -> str:
        if not v:
            return "PRESENT"
        s = str(v).strip().upper()
        if s in ("PRESENT", "ABSENT", "LATE", "EXCUSED"):
            return s
        if s in ("P", "REGULAR", "PRES"):
            return "PRESENT"
        if s in ("A", "ABS"):
            return "ABSENT"
        if s in ("L", "LT"):
            return "LATE"
        return "PRESENT"


class BatchAttendanceCreate(BaseModel):
    course_id: Optional[Union[UUID, str]] = None
    date_recorded: Optional[datetime.date] = None
    session_date: Optional[str] = None
    records: List[AttendanceRecordEntry] = Field(default_factory=list)

    @field_validator("date_recorded", mode="before")
    @classmethod
    def parse_date_recorded(cls, v: Any) -> Optional[datetime.date]:
        if not v:
            return None
        if isinstance(v, datetime.date):
            return v
        if isinstance(v, str):
            try:
                return datetime.date.fromisoformat(v.split("T")[0])
            except Exception:
                return datetime.date.today()
        return datetime.date.today()


class AttendanceUpdate(BaseModel):
    status: Optional[str] = "PRESENT"
    remarks: Optional[str] = None

    @field_validator("status", mode="before")
    @classmethod
    def normalize_status(cls, v: Any) -> str:
        if not v:
            return "PRESENT"
        s = str(v).strip().upper()
        if s in ("PRESENT", "ABSENT", "LATE", "EXCUSED"):
            return s
        if s in ("P", "REGULAR", "PRES"):
            return "PRESENT"
        if s in ("A", "ABS"):
            return "ABSENT"
        if s in ("L", "LT"):
            return "LATE"
        return "PRESENT"


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
    status: Optional[str] = "PRESENT"
    attendance_rate: Optional[float] = 88.0

    model_config = ConfigDict(from_attributes=True)


class GradeEntry(BaseModel):
    student_id: Union[UUID, str]
    assessment_name: Optional[str] = "Assessment"
    score: float = Field(default=0.0, ge=0)
    max_score: float = Field(default=100.0, gt=0)
    remarks: Optional[str] = None

    @field_validator("score", mode="before")
    @classmethod
    def normalize_score(cls, v: Any) -> float:
        try:
            return float(v) if v is not None else 0.0
        except (ValueError, TypeError):
            return 0.0

    @field_validator("max_score", mode="before")
    @classmethod
    def normalize_max_score(cls, v: Any) -> float:
        try:
            val = float(v) if v is not None else 100.0
            return val if val > 0 else 100.0
        except (ValueError, TypeError):
            return 100.0


class BatchGradeCreate(BaseModel):
    course_id: Optional[Union[UUID, str]] = None
    assessment_name: Optional[str] = None
    max_score: Optional[float] = None
    grades: List[GradeEntry] = Field(default_factory=list)


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
    course_id: Union[UUID, str]
    title: str = Field(..., min_length=1, max_length=200)
    description: Optional[str] = None
    file_url: Optional[str] = Field(
        default="https://assets.edunexa.edu/materials/lecture-material.pdf",
        max_length=500,
    )
    file_type: Optional[str] = Field(default="PDF", max_length=50)


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

