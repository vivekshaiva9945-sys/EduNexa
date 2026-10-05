# UniFlow — API Specification

## 1. API Design Conventions

| Convention | Standard |
|---|---|
| API Base Path | /api/v1 |
| Architecture Style | REST-oriented |
| Data Format | JSON |
| Versioning | URL-based |
| Functional Source | Project Requirement.md |
| Database Source | Database Architecture.md |

---

## 2. Admin Routes

| Route | Method | Feature (PRD) | DB Table(s) | DB Action |
|---|---|---|---|---|
| `/api/v1/admin/attendance` | `GET` | View aggregated, college-wide student attendance (**ADM-01**) | `attendance`, `students` | **SELECT** aggregate attendance counts and compute college-wide average attendance rates |
| `/api/v1/admin/announcements` | `POST` | Publish global announcements to the institutional feed (**ADM-02**) | `announcements` | **INSERT** announcement record with author reference and global target audience |
| `/api/v1/admin/faculty-attendance` | `GET` | View faculty attendance and activity records (**ADM-03**) | `attendance`, `faculty` | **SELECT** faculty attendance logging records and teaching activity history |

---

## 3. Faculty Routes

| Route | Method | Feature (PRD) | DB Table(s) | DB Action |
|---|---|---|---|---|
| `/api/v1/faculty/attendance` | `POST` | Record daily attendance for assigned course sections (**FAC-01**) | `attendance` | **INSERT / UPDATE** daily attendance entries for students in assigned course sections |
| `/api/v1/faculty/timetable` | `GET` | Access personal teaching timetable (**FAC-02**) | `timetable`, `courses` | **SELECT** scheduled lecture slots and course details assigned to the faculty member |
| `/api/v1/faculty/attendance/metrics` | `GET` | View attendance metrics for assigned students (**FAC-03**) | `attendance`, `students`, `courses` | **SELECT** and compute student attendance metrics and percentage rates for assigned sections |
| `/api/v1/faculty/grades` | `POST` | Upload grades and assessment scores for enrolled students (**FAC-04**) | `grades` | **INSERT / UPDATE** assessment scores, max scores, and remarks for enrolled students |
| `/api/v1/faculty/course-materials` | `POST` | Distribute digital course materials to specific classes (**FAC-05**) | `course_materials` | **INSERT** course material record containing title, description, and file reference |
| `/api/v1/faculty/announcements` | `GET` | View global institutional announcements (**FAC-06**) | `announcements` | **SELECT** global announcements where target audience matches faculty or all roles |

---

## 4. Student Routes

| Route | Method | Feature (PRD) | DB Table(s) | DB Action |
|---|---|---|---|---|
| `/api/v1/student/attendance` | `GET` | Track personal attendance records (**STD-01**) | `attendance`, `courses` | **SELECT** personal attendance records and compute subject-wise attendance percentages |
| `/api/v1/student/timetable` | `GET` | View specific class and lecture timetable (**STD-02**) | `timetable`, `courses`, `course_enrollments` | **SELECT** weekly lecture slots for courses in which the student is enrolled |
| `/api/v1/student/grades` | `GET` | Access assessment grades and progress reports (**STD-03**) | `grades`, `courses` | **SELECT** assessment scores and compute aggregated academic progress metrics |
| `/api/v1/student/course-materials` | `GET` | Download course materials shared by faculty (**STD-04**) | `course_materials`, `course_enrollments` | **SELECT** course materials and file download links available for enrolled courses |
| `/api/v1/student/academic-calendar` | `GET` | View the academic calendar (exams and holidays) (**STD-05**) | `academic_calendar` | **SELECT** scheduled examination periods, holidays, and academic calendar events |
| `/api/v1/student/announcements` | `GET` | View global institutional announcements (**STD-06**) | `announcements` | **SELECT** global announcements where target audience matches student or all roles |

---

## 5. Requirement Traceability

| Requirement | Agent | API Route | Method |
|---|---|---|---|
| **ADM-01**: Admin shall be able to view aggregated, college-wide student attendance. | Admin | `/api/v1/admin/attendance` | `GET` |
| **ADM-02**: Admin shall be able to publish global announcements to the institutional feed. | Admin | `/api/v1/admin/announcements` | `POST` |
| **ADM-03**: Admin shall be able to view faculty attendance and activity records. | Admin | `/api/v1/admin/faculty-attendance` | `GET` |
| **FAC-01**: Faculty shall be able to record daily attendance for their assigned course sections. | Faculty | `/api/v1/faculty/attendance` | `POST` |
| **FAC-02**: Faculty shall be able to access their personal teaching timetable. | Faculty | `/api/v1/faculty/timetable` | `GET` |
| **FAC-03**: Faculty shall be able to view attendance metrics for their assigned students. | Faculty | `/api/v1/faculty/attendance/metrics` | `GET` |
| **FAC-04**: Faculty shall be able to upload grades and assessment scores for enrolled students. | Faculty | `/api/v1/faculty/grades` | `POST` |
| **FAC-05**: Faculty shall be able to distribute digital course materials to specific classes. | Faculty | `/api/v1/faculty/course-materials` | `POST` |
| **FAC-06**: Faculty shall be able to view global institutional announcements. | Faculty | `/api/v1/faculty/announcements` | `GET` |
| **STD-01**: Student shall be able to track their personal attendance records. | Student | `/api/v1/student/attendance` | `GET` |
| **STD-02**: Student shall be able to view their specific class and lecture timetable. | Student | `/api/v1/student/timetable` | `GET` |
| **STD-03**: Student shall be able to access their assessment grades and progress reports. | Student | `/api/v1/student/grades` | `GET` |
| **STD-04**: Student shall be able to download course materials shared by their faculty. | Student | `/api/v1/student/course-materials` | `GET` |
| **STD-05**: Student shall be able to view the academic calendar (exams and holidays). | Student | `/api/v1/student/academic-calendar` | `GET` |
| **STD-06**: Student shall be able to view global institutional announcements. | Student | `/api/v1/student/announcements` | `GET` |

---

## 6. API Completeness Verification

| Verification | Status |
|---|---|
| All PRD requirements mapped | Verified |
| No unsupported features added | Verified |
| Database tables match architecture | Verified |
| API routes grouped by portal | Verified |
| HTTP methods are appropriate | Verified |
| Requirement traceability maintained | Verified |
