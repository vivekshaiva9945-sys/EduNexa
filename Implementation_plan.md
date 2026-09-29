# EDU NEXA 

## Master Implementation & Execution Plan

**Document:** Implementation_Plan  
**Project:** EduNexa  
**Reference:** Functional Requirements Specification (SRS) & Database Architecture  
**Architecture:** Multi-Tenant SaaS & 3-Container Dockerized Environment  
**Phase:** Execution & Development  

---

## 🏛️ Core Architectural Invariants & Strict Rules

To satisfy institutional security and operational requirements, the system strictly enforces two core rules:

### Rule 1: Multi-Tenant Architecture & Data Isolation
* **Single Deployment, Multiple Colleges:** A single deployed instance securely serves multiple colleges (`COLLEGE` entity).
* **Zero Data Leakage Guarantee:**
  * Every tenant-scoped entity (`Users`, `Students`, `Faculty`, `Courses`, `Attendance`, `Timetable`, `Grades`, `Course_Materials`, `Announcements`, `Academic_Calendar`) strictly references `college_id`.
  * **Enforcement Layer:** Multi-tenant isolation is enforced at two layers:
    1. **PostgreSQL Row-Level Security (RLS) & Composite Indexing:** Ensures database-level enforcement where queries automatically filter by `college_id`.
    2. **FastAPI Tenant Context Middleware / Dependency Injection:** Extracts `college_id` from JWT / request context and injects it into every database session (`get_db_session`).
  * Cross-tenant access attempts immediately yield HTTP `403 Forbidden` and trigger security alerts.

### Rule 2: Strictly Docker-Friendly 3-Container Environment
The local development and deployment workflow relies on three distinct Docker containers orchestrated via `docker-compose`:
1. **Frontend Container (`edunexa-frontend`):** Next.js (App Router, TypeScript, Responsive Dashboard UI) running on port `3000`.
2. **Backend Container (`edunexa-backend`):** FastAPI (Python, SQLAlchemy 2.0 Async, Pydantic v2, Alembic) running on port `8000`.
3. **Database Container (`edunexa-db`):** PostgreSQL database running on internal private network (`edunexa-network`), shielded from public host port exposure for enhanced security.

```
┌─────────────────────────────────────────────────────────────┐
│                    Docker Host Environment                  │
│                                                             │
│   ┌─────────────────────┐         ┌─────────────────────┐   │
│   │   edunexa-frontend  │ ◄─────► │   edunexa-backend   │   │
│   │     (Next.js)       │         │      (FastAPI)      │   │
│   │     Port: 3000      │         │      Port: 8000     │   │
│   └─────────────────────┘         └──────────┬──────────┘   │
│                                              │              │
│                           edunexa-network    │ (Internal)   │
│                                              ▼              │
│                                   ┌─────────────────────┐   │
│                                   │      edunexa-db     │   │
│                                   │    (PostgreSQL)     │   │
│                                   │  (Internal Only)    │   │
│                                   └─────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

---

# PHASE 1 — SYSTEM ARCHITECTURE & DOCKERIZED ENVIRONMENT SETUP
**Objective:** Establish the containerized multi-tenant foundation, technology stack, and PostgreSQL schemas with Row-Level Security.

### 1.1 Technology Stack & Container Setup
* **Container 1 (Frontend):** Next.js (TypeScript, Tailwind CSS / Vanilla CSS design system, Axios/Fetch with Tenant Interceptors).
* **Container 2 (Backend):** FastAPI (Python 3.10+, SQLAlchemy async, Pydantic, Python-jose for JWT, Passlib for Argon2/Bcrypt hashing).
* **Container 3 (Database):** PostgreSQL 15+ configured with UUID extensions (`uuid-ossp` or `pgcrypto`) and Row-Level Security (RLS).
* **Orchestration:** `docker-compose.yml` defining networks, environment secrets (`.env`), health checks, and volume persistence for Postgres.

### 1.2 Multi-Tenant Database Schema Design (Ref: `database_architecture.md` & SRS Step 7)
All tables incorporate `college_id` foreign keys referencing `COLLEGE(college_id)`:

1. **`COLLEGE` (Tenant Master):** `college_id (PK)`, `name`, `domain`, `created_at`.
2. **`USERS` (Base Authentication):** `user_id (PK)`, `college_id (FK)`, `email`, `password_hash`, `role (ADMIN, FACULTY, STUDENT)`, `is_active`.
3. **`ADMIN` (ENT-00):** `admin_id (PK)`, `college_id (FK)`, `user_id (FK)`, `name`, `email`.
4. **`STUDENT` (ENT-01):** `student_id (PK)`, `college_id (FK)`, `user_id (FK)`, `name`, `enrollment_year`, `section_id`.
5. **`FACULTY` (ENT-02):** `faculty_id (PK)`, `college_id (FK)`, `user_id (FK)`, `name`, `department`.
6. **`COURSE`:** `course_id (PK)`, `college_id (FK)`, `course_name`, `course_code`.
7. **`ATTENDANCE` (ENT-03, ENT-04):** `attendance_id (PK)`, `college_id (FK)`, `student_id (FK)`, `faculty_id (FK, optional for faculty tracking)`, `course_id (FK)`, `date_recorded`, `status (PRESENT, ABSENT, LATE)`.
8. **`TIMETABLE` (ENT-05):** `timetable_id (PK)`, `college_id (FK)`, `course_id (FK)`, `faculty_id (FK)`, `day_of_week`, `start_time`, `end_time`, `room_number`.
9. **`GRADES` (ENT-06):** `grade_id (PK)`, `college_id (FK)`, `student_id (FK)`, `course_id (FK)`, `assessment_name`, `score`, `max_score`.
10. **`COURSE_MATERIAL` (ENT-07):** `material_id (PK)`, `college_id (FK)`, `course_id (FK)`, `faculty_id (FK)`, `title`, `file_url`, `created_at`.
11. **`ANNOUNCEMENT` (ENT-08):** `announcement_id (PK)`, `college_id (FK)`, `author_id (FK)`, `title`, `content`, `created_at`.
12. **`ACADEMIC_CALENDAR` (ENT-09):** `event_id (PK)`, `college_id (FK)`, `event_title`, `event_type (EXAM, HOLIDAY, EVENT)`, `start_date`, `end_date`.

### 1.3 Tenant Context Propagation & Security Pattern
* **Tenant Identification:** Extracted via sub-domain header, custom HTTP header (`X-College-ID`), or cryptographically validated claims embedded in the JWT.
* **FastAPI Dependency Injection:**
  ```python
  # Multi-tenant session dependency
  async def get_tenant_db(
      tenant_id: UUID = Depends(get_current_tenant_id),
      session: AsyncSession = Depends(get_db)
  ) -> AsyncSession:
      await session.execute(text(f"SET LOCAL app.current_tenant = '{tenant_id}'"))
      return session
  ```

---

# PHASE 2 — BACKEND & MULTI-TENANT API DEVELOPMENT (FASTAPI)
**Objective:** Build high-performance RESTful APIs mapped to SRS Step 4 actions, secured with RBAC and strict tenant isolation.

### Sprint 2.1: Multi-Tenant Authentication & RBAC Engine
* **Deliverables:**
  * `POST /api/v1/auth/login`: Authenticates user against email + password within the target `college_id`, issuing JWT containing `{user_id, college_id, role}`.
  * `POST /api/v1/auth/refresh`: Token rotation.
* **Security & Middlewares:**
  * `TenantMiddleware`: Validates tenant existence and isolates request execution context.
  * RBAC Guards: `RequireRole("ADMIN")`, `RequireRole("FACULTY")`, `RequireRole("STUDENT")`.

### Sprint 2.2: Administrative APIs (Ref: ADM-01 to ADM-03)
* `GET /api/v1/admin/attendance/students/aggregate`: College-wide attendance statistics and trends.
* `GET /api/v1/admin/attendance/faculty`: Faculty attendance and activity logs.
* `POST /api/v1/admin/announcements`: Broadcast announcements to the college feed.
* `GET /api/v1/admin/metrics`: High-level college overview (total enrolled students, active faculty, departmental counts).

### Sprint 2.3: Faculty Operations APIs (Ref: FAC-01 to FAC-06)
* `POST /api/v1/faculty/attendance/students`: Record/upsert daily section attendance.
* `GET /api/v1/faculty/timetable`: Fetch personal teaching schedule for the authenticated faculty member.
* `GET /api/v1/faculty/attendance/metrics`: Course-level attendance summaries for assigned classes.
* `POST /api/v1/faculty/grades`: Batch insert/update student assessment scores.
* `POST /api/v1/faculty/materials`: Upload and publish course materials with secure file metadata.
* `GET /api/v1/faculty/announcements`: View college announcement feed.

### Sprint 2.4: Student Operations APIs (Ref: STD-01 to STD-06)
* `GET /api/v1/student/attendance`: Fetch personal attendance breakdown by course and overall percentage.
* `GET /api/v1/student/timetable`: View personal class and lecture schedule.
* `GET /api/v1/student/grades`: View personal grades and academic progress reports.
* `GET /api/v1/student/materials`: Browse and download course resources for enrolled courses.
* `GET /api/v1/student/calendar`: Retrieve upcoming exams, holidays, and college events.
* `GET /api/v1/student/announcements`: View college announcement feed.

---

# PHASE 3 — FRONTEND UI/UX DEVELOPMENT (NEXT.JS CONTAINER)
**Objective:** Build high-performance, role-based dashboards in Next.js with tenant-aware branding, layout routing, and responsive design.

### 3.1 Architecture & Design System
* **Tenant & Auth Context:** Next.js state provider keeping track of authenticated user role, tenant metadata, and token management.
* **Design System & Components:** Clean, modern dashboard theme (dark/light support, glassmorphic cards, dynamic charts via Recharts/Chart.js).
* **Axios/Fetch Interceptor:** Automatically appends Bearer JWT and `X-College-ID` headers to all outbound backend calls.

### 3.2 The Admin Portal
* **Command Center Dashboard:** Total students count, aggregate attendance charts, faculty activity summaries.
* **Institutional Notice Board Manager:** Form to compose, preview, and publish announcements.
* **Faculty & Attendance Monitor:** Data tables with filtering and export capabilities.

### 3.3 The Faculty Portal
* **Teaching Schedule:** Interactive weekly and daily timetable view.
* **Classroom Attendance Manager:** Fast, one-click toggle interface for marking student attendance.
* **Gradebook:** Direct spreadsheet-like entry or CSV upload for marks.
* **Resource Center:** File upload dropzone for distributing course materials.

### 3.4 The Student Portal
* **My Hub:** Overview widgets showing today’s lectures, recent grades, and overall attendance percentage.
* **Academics & Attendance Center:** Subject-wise breakdown with visual progress indicators.
* **Digital Library / Materials:** Filterable course repository with instant downloads.
* **Academic Calendar:** Interactive visual calendar displaying exam schedules and holidays.

---

# PHASE 4 — TESTING, MULTI-TENANT VERIFICATION & SECURITY
**Objective:** Verify complete compliance with functional requirements, multi-tenant boundaries, and container stability.

| Test Category | Description | Verification Target |
| :--- | :--- | :--- |
| **Multi-Tenant Isolation Test** | Verify College A users/tokens cannot query or mutate College B records | 100% Data Isolation (Zero Leakage) |
| **Docker Container Validation** | Verify `frontend`, `backend`, and `database` containers start, communicate, and recover | `docker-compose up` clean orchestration |
| **Unit & Integration Tests** | Test FastAPI endpoints, calculation aggregations, and DB queries | API correctness & Pydantic schemas |
| **RBAC Security Testing** | Verify Students/Faculty cannot call unauthorized endpoints (e.g. Student posting grades) | 403 Forbidden enforcement |
| **Traceability Verification** | Validate all PRD requirements (ADM-01..03, FAC-01..06, STD-01..06) in UI | 100% PRD Coverage |

---

# PHASE 5 — DEPLOYMENT, CI/CD & HANDOVER
**Objective:** Build production container images and release pipeline.

### 5.1 Dockerized Production Configuration
* Multi-stage `Dockerfile` for Next.js (optimized standalone output).
* Multi-stage `Dockerfile` for FastAPI (Uvicorn / Gunicorn with async workers).
* Production PostgreSQL with automated backups, connection pooling (PgBouncer), and SSL.

### 5.2 CI/CD Pipeline & Documentation
* GitHub Actions pipeline: Linting, automated unit tests, multi-tenant isolation tests, and Docker image builds.
* Interactive API Documentation generated automatically via FastAPI OpenAPI / Swagger at `/docs`.
* Deployment manual with initial multi-tenant seed scripts and tenant provisioning guide.