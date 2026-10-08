import datetime
from typing import Optional
from uuid import UUID
from pydantic import BaseModel, ConfigDict, Field


class AnnouncementCreate(BaseModel):
    title: str = Field(..., min_length=1, max_length=255)
    content: str = Field(..., min_length=1)
    target_role: str = Field(default="ALL", pattern="^(ALL|FACULTY|STUDENT)$")


class AnnouncementUpdate(BaseModel):
    title: Optional[str] = Field(None, min_length=1, max_length=255)
    content: Optional[str] = None
    target_role: Optional[str] = Field(None, pattern="^(ALL|FACULTY|STUDENT)$")


class AnnouncementResponse(BaseModel):
    announcement_id: UUID
    college_id: UUID
    author_id: Optional[UUID] = None
    title: str
    content: str
    target_role: str
    created_at: datetime.datetime

    model_config = ConfigDict(from_attributes=True)


class AcademicCalendarCreate(BaseModel):
    event_title: str = Field(..., min_length=1, max_length=200)
    event_type: str = Field(..., pattern="^(EXAM|HOLIDAY|EVENT|WORKSHOP)$")
    start_date: datetime.date
    end_date: datetime.date
    description: Optional[str] = None


class AcademicCalendarResponse(BaseModel):
    event_id: UUID
    college_id: UUID
    event_title: str
    event_type: str
    start_date: datetime.date
    end_date: datetime.date
    description: Optional[str] = None
    created_at: datetime.datetime

    model_config = ConfigDict(from_attributes=True)
