import datetime
import uuid
from sqlalchemy import (
    Column,
    String,
    Date,
    ForeignKey,
    DateTime,
    Text,
    CheckConstraint,
    Index,
)
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
from app.db.base import Base


class Attendance(Base):
    __tablename__ = "attendance"

    attendance_id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
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
    faculty_id = Column(
        UUID(as_uuid=True),
        ForeignKey("faculty.faculty_id", ondelete="SET NULL"),
        nullable=True,
    )
    course_id = Column(
        UUID(as_uuid=True),
        ForeignKey("courses.course_id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    date_recorded = Column(Date, nullable=False)
    status = Column(String(20), nullable=False)
    remarks = Column(Text, nullable=True)
    created_at = Column(
        DateTime(timezone=True),
        default=lambda: datetime.datetime.now(datetime.timezone.utc),
        nullable=False,
    )

    __table_args__ = (
        CheckConstraint(
            "status IN ('PRESENT', 'ABSENT', 'LATE', 'EXCUSED')",
            name="check_attendance_status",
        ),
        Index("idx_attendance_student_date", "college_id", "student_id", "date_recorded"),
        Index("idx_attendance_course_date", "college_id", "course_id", "date_recorded"),
    )

    student = relationship("Student", back_populates="attendances")
    course = relationship("Course", back_populates="attendances")
    faculty = relationship("Faculty")
