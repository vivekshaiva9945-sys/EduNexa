import datetime
import uuid
from sqlalchemy import (
    Column,
    String,
    Float,
    Integer,
    ForeignKey,
    DateTime,
    Date,
    Text,
    Boolean,
    UniqueConstraint,
    CheckConstraint,
    Index,
)
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
from app.db.base import Base


class Assignment(Base):
    __tablename__ = "assignments"

    assignment_id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    college_id = Column(
        UUID(as_uuid=True),
        ForeignKey("colleges.college_id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    course_id = Column(
        UUID(as_uuid=True),
        ForeignKey("courses.course_id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    title = Column(String(255), nullable=False)
    description = Column(Text, nullable=True)
    due_date = Column(DateTime(timezone=True), nullable=False)
    total_marks = Column(Float, default=100.0, nullable=False)
    created_at = Column(
        DateTime(timezone=True),
        default=lambda: datetime.datetime.now(datetime.timezone.utc),
        nullable=False,
    )
    updated_at = Column(
        DateTime(timezone=True),
        default=lambda: datetime.datetime.now(datetime.timezone.utc),
        onupdate=lambda: datetime.datetime.now(datetime.timezone.utc),
        nullable=False,
    )

    __table_args__ = (
        Index("idx_assignments_course_due", "college_id", "course_id", "due_date"),
    )

    # Relationships
    college = relationship("College")
    course = relationship("Course")
    submissions = relationship(
        "AssignmentSubmission", back_populates="assignment", cascade="all, delete-orphan"
    )


class AssignmentSubmission(Base):
    __tablename__ = "assignment_submissions"

    submission_id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    college_id = Column(
        UUID(as_uuid=True),
        ForeignKey("colleges.college_id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    assignment_id = Column(
        UUID(as_uuid=True),
        ForeignKey("assignments.assignment_id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    student_id = Column(
        UUID(as_uuid=True),
        ForeignKey("students.student_id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    submission_date = Column(
        DateTime(timezone=True),
        default=lambda: datetime.datetime.now(datetime.timezone.utc),
        nullable=False,
    )
    content = Column(Text, nullable=True)
    file_url = Column(String(500), nullable=True)
    status = Column(String(20), default="SUBMITTED", nullable=False)
    marks_obtained = Column(Float, nullable=True)
    feedback = Column(Text, nullable=True)
    created_at = Column(
        DateTime(timezone=True),
        default=lambda: datetime.datetime.now(datetime.timezone.utc),
        nullable=False,
    )
    updated_at = Column(
        DateTime(timezone=True),
        default=lambda: datetime.datetime.now(datetime.timezone.utc),
        onupdate=lambda: datetime.datetime.now(datetime.timezone.utc),
        nullable=False,
    )

    __table_args__ = (
        CheckConstraint(
            "status IN ('PENDING', 'SUBMITTED', 'GRADED', 'LATE')",
            name="check_submission_status",
        ),
        UniqueConstraint("assignment_id", "student_id", name="uq_assignment_student_submission"),
        Index("idx_submission_student", "college_id", "student_id"),
    )

    # Relationships
    college = relationship("College")
    assignment = relationship("Assignment", back_populates="submissions")
    student = relationship("Student")


class Examination(Base):
    __tablename__ = "examinations"

    exam_id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    college_id = Column(
        UUID(as_uuid=True),
        ForeignKey("colleges.college_id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    course_id = Column(
        UUID(as_uuid=True),
        ForeignKey("courses.course_id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    title = Column(String(255), nullable=False)
    exam_date = Column(DateTime(timezone=True), nullable=False)
    duration_minutes = Column(Integer, default=180, nullable=False)
    venue = Column(String(150), nullable=False)
    exam_type = Column(String(20), default="FINAL", nullable=False)
    total_marks = Column(Float, default=100.0, nullable=False)
    created_at = Column(
        DateTime(timezone=True),
        default=lambda: datetime.datetime.now(datetime.timezone.utc),
        nullable=False,
    )

    __table_args__ = (
        CheckConstraint(
            "exam_type IN ('MIDTERM', 'FINAL', 'QUIZ', 'LAB', 'PRACTICAL')",
            name="check_exam_type",
        ),
        Index("idx_exam_course_date", "college_id", "course_id", "exam_date"),
    )

    # Relationships
    college = relationship("College")
    course = relationship("Course")
    results = relationship(
        "ExaminationResult", back_populates="examination", cascade="all, delete-orphan"
    )


class ExaminationResult(Base):
    __tablename__ = "examination_results"

    result_id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    college_id = Column(
        UUID(as_uuid=True),
        ForeignKey("colleges.college_id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    exam_id = Column(
        UUID(as_uuid=True),
        ForeignKey("examinations.exam_id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    student_id = Column(
        UUID(as_uuid=True),
        ForeignKey("students.student_id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    marks_obtained = Column(Float, nullable=False)
    grade = Column(String(10), nullable=True)
    remarks = Column(String(255), nullable=True)
    attended = Column(Boolean, default=True, nullable=False)
    created_at = Column(
        DateTime(timezone=True),
        default=lambda: datetime.datetime.now(datetime.timezone.utc),
        nullable=False,
    )

    __table_args__ = (
        UniqueConstraint("exam_id", "student_id", name="uq_exam_student_result"),
        Index("idx_exam_result_student", "college_id", "student_id"),
    )

    # Relationships
    college = relationship("College")
    examination = relationship("Examination", back_populates="results")
    student = relationship("Student")


class FeeLedger(Base):
    __tablename__ = "fee_ledger"

    fee_id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    college_id = Column(
        UUID(as_uuid=True),
        ForeignKey("colleges.college_id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    student_id = Column(
        UUID(as_uuid=True),
        ForeignKey("students.student_id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    description = Column(String(255), nullable=False)
    amount = Column(Float, nullable=False)
    fee_type = Column(String(50), default="TUITION", nullable=False)
    due_date = Column(Date, nullable=False)
    status = Column(String(20), default="UNPAID", nullable=False)
    payment_date = Column(DateTime(timezone=True), nullable=True)
    receipt_number = Column(String(50), nullable=True)
    payment_method = Column(String(50), nullable=True)
    created_at = Column(
        DateTime(timezone=True),
        default=lambda: datetime.datetime.now(datetime.timezone.utc),
        nullable=False,
    )

    __table_args__ = (
        CheckConstraint(
            "fee_type IN ('TUITION', 'LIBRARY', 'LABORATORY', 'HOSTEL', 'EXAMINATION', 'SPORTS', 'OTHER')",
            name="check_fee_type",
        ),
        CheckConstraint(
            "status IN ('PAID', 'UNPAID', 'OVERDUE', 'PARTIALLY_PAID')",
            name="check_fee_status",
        ),
        Index("idx_fee_student_status", "college_id", "student_id", "status"),
    )

    # Relationships
    college = relationship("College")
    student = relationship("Student")
