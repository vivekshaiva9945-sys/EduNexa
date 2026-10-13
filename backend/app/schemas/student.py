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


# ----------------------------------------------------
# Assignments Schemas
# ----------------------------------------------------
class AssignmentItemResponse(BaseModel):
    assignment_id: UUID
    course_id: UUID
    course_code: str
    course_name: str
    title: str
    description: Optional[str] = None
    due_date: datetime.datetime
    total_marks: float
    status: str  # PENDING, SUBMITTED, GRADED, LATE
    submission_id: Optional[UUID] = None
    submission_date: Optional[datetime.datetime] = None
    marks_obtained: Optional[float] = None
    feedback: Optional[str] = None
    content: Optional[str] = None
    file_url: Optional[str] = None
    is_submitted: bool = False
    is_overdue: bool = False

    model_config = ConfigDict(from_attributes=True)


class AssignmentSubmitRequest(BaseModel):
    content: Optional[str] = None
    file_url: Optional[str] = None


# ----------------------------------------------------
# Examinations Schemas
# ----------------------------------------------------
class ExaminationItemResponse(BaseModel):
    exam_id: UUID
    course_id: UUID
    course_code: str
    course_name: str
    title: str
    exam_date: datetime.datetime
    duration_minutes: int
    venue: str
    exam_type: str
    total_marks: float
    marks_obtained: Optional[float] = None
    grade: Optional[str] = None
    remarks: Optional[str] = None
    is_past: bool = False

    model_config = ConfigDict(from_attributes=True)


class ExaminationsResponse(BaseModel):
    upcoming: List[ExaminationItemResponse]
    results: List[ExaminationItemResponse]


# ----------------------------------------------------
# Fee Ledger Schemas
# ----------------------------------------------------
class FeeTransactionItem(BaseModel):
    fee_id: UUID
    description: str
    amount: float
    fee_type: str
    due_date: datetime.date
    status: str  # PAID, UNPAID, OVERDUE, PARTIALLY_PAID
    payment_date: Optional[datetime.datetime] = None
    receipt_number: Optional[str] = None
    payment_method: Optional[str] = None

    model_config = ConfigDict(from_attributes=True)


class FeeLedgerOverviewResponse(BaseModel):
    student_id: UUID
    total_dues: float
    total_paid: float
    total_overdue: float
    pending_invoices_count: int
    transactions: List[FeeTransactionItem]

