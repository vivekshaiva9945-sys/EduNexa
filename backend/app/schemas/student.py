import datetime
from typing import List, Optional
from uuid import UUID
from pydantic import BaseModel, ConfigDict


class StudentAttendanceItem(BaseModel):
    course_id: UUID
    course_code: str
    course_name: str
    total_classes: int
    attended_classes: int
    percentage: float


class StudentAttendanceOverview(BaseModel):
    student_id: UUID
    overall_percentage: float
    courses: List[StudentAttendanceItem]


class StudentAttendanceDetailItem(BaseModel):
    attendance_id: UUID
    course_id: UUID
    date_recorded: datetime.date
    status: str
    remarks: Optional[str] = None
    faculty_name: Optional[str] = None

    model_config = ConfigDict(from_attributes=True)


class StudentTimetableSlot(BaseModel):
    timetable_id: UUID
    course_id: UUID
    course_code: str
    course_name: str
    faculty_name: str
    day_of_week: str
    start_time: datetime.time
    end_time: datetime.time
    room_number: str

    model_config = ConfigDict(from_attributes=True)


class StudentGradeItem(BaseModel):
    grade_id: UUID
    course_id: UUID
    course_code: str
    course_name: str
    assessment_name: str
    score: float
    max_score: float
    percentage: float
    remarks: Optional[str] = None


class ProgressReport(BaseModel):
    student_id: UUID
    total_courses: int
    gpa: float
    letter_grade: str
    grades: List[StudentGradeItem]


class StudentCourseItem(BaseModel):
    course_id: UUID
    course_code: str
    course_name: str
    department: str
    credits: int
    semester: str
    enrolled_at: datetime.datetime

    model_config = ConfigDict(from_attributes=True)
