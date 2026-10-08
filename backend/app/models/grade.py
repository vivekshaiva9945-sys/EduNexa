import datetime
import uuid
from sqlalchemy import (
    Column,
    String,
    ForeignKey,
    DateTime,
    Numeric,
    Text,
    Index,
)
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
from app.db.base import Base


class Grade(Base):
    __tablename__ = "grades"

    grade_id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
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
    course_id = Column(
        UUID(as_uuid=True),
        ForeignKey("courses.course_id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    faculty_id = Column(
        UUID(as_uuid=True),
        ForeignKey("faculty.faculty_id", ondelete="SET NULL"),
        nullable=True,
    )
    assessment_name = Column(String(100), nullable=False)
    score = Column(Numeric(5, 2), nullable=False)
    max_score = Column(Numeric(5, 2), default=100.00, nullable=False)
    remarks = Column(Text, nullable=True)
    graded_at = Column(
        DateTime(timezone=True),
        default=lambda: datetime.datetime.now(datetime.timezone.utc),
        nullable=False,
    )

    __table_args__ = (
        Index("idx_grades_student_course", "college_id", "student_id", "course_id"),
    )

    student = relationship("Student", back_populates="grades")
    course = relationship("Course", back_populates="grades")
    faculty = relationship("Faculty")
