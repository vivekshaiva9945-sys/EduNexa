erDiagram
    COLLEGE {
        uuid college_id PK
        string name
        string domain
    }
    ADMIN {
        uuid admin_id PK
        uuid college_id FK
        string name
        string email
    }
    FACULTY {
        uuid faculty_id PK
        uuid college_id FK
        string name
        string department
    }
    STUDENT {
        uuid student_id PK
        uuid college_id FK
        string name
        string enrollment_year
    }
    COURSE {
        uuid course_id PK
        uuid college_id FK
        string course_name
    }
    ATTENDANCE {
        uuid attendance_id PK
        uuid college_id FK
        uuid student_id FK
        uuid course_id FK
        date date_recorded
        string status
    }
    TIMETABLE {
        uuid timetable_id PK
        uuid college_id FK
        uuid course_id FK
        uuid faculty_id FK
        string day_of_week
        time start_time
    }
    GRADES {
        uuid grade_id PK
        uuid college_id FK
        uuid student_id FK
        uuid course_id FK
        decimal score
    }
    COURSE_MATERIAL {
        uuid material_id PK
        uuid college_id FK
        uuid course_id FK
        uuid faculty_id FK
        string file_url
    }
    ANNOUNCEMENT {
        uuid announcement_id PK
        uuid college_id FK
        uuid author_id FK
        string title
        text content
    }

    COLLEGE ||--o{ ADMIN : houses
    COLLEGE ||--o{ FACULTY : houses
    COLLEGE ||--o{ STUDENT : houses
    COLLEGE ||--o{ COURSE : offers
    COLLEGE ||--o{ ANNOUNCEMENT : broadcasts
    STUDENT ||--o{ ATTENDANCE : has
    COURSE ||--o{ ATTENDANCE : tracks
    FACULTY ||--o{ TIMETABLE : scheduled_for
    COURSE ||--o{ TIMETABLE : scheduled_at
    STUDENT ||--o{ GRADES : receives
    COURSE ||--o{ GRADES : awards
    COURSE ||--o{ COURSE_MATERIAL : includes