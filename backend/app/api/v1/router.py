from fastapi import APIRouter

from app.api.v1.endpoints import admin, auth, faculty, student

api_v1_router = APIRouter()

api_v1_router.include_router(auth.router)
api_v1_router.include_router(admin.router)
api_v1_router.include_router(faculty.router)
api_v1_router.include_router(student.router)
