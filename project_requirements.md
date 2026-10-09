# EDU NEXA

## System Requirement Specification (SRS) Sheet

**Document:** Project_Requirements
**Project:** EduNexa
**Document Type:** Functional Requirements Specification
**Status:** Requirements Definition

---

# STEP 1 — PROJECT IDENTIFICATION

### 1.1 Project Name
**EduNexa**

### 1.2 Project Type
**Integrated Academic Management & Student Services System**

### 1.3 System Purpose
EduNexa is a **role-based academic ecosystem** designed to streamline institutional workflows, centralize academic data, and improve communication between the administration, teaching staff, and students. 

---

# STEP 2 — SYSTEM AGENTS

An **Agent** is the designated role authorized to perform specific operations within the system. EduNexa designates exactly **three primary agents**.

| Agent ID | Agent   | Description                                           |
| -------- | ------- | ----------------------------------------------------- |
| AG-01    | Admin   | Orchestrates college-level administrative operations  |
| AG-02    | Faculty | Manages teaching, assessment, and academic operations |
| AG-03    | Student | Accesses personal academic progress and resources     |

---

# STEP 3 — REQUIREMENT IDENTIFICATION

Every business capability is translated into an identifiable, atomic requirement to ensure strict traceability during the software development lifecycle.

## 3.1 Admin Requirements

| ID     | Requirement                                                                   |
| ------ | ----------------------------------------------------------------------------- |
| ADM-01 | Admin shall be able to view aggregated, college-wide student attendance.      |
| ADM-02 | Admin shall be able to publish global announcements to the institutional feed.|
| ADM-03 | Admin shall be able to view faculty attendance and activity records.          |

## 3.2 Faculty Requirements

| ID     | Requirement                                                                         |
| ------ | ----------------------------------------------------------------------------------- |
| FAC-01 | Faculty shall be able to record daily attendance for their assigned course sections.|
| FAC-02 | Faculty shall be able to access their personal teaching timetable.                  |
| FAC-03 | Faculty shall be able to view attendance metrics for their assigned students.       |
| FAC-04 | Faculty shall be able to upload grades and assessment scores for enrolled students. |
| FAC-05 | Faculty shall be able to distribute digital course materials to specific classes.   |
| FAC-06 | Faculty shall be able to view global institutional announcements.                   |

## 3.3 Student Requirements

| ID     | Requirement                                                                    |
| ------ | ------------------------------------------------------------------------------ |
| STD-01 | Student shall be able to track their personal attendance records.              |
| STD-02 | Student shall be able to view their specific class and lecture timetable.      |
| STD-03 | Student shall be able to access their assessment grades and progress reports.  |
| STD-04 | Student shall be able to download course materials shared by their faculty.    |
| STD-05 | Student shall be able to view the academic calendar (exams and holidays).      |
| STD-06 | Student shall be able to view global institutional announcements.              |

---

# STEP 4 — AGENT → ACTION → ENTITY → RELATION

This matrix serves as the central data-modeling blueprint for EduNexa, breaking down narrative requirements into programmatic interactions.

| Req. ID | Agent   | Action        | Entity             | Relation                          |
| ------- | ------- | ------------- | ------------------ | --------------------------------- |
| ADM-01  | Admin   | View          | Student Attendance | College-wide Aggregation          |
| ADM-02  | Admin   | Create/Post   | Announcement       | Global                            |
| ADM-03  | Admin   | View          | Faculty Attendance | Faculty Records                   |
| FAC-01  | Faculty | Create/Update | Student Attendance | Assigned Course Sections          |
| FAC-02  | Faculty | View          | Timetable          | Teaching Schedule                 |
| FAC-03  | Faculty | View          | Student Attendance | Assigned Course Sections          |
| FAC-04  | Faculty | Create/Update | Grades             | Student Assessments               |
| FAC-05  | Faculty | Create/Update | Course Material    | Assigned Course Sections          |
| FAC-06  | Faculty | View          | Announcement       | Global                            |
| STD-01  | Student | View          | Student Attendance | Personal Records                  |
| STD-02  | Student | View          | Timetable          | Personal Class Schedule           |
| STD-03  | Student | View          | Grades             | Personal Academic Progress        |
| STD-04  | Student | View          | Course Material    | Enrolled Courses                  |
| STD-05  | Student | View          | Academic Calendar  | Upcoming Exams & Holidays         |
| STD-06  | Student | View          | Announcement       | Global                            |

---

# STEP 5 — MASTER AGENT LIST

1. Admin
2. Faculty
3. Student

**System Rule:** No additional agents (e.g., Parents, Guests) can be introduced without a formally approved change request modifying this document.

---

# STEP 6 — MASTER ACTION LIST

| Action        | Application in EduNexa                 |
| ------------- | -------------------------------------- |
| View          | Read/Fetch existing database records   |
| Create        | Insert new database records            |
| Update        | Mutate/Modify existing records         |
| Create/Update | Upsert operations (Add or Edit)        |

---

# STEP 7 — MASTER ENTITY LIST

Normalizing the requirements yields the following core database entities:

| Entity ID | Entity             |
| --------- | ------------------ |
| ENT-01    | Student            |
| ENT-02    | Faculty            |
| ENT-03    | Student Attendance |
| ENT-04    | Faculty Attendance |
| ENT-05    | Timetable          |
| ENT-06    | Grades             |
| ENT-07    | Course Material    |
| ENT-08    | Announcement       |
| ENT-09    | Academic Calendar  |

### Key Architectural Decision
There is exactly **one `Timetable` entity**. "Faculty Timetable" and "Student Timetable" are simply filtered access patterns (views) of a singular master timetable schema. They are not separate database tables.

---

# STEP 8 — ENTITIES VS. CALCULATED AGGREGATIONS

Proper requirements engineering distinguishes between stored data (Entities) and computed data (Aggregations).

*   **Average Attendance:** Computed dynamically by querying `Student Attendance` records. Not a distinct database entity.
*   **Total Student Count:** Computed dynamically via `COUNT(Student)`. Not a distinct database entity.
*   **Progress Reports:** Computed dynamically by aggregating `Grades` for a specific `Student`.

---

# STEP 9 — PRESENTATION VS. DATA CLARIFICATION

The requirement mentions an "Institutional Feed" or "Notice Board." 
*   **Announcement** is the underlying data *Entity*.
*   **Institutional Feed** is the UI *Presentation*.
The system will manage an `Announcement` table, which the frontend will render as a feed.

---

# STEP 10 — ROLE-BASED REQUIREMENT MATRIX

This matrix validates the functional perimeter for each role.

| Module / Resource    | Admin                      | Faculty                             | Student                       |
| -------------------- | -------------------------- | ----------------------------------- | ----------------------------- |
| Student Attendance   | View college average       | Record & view class attendance      | View personal attendance      |
| Faculty Attendance   | View records               | —                                   | —                             |
| Timetable            | —                          | View teaching schedule              | View class schedule           |
| Grades               | —                          | Assign/Upload scores                | View personal scores          |
| Course Materials     | —                          | Upload resources                    | Download resources            |
| Announcements        | Publish global notices     | View feed                           | View feed                     |
| Academic Calendar    | Manage (Implied via admin) | View                                | View exams & holidays         |

*(Note: `—` indicates the role has no defined access to this module based on current scope.)*

---

# STEP 11 — REQUIREMENT NORMALIZATION & SCOPING

To prevent scope creep and technical debt, EduNexa adheres to these normalization rules:
1.  **Single Source of Truth:** `Grades` replaces redundant concepts like "marks" or "report cards".
2.  **Consolidated Scheduling:** `Academic Calendar` handles both holidays and exam dates to prevent duplicate date-based entities.
3.  **Strict Scope Limits:** Modules like Fee Payment, Library Management, or Hostel Tracking are expressly **out of scope** for this phase.

---

# STEP 12 — REQUIREMENT COMPLETENESS CHECK

| Verification Gate                         | Status |
| ----------------------------------------- | ------ |
| Business requirements defined & scoped    | ✅     |
| Requirements mapped to valid Agents       | ✅     |
| Requirements translated to CRUD Actions   | ✅     |
| Core Entities cleanly identified          | ✅     |
| Calculated aggregations separated         | ✅     |
| Presentation concepts decoupled from data | ✅     |
| Architectural Database Design ready       | ⏳ Next |
| REST/GraphQL API Design ready             | ⏳ Next |
| UI/UX Wireframes ready                    | ⏳ Next |

---

# STEP 13 — FINAL REQUIREMENT MODEL

The complete requirement structure can now be represented as:

```text
                                 EduNexa
                                    │
            ┌───────────────────────┼───────────────────────┐
            │                       │                       │
          ADMIN                  FACULTY                 STUDENT
            │                       │                       │
      ┌─────┼─────┐           ┌─────┼─────┐           ┌─────┼─────┐
      │     │     │           │     │     │           │     │     │
  Student   │  Faculty    Student   │   Grades    Student   │   Grades
Attendance  │ Attendance Attendance │             Attendance│
            │                       │                       │
      Announcement              Timetable               Timetable
                                    │                       │
                             Course Material         Course Material
                                    │                       │
                               Announcement         Academic Calendar
                                                            │
                                                       Announcement

The important part is that the diagram is derived from the requirements, not the other way around.

# STEP 14 — WHAT THIS REQUIREMENT SHEET BECOMES

This document should be treated as the foundation for the next stages of the SDLC (Software Development Life Cycle).
PROJECT REQUIREMENTS
        │
        ▼
Requirement IDs
        │
        ▼
      Agent
        │
        ▼
     Action
        │
        ▼
     Entity
        │
        ▼
    Relation
        │
        ▼
Entity Analysis
        │
        ▼
Database Design
        │
        ▼
   API Design
        │
        ▼
  Role Access
        │
        ▼
   User Flow
        │
        ▼
    UI / UX