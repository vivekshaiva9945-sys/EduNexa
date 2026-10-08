import datetime
import uuid
from sqlalchemy import (
    Column,
    String,
    ForeignKey,
    DateTime,
    Date,
    Text,
    CheckConstraint,
    Index,
)
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
from app.db.base import Base


class CourseMaterial(Base):
    __tablename__ = "course_materials"

    material_id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
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
    faculty_id = Column(
        UUID(as_uuid=True),
        ForeignKey("faculty.faculty_id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    title = Column(String(200), nullable=False)
    description = Column(Text, nullable=True)
    file_url = Column(String(500), nullable=False)
    file_type = Column(String(50), nullable=False)
    uploaded_at = Column(
        DateTime(timezone=True),
        default=lambda: datetime.datetime.now(datetime.timezone.utc),
        nullable=False,
    )

    __table_args__ = (
        Index("idx_materials_course", "college_id", "course_id"),
    )

    course = relationship("Course", back_populates="materials")
    faculty = relationship("Faculty", back_populates="materials")


class Announcement(Base):
    __tablename__ = "announcements"

    announcement_id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    college_id = Column(
        UUID(as_uuid=True),
        ForeignKey("colleges.college_id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    author_id = Column(
        UUID(as_uuid=True),
        ForeignKey("users.user_id", ondelete="SET NULL"),
        nullable=True,
    )
    title = Column(String(255), nullable=False)
    content = Column(Text, nullable=False)
    target_role = Column(String(20), default="ALL", nullable=False)
    created_at = Column(
        DateTime(timezone=True),
        default=lambda: datetime.datetime.now(datetime.timezone.utc),
        nullable=False,
    )

    __table_args__ = (
        CheckConstraint(
            "target_role IN ('ALL', 'FACULTY', 'STUDENT')",
            name="check_announcement_target_role",
        ),
        Index("idx_announcements_feed", "college_id", created_at.desc()),
    )

    author = relationship("User")


class AcademicCalendar(Base):
    __tablename__ = "academic_calendar"

    event_id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    college_id = Column(
        UUID(as_uuid=True),
        ForeignKey("colleges.college_id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    event_title = Column(String(200), nullable=False)
    event_type = Column(String(30), nullable=False)
    start_date = Column(Date, nullable=False)
    end_date = Column(Date, nullable=False)
    description = Column(Text, nullable=True)
    created_at = Column(
        DateTime(timezone=True),
        default=lambda: datetime.datetime.now(datetime.timezone.utc),
        nullable=False,
    )

    __table_args__ = (
        CheckConstraint(
            "event_type IN ('EXAM', 'HOLIDAY', 'EVENT', 'WORKSHOP')",
            name="check_calendar_event_type",
        ),
        Index("idx_calendar_dates", "college_id", "start_date", "end_date"),
    )
