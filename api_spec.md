# EduNexa API Specification Document (`api_spec.md`)

**Project:** EduNexa — Integrated Academic Management & Student Services System  
**Document Type:** Strict RESTful API Specification & Database Interaction Mapping  
**Specification Standard:** OpenAPI 3.1 / RESTful JSON Architecture  
**Multi-Tenancy Model:** Shared Schema with `college_id` Discriminator & PostgreSQL Row-Level Security (RLS)  

---

## 1. System Overview & Global Architecture Standards

### 1.1 Base URL & API Versioning
All API routes follow this base URL scheme:
```http
https://{tenant_domain}.edunexa.edu/api/v1
```
*Tenant identification header:*
```http
X-Tenant-ID: <college_id_uuid>
```

### 1.2 Authentication & Authorization
* **Mechanism:** Bearer JSON Web Tokens (`Authorization: Bearer <jwt_token>`)
* **Token Claims:** `user_id`, `college_id`, `role` (`ADMIN` | `FACULTY` | `STUDENT`), `profile_id` (`admin_id` | `faculty_id` | `student_id`)
* **Tenant Isolation:**
  ```sql
  SET LOCAL app.current_tenant = '<college_id>';
  ```

---

## 2. Portal API Route Specifications

---

### 2.1 Admin Routes

| Route | Method | Feature (PRD) | DB Table(s) | DB Action |
| :--- | :--- | :--- | :--- | :--- |
| `/api/v1/admin/attendance/summary` | `GET` | View aggregated, college-wide student attendance (**ADM-01**) | `attendance`, `courses`, `students` | **SELECT** aggregate counts and average percentages across departments |
| `/api/v1/admin/attendance/trends` | `GET` | View daily/weekly attendance trends across departments (**ADM-01**) | `attendance`, `courses` | **SELECT** time-series attendance aggregations |
| `/api/v1/admin/announcements` | `POST` | Publish global announcements to institutional feed (**ADM-02**) | `announcements`, `users` | **INSERT** new global announcement with `author_id` and `target_role='ALL'` |
| `/api/v1/admin/announcements` | `GET` | View all institutional announcements (**ADM-02**) | `announcements`, `users` | **SELECT** notice feed ordered by `created_at DESC` |
| `/api/v1/admin/announcements/{id}` | `PUT` | Update existing institutional notice (**ADM-02**) | `announcements` | **UPDATE** announcement title, content, and target audience |
| `/api/v1/admin/announcements/{id}` | `DELETE` | Delete announcement from institutional feed (**ADM-02**) | `announcements` | **DELETE** announcement record |
| `/api/v1/admin/faculty/activity` | `GET` | View faculty attendance and academic activity records (**ADM-03**) | `faculty`, `attendance`, `grades`, `course_materials` | **SELECT** aggregated faculty productivity KPIs and lecture logging counts |
| `/api/v1/admin/faculty/{id}/attendance-logs` | `GET` | View attendance logging history for a specific faculty member (**ADM-03**) | `faculty`, `attendance`, `courses` | **SELECT** attendance logs marked by faculty member |
| `/api/v1/admin/academic-calendar` | `POST` | Create institutional calendar event (**ENT-09**) | `academic_calendar` | **INSERT** new exam, holiday, or institutional event |
| `/api/v1/admin/academic-calendar` | `GET` | View institutional academic calendar (**ENT-09**) | `academic_calendar` | **SELECT** calendar schedule within specified date range |

---

### 2.2 Faculty Routes

| Route | Method | Feature (PRD) | DB Table(s) | DB Action |
| :--- | :--- | :--- | :--- | :--- |
| `/api/v1/faculty/{id}/attendance` | `POST` | Record daily attendance for assigned course sections (**FAC-01**) | `attendance`, `courses`, `students` | **INSERT / UPSERT** batch student attendance status (`PRESENT`, `ABSENT`, `LATE`) |
| `/api/v1/faculty/attendance/{attendance_id}` | `PUT` | Update individual attendance record (**FAC-01**) | `attendance` | **UPDATE** status and remarks for attendance log |
| `/api/v1/faculty/{id}/timetable` | `GET` | Access personal teaching timetable (**FAC-02**) | `timetable`, `courses` | **SELECT** weekly schedule joined with course details filtered by `faculty_id` |
| `/api/v1/faculty/{id}/courses` | `GET` | List assigned courses and active sections (**FAC-02**, **FAC-03**) | `courses`, `timetable` | **SELECT** distinct courses assigned to faculty |
| `/api/v1/faculty/courses/{course_id}/attendance-metrics` | `GET` | View attendance metrics for assigned course students (**FAC-03**) | `attendance`, `students`, `course_enrollments` | **SELECT** student attendance totals and percentage rates |
| `/api/v1/faculty/courses/{course_id}/students` | `GET` | Fetch student roster for course (**FAC-01**, **FAC-03**, **FAC-04**) | `students`, `course_enrollments` | **SELECT** enrolled student roster with roll numbers |
| `/api/v1/faculty/{id}/marks` | `POST` | Upload assessment grades and test scores (**FAC-04**) | `grades`, `students`, `courses` | **INSERT / UPDATE** student scores, max marks, and feedback remarks |
| `/api/v1/faculty/courses/{course_id}/grades` | `GET` | View submitted assessment marks for a course (**FAC-04**) | `grades`, `students` | **SELECT** course grade records filtered by `faculty_id` |
| `/api/v1/faculty/grades/{grade_id}` | `PUT` | Modify or correct an assessment grade (**FAC-04**) | `grades` | **UPDATE** score, max score, and remarks |
| `/api/v1/faculty/materials` | `POST` | Distribute digital course materials to class (**FAC-05**) | `course_materials`, `courses` | **INSERT** material metadata, file URL, and category |
| `/api/v1/faculty/courses/{course_id}/materials` | `GET` | List uploaded course materials (**FAC-05**) | `course_materials` | **SELECT** material records for specified course |
| `/api/v1/faculty/materials/{material_id}` | `DELETE` | Remove uploaded course material (**FAC-05**) | `course_materials` | **DELETE** course material record |
| `/api/v1/faculty/announcements` | `GET` | View institutional announcements feed (**FAC-06**) | `announcements`, `users` | **SELECT** notices where `target_role IN ('ALL', 'FACULTY')` |

---

### 2.3 Student Routes

| Route | Method | Feature (PRD) | DB Table(s) | DB Action |
| :--- | :--- | :--- | :--- | :--- |
| `/api/v1/student/{id}/attendance` | `GET` | Track personal attendance records and course percentage (**STD-01**) | `attendance`, `courses`, `course_enrollments` | **SELECT** attendance logs and compute subject-wise percentages |
| `/api/v1/student/{id}/attendance/{course_id}` | `GET` | View date-by-date attendance log for enrolled course (**STD-01**) | `attendance`, `faculty` | **SELECT** detailed session logs filtered by student and course |
| `/api/v1/student/{id}/timetable` | `GET` | View personal class and lecture timetable (**STD-02**) | `timetable`, `courses`, `course_enrollments`, `faculty` | **SELECT** lecture slots ordered by `day_of_week`, `start_time` |
| `/api/v1/student/{id}/grades` | `GET` | Access assessment grades and test scores (**STD-03**) | `grades`, `courses`, `faculty` | **SELECT** test marks, percentage, and teacher feedback |
| `/api/v1/student/{id}/progress-report` | `GET` | View semester GPA and progress aggregation (**STD-03**) | `grades`, `courses` | **SELECT** and compute credit-weighted GPA and grade summaries |
| `/api/v1/student/{id}/courses` | `GET` | View enrolled courses list (**STD-04**) | `courses`, `course_enrollments` | **SELECT** registered course catalog |
| `/api/v1/student/{id}/materials` | `GET` | Download and view course materials shared by faculty (**STD-04**) | `course_materials`, `courses`, `course_enrollments`, `faculty` | **SELECT** uploaded materials across all enrolled courses |
| `/api/v1/student/materials/{course_id}` | `GET` | View materials for a specific course (**STD-04**) | `course_materials`, `faculty` | **SELECT** files and syllabus notes for course |
| `/api/v1/student/academic-calendar` | `GET` | View academic calendar (exams and holidays) (**STD-05**) | `academic_calendar` | **SELECT** upcoming exam dates and institutional holidays |
| `/api/v1/student/announcements` | `GET` | View global institutional announcements feed (**STD-06**) | `announcements`, `users` | **SELECT** notices where `target_role IN ('ALL', 'STUDENT')` |

---

### 2.4 Authentication & Identity Routes

| Route | Method | Feature (PRD) | DB Table(s) | DB Action |
| :--- | :--- | :--- | :--- | :--- |
| `/api/v1/auth/login` | `POST` | User authentication & JWT issuance (All Agents) | `users`, `colleges`, `admins`, `faculty`, `students` | **SELECT** verify credentials, active status, fetch role profile |
| `/api/v1/auth/me` | `GET` | Fetch authenticated session profile metadata | `users`, `admins`, `faculty`, `students`, `colleges` | **SELECT** current user profile and institutional tenant details |
| `/api/v1/auth/refresh` | `POST` | Refresh access token | `users` | **SELECT** validate token and account status |

---

## 3. End-to-End Requirement Traceability Summary

* **ADM-01**: Fully mapped (`/api/v1/admin/attendance/summary`, `/api/v1/admin/attendance/trends`)
* **ADM-02**: Fully mapped (`POST/GET/PUT/DELETE /api/v1/admin/announcements`)
* **ADM-03**: Fully mapped (`/api/v1/admin/faculty/activity`, `/api/v1/admin/faculty/{id}/attendance-logs`)
* **FAC-01**: Fully mapped (`POST /api/v1/faculty/{id}/attendance`, `PUT /api/v1/faculty/attendance/{attendance_id}`)
* **FAC-02**: Fully mapped (`GET /api/v1/faculty/{id}/timetable`, `GET /api/v1/faculty/{id}/courses`)
* **FAC-03**: Fully mapped (`GET /api/v1/faculty/courses/{course_id}/attendance-metrics`, `/students`)
* **FAC-04**: Fully mapped (`POST /api/v1/faculty/{id}/marks`, `GET/PUT /api/v1/faculty/grades`)
* **FAC-05**: Fully mapped (`POST/GET/DELETE /api/v1/faculty/materials`)
* **FAC-06**: Fully mapped (`GET /api/v1/faculty/announcements`)
* **STD-01**: Fully mapped (`GET /api/v1/student/{id}/attendance`)
* **STD-02**: Fully mapped (`GET /api/v1/student/{id}/timetable`)
* **STD-03**: Fully mapped (`GET /api/v1/student/{id}/grades`, `/progress-report`)
* **STD-04**: Fully mapped (`GET /api/v1/student/{id}/materials`, `/courses`)
* **STD-05**: Fully mapped (`GET /api/v1/student/academic-calendar`)
* **STD-06**: Fully mapped (`GET /api/v1/student/announcements`)
