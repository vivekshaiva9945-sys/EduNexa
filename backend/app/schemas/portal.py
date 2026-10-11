import datetime
from typing import Any, Optional, Union
from uuid import UUID
from pydantic import BaseModel, ConfigDict, Field, field_validator


class AnnouncementCreate(BaseModel):
    title: str = Field(..., min_length=1, max_length=255)
    content: str = Field(..., min_length=1)
    target_role: Optional[str] = "ALL"

    @field_validator("target_role", mode="before")
    @classmethod
    def normalize_target_role(cls, v: Any) -> str:
        if not v:
            return "ALL"
        s = str(v).strip().upper()
        if s in ("ALL", "FACULTY", "STUDENT"):
            return s
        return "ALL"


class AnnouncementUpdate(BaseModel):
    title: Optional[str] = Field(None, min_length=1, max_length=255)
    content: Optional[str] = None
    target_role: Optional[str] = None

    @field_validator("target_role", mode="before")
    @classmethod
    def normalize_target_role(cls, v: Any) -> Optional[str]:
        if not v:
            return None
        s = str(v).strip().upper()
        if s in ("ALL", "FACULTY", "STUDENT"):
            return s
        return "ALL"


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
    event_type: Optional[str] = "EVENT"
    start_date: Union[datetime.date, str]
    end_date: Union[datetime.date, str]
    description: Optional[str] = None

    @field_validator("event_type", mode="before")
    @classmethod
    def normalize_event_type(cls, v: Any) -> str:
        if not v:
            return "EVENT"
        s = str(v).strip().upper()
        if s in ("EXAM", "HOLIDAY", "EVENT", "WORKSHOP"):
            return s
        return "EVENT"

    @field_validator("start_date", "end_date", mode="before")
    @classmethod
    def parse_date(cls, v: Any) -> datetime.date:
        if isinstance(v, datetime.date):
            return v
        if isinstance(v, str):
            try:
                return datetime.date.fromisoformat(v.split("T")[0])
            except Exception:
                pass
        return datetime.date.today()


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

