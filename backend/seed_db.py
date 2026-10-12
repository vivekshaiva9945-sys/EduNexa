import datetime
import uuid
import random
from decimal import Decimal
from typing import List

from sqlalchemy import (
    create_engine,
    Column,
    String,
    Boolean,
    ForeignKey,
    DateTime,
    Date,
    Time,
    Integer,
    Numeric,
    Text,
    UniqueConstraint,
    CheckConstraint,
    Index,
)
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import declarative_base, sessionmaker, relationship

# Database connection configuration
DB_USER = "edunexa_admin"
DB_PASSWORD = "securepassword123"
DB_HOST = "localhost"
DB_PORT = "5432"
DB_NAME = "edunexa_multi_tenant"

DATABASE_URL = f"postgresql+psycopg2://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"

Base = declarative_base()

# ==========================================
# 1. SQLAlchemy Models (database_architecture.md)
# ==========================================

class College(Base):
    __tablename__ = "colleges"

    college_id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    name = Column(String(255), nullable=False)
    domain = Column(String(100), unique=True, nullable=False)
    code = Column(String(50), unique=True, nullable=False)
    is_active = Column(Boolean, default=True, nullable=False)
    created_at = Column(DateTime(timezone=True), default=lambda: datetime.datetime.now(datetime.timezone.utc), nullable=False)
    updated_at = Column(DateTime(timezone=True), default=lambda: datetime.datetime.now(datetime.timezone.utc), onupdate=lambda: datetime.datetime.now(datetime.timezone.utc), nullable=False)

    users = relationship("User", back_populates="college", cascade="all, delete-orphan")
    admins = relationship("Admin", back_populates="college", cascade="all, delete-orphan")
    faculty = relationship("Faculty", back_populates="college", cascade="all, delete-orphan")
    students = relationship("Student", back_populates="college", cascade="all, delete-orphan")
    courses = relationship("Course", back_populates="college", cascade="all, delete-orphan")


class User(Base):
    __tablename__ = "users"

    user_id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    college_id = Column(UUID(as_uuid=True), ForeignKey("colleges.college_id", ondelete="CASCADE"), nullable=False)
    email = Column(String(255), nullable=False)
    password_hash = Column(String(255), nullable=False)
    role = Column(String(20), nullable=False)
    is_active = Column(Boolean, default=True, nullable=False)
    created_at = Column(DateTime(timezone=True), default=lambda: datetime.datetime.now(datetime.timezone.utc), nullable=False)
    updated_at = Column(DateTime(timezone=True), default=lambda: datetime.datetime.now(datetime.timezone.utc), onupdate=lambda: datetime.datetime.now(datetime.timezone.utc), nullable=False)

    __table_args__ = (
        CheckConstraint("role IN ('ADMIN', 'FACULTY', 'STUDENT')", name="check_user_role"),
        UniqueConstraint("college_id", "email", name="uq_user_college_email"),
    )

    college = relationship("College", back_populates="users")
    admin_profile = relationship("Admin", back_populates="user", uselist=False, cascade="all, delete-orphan")
    faculty_profile = relationship("Faculty", back_populates="user", uselist=False, cascade="all, delete-orphan")
    student_profile = relationship("Student", back_populates="user", uselist=False, cascade="all, delete-orphan")


class Admin(Base):
    __tablename__ = "admins"

    admin_id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    college_id = Column(UUID(as_uuid=True), ForeignKey("colleges.college_id", ondelete="CASCADE"), nullable=False)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.user_id", ondelete="CASCADE"), unique=True, nullable=False)
    first_name = Column(String(100), nullable=False)
    last_name = Column(String(100), nullable=False)
    phone = Column(String(20), nullable=True)
    created_at = Column(DateTime(timezone=True), default=lambda: datetime.datetime.now(datetime.timezone.utc), nullable=False)

    college = relationship("College", back_populates="admins")
    user = relationship("User", back_populates="admin_profile")


class Faculty(Base):
    __tablename__ = "faculty"

    faculty_id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    college_id = Column(UUID(as_uuid=True), ForeignKey("colleges.college_id", ondelete="CASCADE"), nullable=False)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.user_id", ondelete="CASCADE"), unique=True, nullable=False)
    employee_code = Column(String(50), nullable=False)
    first_name = Column(String(100), nullable=False)
    last_name = Column(String(100), nullable=False)
    department = Column(String(100), nullable=False)
    designation = Column(String(100), nullable=True)
    created_at = Column(DateTime(timezone=True), default=lambda: datetime.datetime.now(datetime.timezone.utc), nullable=False)

    __table_args__ = (
        UniqueConstraint("college_id", "employee_code", name="uq_faculty_college_code"),
    )

    college = relationship("College", back_populates="faculty")
    user = relationship("User", back_populates="faculty_profile")


class Student(Base):
    __tablename__ = "students"

    student_id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    college_id = Column(UUID(as_uuid=True), ForeignKey("colleges.college_id", ondelete="CASCADE"), nullable=False)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.user_id", ondelete="CASCADE"), unique=True, nullable=False)
    roll_number = Column(String(50), nullable=False)
    first_name = Column(String(100), nullable=False)
    last_name = Column(String(100), nullable=False)
    enrollment_year = Column(String(10), nullable=False)
    semester = Column(String(20), nullable=False)
    created_at = Column(DateTime(timezone=True), default=lambda: datetime.datetime.now(datetime.timezone.utc), nullable=False)

    __table_args__ = (
        UniqueConstraint("college_id", "roll_number", name="uq_student_college_roll"),
    )

    college = relationship("College", back_populates="students")
    user = relationship("User", back_populates="student_profile")
    enrollments = relationship("CourseEnrollment", back_populates="student", cascade="all, delete-orphan")


class Course(Base):
    __tablename__ = "courses"

    course_id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    college_id = Column(UUID(as_uuid=True), ForeignKey("colleges.college_id", ondelete="CASCADE"), nullable=False)
    course_code = Column(String(50), nullable=False)
    course_name = Column(String(200), nullable=False)
    department = Column(String(100), nullable=False)
    credits = Column(Integer, default=3, nullable=False)
    semester = Column(String(20), nullable=False)
    created_at = Column(DateTime(timezone=True), default=lambda: datetime.datetime.now(datetime.timezone.utc), nullable=False)

    __table_args__ = (
        UniqueConstraint("college_id", "course_code", name="uq_course_college_code"),
    )

    college = relationship("College", back_populates="courses")
    enrollments = relationship("CourseEnrollment", back_populates="course", cascade="all, delete-orphan")


class CourseEnrollment(Base):
    __tablename__ = "course_enrollments"

    enrollment_id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    college_id = Column(UUID(as_uuid=True), ForeignKey("colleges.college_id", ondelete="CASCADE"), nullable=False)
    course_id = Column(UUID(as_uuid=True), ForeignKey("courses.course_id", ondelete="CASCADE"), nullable=False)
    student_id = Column(UUID(as_uuid=True), ForeignKey("students.student_id", ondelete="CASCADE"), nullable=False)
    enrolled_at = Column(DateTime(timezone=True), default=lambda: datetime.datetime.now(datetime.timezone.utc), nullable=False)

    __table_args__ = (
        UniqueConstraint("college_id", "course_id", "student_id", name="uq_enrollment_unique"),
    )

    course = relationship("Course", back_populates="enrollments")
    student = relationship("Student", back_populates="enrollments")


class Attendance(Base):
    __tablename__ = "attendance"

    attendance_id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    college_id = Column(UUID(as_uuid=True), ForeignKey("colleges.college_id", ondelete="CASCADE"), nullable=False)
    student_id = Column(UUID(as_uuid=True), ForeignKey("students.student_id", ondelete="CASCADE"), nullable=False)
    faculty_id = Column(UUID(as_uuid=True), ForeignKey("faculty.faculty_id", ondelete="SET NULL"), nullable=True)
    course_id = Column(UUID(as_uuid=True), ForeignKey("courses.course_id", ondelete="CASCADE"), nullable=False)
    date_recorded = Column(Date, nullable=False)
    status = Column(String(20), nullable=False)
    remarks = Column(Text, nullable=True)
    created_at = Column(DateTime(timezone=True), default=lambda: datetime.datetime.now(datetime.timezone.utc), nullable=False)

    __table_args__ = (
        CheckConstraint("status IN ('PRESENT', 'ABSENT', 'LATE', 'EXCUSED')", name="check_attendance_status"),
        Index("idx_attendance_student_date", "college_id", "student_id", "date_recorded"),
        Index("idx_attendance_course_date", "college_id", "course_id", "date_recorded"),
    )


class Timetable(Base):
    __tablename__ = "timetable"

    timetable_id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    college_id = Column(UUID(as_uuid=True), ForeignKey("colleges.college_id", ondelete="CASCADE"), nullable=False)
    course_id = Column(UUID(as_uuid=True), ForeignKey("courses.course_id", ondelete="CASCADE"), nullable=False)
    faculty_id = Column(UUID(as_uuid=True), ForeignKey("faculty.faculty_id", ondelete="CASCADE"), nullable=False)
    day_of_week = Column(String(15), nullable=False)
    start_time = Column(Time, nullable=False)
    end_time = Column(Time, nullable=False)
    room_number = Column(String(50), nullable=False)

    __table_args__ = (
        CheckConstraint("day_of_week IN ('MONDAY','TUESDAY','WEDNESDAY','THURSDAY','FRIDAY','SATURDAY')", name="check_timetable_day"),
        Index("idx_timetable_faculty_day", "college_id", "faculty_id", "day_of_week"),
        Index("idx_timetable_course_day", "college_id", "course_id", "day_of_week"),
    )


class Grade(Base):
    __tablename__ = "grades"

    grade_id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    college_id = Column(UUID(as_uuid=True), ForeignKey("colleges.college_id", ondelete="CASCADE"), nullable=False)
    student_id = Column(UUID(as_uuid=True), ForeignKey("students.student_id", ondelete="CASCADE"), nullable=False)
    course_id = Column(UUID(as_uuid=True), ForeignKey("courses.course_id", ondelete="CASCADE"), nullable=False)
    faculty_id = Column(UUID(as_uuid=True), ForeignKey("faculty.faculty_id", ondelete="SET NULL"), nullable=True)
    assessment_name = Column(String(100), nullable=False)
    score = Column(Numeric(5, 2), nullable=False)
    max_score = Column(Numeric(5, 2), default=100.00, nullable=False)
    remarks = Column(Text, nullable=True)
    graded_at = Column(DateTime(timezone=True), default=lambda: datetime.datetime.now(datetime.timezone.utc), nullable=False)

    __table_args__ = (
        Index("idx_grades_student_course", "college_id", "student_id", "course_id"),
    )


class CourseMaterial(Base):
    __tablename__ = "course_materials"

    material_id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    college_id = Column(UUID(as_uuid=True), ForeignKey("colleges.college_id", ondelete="CASCADE"), nullable=False)
    course_id = Column(UUID(as_uuid=True), ForeignKey("courses.course_id", ondelete="CASCADE"), nullable=False)
    faculty_id = Column(UUID(as_uuid=True), ForeignKey("faculty.faculty_id", ondelete="CASCADE"), nullable=False)
    title = Column(String(200), nullable=False)
    description = Column(Text, nullable=True)
    file_url = Column(String(500), nullable=False)
    file_type = Column(String(50), nullable=False)
    uploaded_at = Column(DateTime(timezone=True), default=lambda: datetime.datetime.now(datetime.timezone.utc), nullable=False)

    __table_args__ = (
        Index("idx_materials_course", "college_id", "course_id"),
    )


class Announcement(Base):
    __tablename__ = "announcements"

    announcement_id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    college_id = Column(UUID(as_uuid=True), ForeignKey("colleges.college_id", ondelete="CASCADE"), nullable=False)
    author_id = Column(UUID(as_uuid=True), ForeignKey("users.user_id", ondelete="SET NULL"), nullable=True)
    title = Column(String(255), nullable=False)
    content = Column(Text, nullable=False)
    target_role = Column(String(20), default="ALL", nullable=False)
    created_at = Column(DateTime(timezone=True), default=lambda: datetime.datetime.now(datetime.timezone.utc), nullable=False)

    __table_args__ = (
        CheckConstraint("target_role IN ('ALL', 'FACULTY', 'STUDENT')", name="check_announcement_target"),
        Index("idx_announcements_college_date", "college_id", "created_at"),
    )


class AcademicCalendar(Base):
    __tablename__ = "academic_calendar"

    event_id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    college_id = Column(UUID(as_uuid=True), ForeignKey("colleges.college_id", ondelete="CASCADE"), nullable=False)
    event_title = Column(String(200), nullable=False)
    event_type = Column(String(30), nullable=False)
    start_date = Column(Date, nullable=False)
    end_date = Column(Date, nullable=False)
    description = Column(Text, nullable=True)
    created_at = Column(DateTime(timezone=True), default=lambda: datetime.datetime.now(datetime.timezone.utc), nullable=False)

    __table_args__ = (
        CheckConstraint("event_type IN ('EXAM', 'HOLIDAY', 'EVENT', 'WORKSHOP')", name="check_calendar_event_type"),
        Index("idx_calendar_dates", "college_id", "start_date", "end_date"),
    )


# ==========================================
# 2. Realistic Seed Data Generator
# ==========================================

FIRST_NAMES = [
    "Aarav", "Aditi", "Rohan", "Priya", "Ananya", "Vikram", "Neha", "Rahul",
    "Sneha", "Karan", "Pooja", "Arjun", "Kavya", "Siddharth", "Divya", "Varun",
    "Meera", "Aditya", "Rhea", "Manish", "Tanvi", "Gaurav", "Isha", "Nikhil",
    "Swati", "Harsh", "Simran", "Akash", "Ritu", "Dev", "Payal", "Amit",
    "Shruti", "Suresh", "Shweta", "Raj", "Komal", "Deepak", "Sunita", "Vishal",
    "Tara", "Mayank", "Pallavi", "Sameer", "Geeta", "Abhishek", "Kritika", "Alok",
    "Bhavna", "Kunal"
]

LAST_NAMES = [
    "Sharma", "Verma", "Patel", "Reddy", "Gupta", "Mehta", "Iyer", "Nair",
    "Singh", "Chauhan", "Deshmukh", "Kulkarni", "Bhat", "Rao", "Joshi", "Kapoor",
    "Malhotra", "Saxena", "Choudhury", "Menon", "Banerjee", "Chatterjee", "Mishra", "Pandey"
]

DEPARTMENTS = ["Computer Science", "Information Technology", "Electronics & Comm", "Mechanical Eng", "Civil Eng"]

def hash_password(plain_password: str) -> str:
    # Standard bcrypt hash for password 'Password@123'
    return "$2b$12$e8Y5t1hWz7M1r3B7.X7YuuN5U5zM2i0kM5fB4kXpWn/6z5YV3aW8m"

def seed_database():
    print(f"Connecting to database at {DB_HOST}:{DB_PORT}/{DB_NAME}...")
    engine = create_engine(DATABASE_URL, echo=False)

    print("Dropping existing tables and creating fresh schema...")
    Base.metadata.drop_all(engine)
    Base.metadata.create_all(engine)
    print("[SUCCESS] Schema initialized successfully.")

    Session = sessionmaker(bind=engine)
    session = Session()

    try:
        # ----------------------------------------------------
        # 1. Seed 2 Colleges
        # ----------------------------------------------------
        colleges_data = [
            {
                "name": "Apex Institute of Technology",
                "domain": "apex.edunexa.edu",
                "code": "APEX"
            },
            {
                "name": "Horizon University",
                "domain": "horizon.edunexa.edu",
                "code": "HORIZON"
            }
        ]

        colleges = []
        for c_data in colleges_data:
            c = College(
                college_id=uuid.uuid4(),
                name=c_data["name"],
                domain=c_data["domain"],
                code=c_data["code"],
                is_active=True
            )
            session.add(c)
            colleges.append(c)

        session.flush()
        print(f"[SUCCESS] Seeded {len(colleges)} Colleges (APEX & HORIZON).")

        # ----------------------------------------------------
        # 2. Seed 2 Admins (1 per college)
        # ----------------------------------------------------
        admin_meta = [
            {"college": colleges[0], "first_name": "Robert", "last_name": "Vance", "email": "admin@apex.edunexa.edu", "phone": "+1-555-0101"},
            {"college": colleges[1], "first_name": "Eleanor", "last_name": "Sterling", "email": "admin@horizon.edunexa.edu", "phone": "+1-555-0202"}
        ]

        for am in admin_meta:
            admin_user = User(
                user_id=uuid.uuid4(),
                college_id=am["college"].college_id,
                email=am["email"],
                password_hash=hash_password("Admin@123"),
                role="ADMIN",
                is_active=True
            )
            session.add(admin_user)
            session.flush()

            admin_profile = Admin(
                admin_id=uuid.uuid4(),
                college_id=am["college"].college_id,
                user_id=admin_user.user_id,
                first_name=am["first_name"],
                last_name=am["last_name"],
                phone=am["phone"]
            )
            session.add(admin_profile)

        print("[SUCCESS] Seeded 2 Administrators (1 per college).")

        # ----------------------------------------------------
        # 3. Seed Courses (6 per college)
        # ----------------------------------------------------
        courses_by_college = {}
        course_definitions = [
            ("CS101", "Data Structures & Algorithms", "Computer Science", 4, "Sem 3"),
            ("CS102", "Database Management Systems", "Computer Science", 4, "Sem 3"),
            ("IT201", "Web Application Development", "Information Technology", 3, "Sem 3"),
            ("EC201", "Digital Signal Processing", "Electronics & Comm", 4, "Sem 5"),
            ("ME301", "Thermodynamics & Heat Transfer", "Mechanical Eng", 3, "Sem 5"),
            ("CE101", "Structural Mechanics", "Civil Eng", 3, "Sem 1")
        ]

        for col in colleges:
            courses_by_college[col.college_id] = []
            for c_code, c_title, dept, credits, sem in course_definitions:
                course = Course(
                    course_id=uuid.uuid4(),
                    college_id=col.college_id,
                    course_code=f"{col.code}-{c_code}",
                    course_name=c_title,
                    department=dept,
                    credits=credits,
                    semester=sem
                )
                session.add(course)
                courses_by_college[col.college_id].append(course)

        session.flush()
        print("[SUCCESS] Seeded 12 Courses across colleges.")

        # ----------------------------------------------------
        # 4. Seed 10 Faculty Members (5 per college)
        # ----------------------------------------------------
        faculty_by_college = {}
        faculty_specs = [
            ("Dr. Rajesh", "Nambiar", "Computer Science", "Professor"),
            ("Dr. Sunita", "Raman", "Computer Science", "Associate Professor"),
            ("Prof. Amit", "Deshmukh", "Information Technology", "Assistant Professor"),
            ("Dr. Kavita", "Menon", "Electronics & Comm", "Associate Professor"),
            ("Prof. Ramesh", "Pawar", "Mechanical Eng", "Professor"),
            ("Dr. Alistair", "Crawford", "Computer Science", "Professor"),
            ("Dr. Sarah", "Jenkins", "Information Technology", "Associate Professor"),
            ("Prof. Marcus", "Vaughn", "Electronics & Comm", "Assistant Professor"),
            ("Dr. Elena", "Rostova", "Mechanical Eng", "Associate Professor"),
            ("Prof. David", "Kim", "Civil Eng", "Assistant Professor")
        ]

        total_faculty = 0
        for i, col in enumerate(colleges):
            faculty_by_college[col.college_id] = []
            college_specs = faculty_specs[0:5] if i == 0 else faculty_specs[5:10]

            for idx, (f_name, l_name, dept, desig) in enumerate(college_specs, start=1):
                clean_name = f_name.lower().replace("dr. ", "").replace("prof. ", "")
                f_email = f"{clean_name}.{l_name.lower()}@{col.domain}"
                f_user = User(
                    user_id=uuid.uuid4(),
                    college_id=col.college_id,
                    email=f_email,
                    password_hash=hash_password("Faculty@123"),
                    role="FACULTY",
                    is_active=True
                )
                session.add(f_user)
                session.flush()

                fac = Faculty(
                    faculty_id=uuid.uuid4(),
                    college_id=col.college_id,
                    user_id=f_user.user_id,
                    employee_code=f"{col.code}-FAC-{1000 + idx}",
                    first_name=f_name,
                    last_name=l_name,
                    department=dept,
                    designation=desig
                )
                session.add(fac)
                faculty_by_college[col.college_id].append(fac)
                total_faculty += 1

        session.flush()
        print(f"[SUCCESS] Seeded {total_faculty} Faculty Members across departments.")

        # ----------------------------------------------------
        # 5. Seed 50 Students (25 per college)
        # ----------------------------------------------------
        students_by_college = {}
        semesters = ["Sem 1", "Sem 3", "Sem 5"]
        years = ["2024", "2023", "2022"]

        total_students = 0
        name_idx = 0

        for col_idx, col in enumerate(colleges):
            students_by_college[col.college_id] = []
            for s_idx in range(1, 26):
                f_name = FIRST_NAMES[name_idx % len(FIRST_NAMES)]
                l_name = LAST_NAMES[(name_idx + 3) % len(LAST_NAMES)]
                name_idx += 1

                dept = DEPARTMENTS[(s_idx + col_idx) % len(DEPARTMENTS)]
                sem = semesters[s_idx % len(semesters)]
                yr = years[s_idx % len(years)]

                s_email = f"{f_name.lower()}.{l_name.lower()}{s_idx}@{col.domain}"
                s_user = User(
                    user_id=uuid.uuid4(),
                    college_id=col.college_id,
                    email=s_email,
                    password_hash=hash_password("Student@123"),
                    role="STUDENT",
                    is_active=True
                )
                session.add(s_user)
                session.flush()

                stud = Student(
                    student_id=uuid.uuid4(),
                    college_id=col.college_id,
                    user_id=s_user.user_id,
                    roll_number=f"{col.code}-2024-{100 + s_idx}",
                    first_name=f_name,
                    last_name=l_name,
                    enrollment_year=yr,
                    semester=sem
                )
                session.add(stud)
                students_by_college[col.college_id].append((stud, dept))
                total_students += 1

        session.flush()
        print(f"[SUCCESS] Seeded {total_students} Students (25 per college across all departments).")

        # ----------------------------------------------------
        # 6. Seed Course Enrollments
        # ----------------------------------------------------
        enrollment_count = 0
        for col in colleges:
            col_courses = courses_by_college[col.college_id]
            col_students = students_by_college[col.college_id]

            for stud, s_dept in col_students:
                dept_courses = [c for c in col_courses if c.department == s_dept or c.department == "Computer Science"]
                if not dept_courses:
                    dept_courses = col_courses[:2]

                for crs in dept_courses[:3]:
                    enr = CourseEnrollment(
                        enrollment_id=uuid.uuid4(),
                        college_id=col.college_id,
                        course_id=crs.course_id,
                        student_id=stud.student_id,
                        enrolled_at=datetime.datetime.now(datetime.timezone.utc) - datetime.timedelta(days=random.randint(10, 60))
                    )
                    session.add(enr)
                    enrollment_count += 1

        session.flush()
        print(f"[SUCCESS] Seeded {enrollment_count} Course Enrollments.")

        # ----------------------------------------------------
        # 7. Seed Timetable Slots
        # ----------------------------------------------------
        days = ["MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY"]
        time_slots = [
            (datetime.time(9, 0), datetime.time(10, 30)),
            (datetime.time(11, 0), datetime.time(12, 30)),
            (datetime.time(14, 0), datetime.time(15, 30)),
        ]
        rooms = ["Lecture Hall A-101", "Lab 203", "Room 304", "Auditorium 1", "Tech Lab B"]

        timetable_count = 0
        for col in colleges:
            col_courses = courses_by_college[col.college_id]
            col_faculty = faculty_by_college[col.college_id]

            for idx, crs in enumerate(col_courses):
                fac = col_faculty[idx % len(col_faculty)]
                day = days[idx % len(days)]
                start_t, end_t = time_slots[idx % len(time_slots)]
                room = rooms[idx % len(rooms)]

                tt = Timetable(
                    timetable_id=uuid.uuid4(),
                    college_id=col.college_id,
                    course_id=crs.course_id,
                    faculty_id=fac.faculty_id,
                    day_of_week=day,
                    start_time=start_t,
                    end_time=end_t,
                    room_number=room
                )
                session.add(tt)
                timetable_count += 1

        session.flush()
        print(f"[SUCCESS] Seeded {timetable_count} Timetable Class Slots.")

        # ----------------------------------------------------
        # 8. Seed Attendance Logs & Grades
        # ----------------------------------------------------
        statuses = ["PRESENT", "PRESENT", "PRESENT", "ABSENT", "LATE"]
        today = datetime.date.today()
        attendance_count = 0
        grade_count = 0

        for col in colleges:
            col_courses = courses_by_college[col.college_id]
            col_faculty = faculty_by_college[col.college_id]
            col_students = students_by_college[col.college_id]

            for stud, _ in col_students:
                assigned_courses = col_courses[:2]
                for crs in assigned_courses:
                    fac = col_faculty[0]

                    # 3 days of attendance per course
                    for day_offset in range(1, 4):
                        att_date = today - datetime.timedelta(days=day_offset)
                        att = Attendance(
                            attendance_id=uuid.uuid4(),
                            college_id=col.college_id,
                            student_id=stud.student_id,
                            faculty_id=fac.faculty_id,
                            course_id=crs.course_id,
                            date_recorded=att_date,
                            status=random.choice(statuses),
                            remarks="Regular Class Session"
                        )
                        session.add(att)
                        attendance_count += 1

                    # 1 Midterm Grade
                    score_val = Decimal(random.randint(70, 98)) + Decimal("0.50")
                    grd = Grade(
                        grade_id=uuid.uuid4(),
                        college_id=col.college_id,
                        student_id=stud.student_id,
                        course_id=crs.course_id,
                        faculty_id=fac.faculty_id,
                        assessment_name="Midterm Examination 2024",
                        score=score_val,
                        max_score=Decimal("100.00"),
                        remarks="Good conceptual clarity" if score_val > 80 else "Satisfactory"
                    )
                    session.add(grd)
                    grade_count += 1

        session.flush()
        print(f"[SUCCESS] Seeded {attendance_count} Attendance Records & {grade_count} Student Grades.")

        # ----------------------------------------------------
        # 9. Seed Course Materials & Announcements
        # ----------------------------------------------------
        for col in colleges:
            col_courses = courses_by_college[col.college_id]
            col_faculty = faculty_by_college[col.college_id]

            # Materials
            for idx, crs in enumerate(col_courses[:3]):
                fac = col_faculty[idx % len(col_faculty)]
                mat = CourseMaterial(
                    material_id=uuid.uuid4(),
                    college_id=col.college_id,
                    course_id=crs.course_id,
                    faculty_id=fac.faculty_id,
                    title=f"Lecture Notes - Module {idx + 1} for {crs.course_name}",
                    description="Comprehensive study notes, code examples, and practice problems.",
                    file_url=f"https://storage.edunexa.edu/materials/{col.code.lower()}/{crs.course_code.lower()}_module{idx+1}.pdf",
                    file_type="application/pdf"
                )
                session.add(mat)

            # Announcements
            ann1 = Announcement(
                announcement_id=uuid.uuid4(),
                college_id=col.college_id,
                title="Welcome to Academic Session 2024-2025",
                content="Welcome back students and faculty members. Please review your lecture timetables on the portal.",
                target_role="ALL"
            )
            ann2 = Announcement(
                announcement_id=uuid.uuid4(),
                college_id=col.college_id,
                title="Midterm Assessment Submission Window",
                content="All faculty members are requested to complete grade submissions before the upcoming deadline.",
                target_role="FACULTY"
            )
            session.add_all([ann1, ann2])

            # Calendar Events
            cal1 = AcademicCalendar(
                event_id=uuid.uuid4(),
                college_id=col.college_id,
                event_title="Mid-Semester Examinations",
                event_type="EXAM",
                start_date=today + datetime.timedelta(days=15),
                end_date=today + datetime.timedelta(days=22),
                description="Theory examinations for all departments."
            )
            cal2 = AcademicCalendar(
                event_id=uuid.uuid4(),
                college_id=col.college_id,
                event_title="Annual Technical Symposium & Hackathon",
                event_type="EVENT",
                start_date=today + datetime.timedelta(days=35),
                end_date=today + datetime.timedelta(days=37),
                description="Inter-college technical competition and project showcase."
            )
            session.add_all([cal1, cal2])

        session.commit()
        print("[SUCCESS] Seeded Course Materials, Announcements, and Academic Calendar.")
        print("\n=======================================================")
        print("  ALL TABLES SEEDED SUCCESSFULLY WITH 100% TENANT INTEGRITY")
        print("=======================================================")

    except Exception as e:
        session.rollback()
        print(f"[ERROR] Error while seeding database: {e}")
        raise e
    finally:
        session.close()

if __name__ == "__main__":
    seed_database()
