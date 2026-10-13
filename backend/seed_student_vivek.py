import asyncio
import datetime
import uuid
from sqlalchemy import select, delete
from app.db.session import AsyncSessionLocal
from app.core.security import hash_password
from app.models.user import User, Student
from app.models.college import College
from app.models.academic import Course, CourseEnrollment, Timetable
from app.models.attendance import Attendance
from app.models.grade import Grade
from app.models.student_modules import (
    Assignment,
    AssignmentSubmission,
    Examination,
    ExaminationResult,
    FeeLedger,
)

COLLEGE_ID = uuid.UUID("4b26ec2e-2e91-4ee0-a508-9fa138857b96")  # Apex Institute
VIVEK_EMAIL = "vivekshaiva9945@gmail.com"
VIVEK_PASS = "072007"
ROLL_NO = "APEX-2024-V01"

COURSES = {
    "CS101": uuid.UUID("ed911e71-dea5-4896-a6f6-5b943628dbbb"),  # Data Structures & Algorithms
    "CS102": uuid.UUID("e64f4d99-4d3a-48bf-bc08-78ff381948db"),  # Database Management Systems
    "IT201": uuid.UUID("2353386e-f081-41a6-9acb-36523f07448a"),  # Web Application Development
    "CE101": uuid.UUID("ce1e25f8-aa32-4583-9e7e-25f94a894ca2"),  # Structural Mechanics
}

FACULTY_IDS = [
    uuid.UUID("616d5366-a221-4453-9443-fdc767fb95fb"),  # Dr. Rajesh Nambiar
    uuid.UUID("91b41366-50ee-4f8e-b21f-d7fa7f0adac2"),  # Dr. Sunita Raman
    uuid.UUID("ebfb52fe-6eb1-4b18-9d85-87e28faf36fa"),  # Prof. Amit Deshmukh
]


async def seed():
    async with AsyncSessionLocal() as session:
        print(f"[*] Checking existing user for {VIVEK_EMAIL}...")
        res = await session.execute(select(User).where(User.email == VIVEK_EMAIL))
        existing_user = res.scalar_one_or_none()

        pw_hash = hash_password(VIVEK_PASS)

        if existing_user:
            print(f"[*] Updating existing user {existing_user.user_id}...")
            existing_user.password_hash = pw_hash
            existing_user.is_active = True
            existing_user.role = "STUDENT"
            user_id = existing_user.user_id
        else:
            user_id = uuid.uuid4()
            print(f"[*] Creating new user {user_id} with email {VIVEK_EMAIL}...")
            user = User(
                user_id=user_id,
                college_id=COLLEGE_ID,
                email=VIVEK_EMAIL,
                password_hash=pw_hash,
                role="STUDENT",
                is_active=True,
            )
            session.add(user)

        await session.flush()

        # Student Profile
        res = await session.execute(select(Student).where(Student.user_id == user_id))
        existing_student = res.scalar_one_or_none()

        if existing_student:
            print(f"[*] Updating student profile {existing_student.student_id}...")
            existing_student.first_name = "Vivek"
            existing_student.last_name = "I H"
            existing_student.roll_number = ROLL_NO
            existing_student.semester = "Sem 3"
            existing_student.enrollment_year = "2024"
            student_id = existing_student.student_id
        else:
            student_id = uuid.uuid4()
            print(f"[*] Creating student profile {student_id} for Vivek I H...")
            student = Student(
                student_id=student_id,
                college_id=COLLEGE_ID,
                user_id=user_id,
                roll_number=ROLL_NO,
                first_name="Vivek",
                last_name="I H",
                enrollment_year="2024",
                semester="Sem 3",
            )
            session.add(student)

        await session.flush()

        # Enrollments
        print("[*] Setting up course enrollments...")
        for code, c_id in COURSES.items():
            en_res = await session.execute(
                select(CourseEnrollment).where(
                    CourseEnrollment.college_id == COLLEGE_ID,
                    CourseEnrollment.course_id == c_id,
                    CourseEnrollment.student_id == student_id,
                )
            )
            if not en_res.scalar_one_or_none():
                session.add(
                    CourseEnrollment(
                        enrollment_id=uuid.uuid4(),
                        college_id=COLLEGE_ID,
                        course_id=c_id,
                        student_id=student_id,
                        enrolled_at=datetime.datetime.now(datetime.timezone.utc) - datetime.timedelta(days=60),
                    )
                )

        await session.flush()

        # Attendance (wipe existing for clean refresh)
        print("[*] Seeding attendance records...")
        await session.execute(delete(Attendance).where(Attendance.student_id == student_id))
        
        base_date = datetime.date.today() - datetime.timedelta(days=30)
        c_list = list(COURSES.values())
        for day_offset in range(25):
            rec_date = base_date + datetime.timedelta(days=day_offset)
            if rec_date.weekday() >= 5:  # skip weekends
                continue
            for idx, c_id in enumerate(c_list):
                # 95% attendance rate
                status = "PRESENT" if (day_offset + idx) % 15 != 0 else "LATE"
                session.add(
                    Attendance(
                        attendance_id=uuid.uuid4(),
                        college_id=COLLEGE_ID,
                        student_id=student_id,
                        faculty_id=FACULTY_IDS[idx % len(FACULTY_IDS)],
                        course_id=c_id,
                        date_recorded=rec_date,
                        status=status,
                        remarks="Regular lecture attendance",
                    )
                )

        # Grades (wipe existing for clean refresh)
        print("[*] Seeding assessment grades...")
        await session.execute(delete(Grade).where(Grade.student_id == student_id))
        grades_data = [
            (COURSES["CS101"], FACULTY_IDS[0], "Quiz 1: Tree Traversal & Recursion", 24.5, 25.0, "Excellent performance"),
            (COURSES["CS101"], FACULTY_IDS[0], "Midterm Theory: Advanced Algorithms", 48.0, 50.0, "Outstanding problem solving"),
            (COURSES["CS102"], FACULTY_IDS[1], "Lab Assessment: Complex Joins & Views", 29.0, 30.0, "Optimal query execution plans"),
            (COURSES["CS102"], FACULTY_IDS[1], "Midterm Examination: Relational Modeling", 47.5, 50.0, "Very well structured schema"),
            (COURSES["IT201"], FACULTY_IDS[2], "Sprint 1: REST API & State Management", 49.0, 50.0, "High quality clean architecture"),
            (COURSES["CE101"], FACULTY_IDS[0], "Unit Test: Statics & Beam Deflection", 23.0, 25.0, "Accurate formula derivations"),
        ]
        for c_id, f_id, name, score, max_s, rem in grades_data:
            session.add(
                Grade(
                    grade_id=uuid.uuid4(),
                    college_id=COLLEGE_ID,
                    student_id=student_id,
                    course_id=c_id,
                    faculty_id=f_id,
                    assessment_name=name,
                    score=score,
                    max_score=max_s,
                    remarks=rem,
                    graded_at=datetime.datetime.now(datetime.timezone.utc) - datetime.timedelta(days=10),
                )
            )

        # Ensure active assignments exist
        print("[*] Checking extra assignment for IT201...")
        it_assign_res = await session.execute(
            select(Assignment).where(
                Assignment.college_id == COLLEGE_ID,
                Assignment.course_id == COURSES["IT201"],
            )
        )
        it_assignment = it_assign_res.scalars().first()
        if not it_assignment:
            it_assignment = Assignment(
                assignment_id=uuid.uuid4(),
                college_id=COLLEGE_ID,
                course_id=COURSES["IT201"],
                title="Full-Stack Dashboard Architecture with Next.js & FastAPI",
                description="Implement secure JWT auth, dark-mode glassmorphic layouts, and relational PostgreSQL integration.",
                due_date=datetime.datetime.now(datetime.timezone.utc) + datetime.timedelta(days=6),
                total_marks=100.0,
            )
            session.add(it_assignment)
            await session.flush()

        # Assignment Submissions for Vivek
        print("[*] Seeding assignment submissions...")
        await session.execute(delete(AssignmentSubmission).where(AssignmentSubmission.student_id == student_id))
        
        # 1. Graded submission for CE101 assignment (Distributed Consensus or Structural)
        ce_assign = (await session.execute(select(Assignment).where(Assignment.course_id == COURSES["CE101"]))).scalars().first()
        if ce_assign:
            session.add(
                AssignmentSubmission(
                    submission_id=uuid.uuid4(),
                    college_id=COLLEGE_ID,
                    assignment_id=ce_assign.assignment_id,
                    student_id=student_id,
                    submission_date=datetime.datetime.now(datetime.timezone.utc) - datetime.timedelta(days=4),
                    content="Detailed computational model and structural deflection analysis under static loads.",
                    file_url="https://github.com/vivekshaiva9945-sys/structural-analysis-lab",
                    status="GRADED",
                    marks_obtained=96.0,
                    feedback="Flawless analysis and well documented calculations.",
                )
            )

        # 2. Submitted submission for CS102
        cs102_assign = (await session.execute(select(Assignment).where(Assignment.course_id == COURSES["CS102"]))).scalars().first()
        if cs102_assign:
            session.add(
                AssignmentSubmission(
                    submission_id=uuid.uuid4(),
                    college_id=COLLEGE_ID,
                    assignment_id=cs102_assign.assignment_id,
                    student_id=student_id,
                    submission_date=datetime.datetime.now(datetime.timezone.utc) - datetime.timedelta(days=1),
                    content="B-tree index benchmarking and PostgreSQL EXPLAIN ANALYZE comparison report.",
                    file_url="https://github.com/vivekshaiva9945-sys/db-indexing-benchmarks",
                    status="SUBMITTED",
                    marks_obtained=None,
                    feedback=None,
                )
            )

        # 3. Submitted submission for IT201
        session.add(
            AssignmentSubmission(
                submission_id=uuid.uuid4(),
                college_id=COLLEGE_ID,
                assignment_id=it_assignment.assignment_id,
                student_id=student_id,
                submission_date=datetime.datetime.now(datetime.timezone.utc) - datetime.timedelta(hours=5),
                content="Production-ready multi-tenant portal with full-stack JWT lifecycle, role validation, and responsive UI.",
                file_url="https://github.com/vivekshaiva9945-sys/EduNexa",
                status="SUBMITTED",
                marks_obtained=None,
                feedback="Under peer review by course coordinator.",
            )
        )

        # Notice: Assignment for CS101 remains PENDING (no submission) so Vivek can test submitting live in UI!

        # Examination Results
        print("[*] Seeding examination results...")
        await session.execute(delete(ExaminationResult).where(ExaminationResult.student_id == student_id))
        
        # Look for midterm exam in CS102
        db_midterm = (await session.execute(
            select(Examination).where(
                Examination.course_id == COURSES["CS102"],
                Examination.exam_type == "MIDTERM",
            )
        )).scalars().first()
        if db_midterm:
            session.add(
                ExaminationResult(
                    result_id=uuid.uuid4(),
                    college_id=COLLEGE_ID,
                    exam_id=db_midterm.exam_id,
                    student_id=student_id,
                    marks_obtained=94.5,
                    grade="A+",
                    remarks="Outstanding performance in relational algebra and query optimization theorems.",
                    attended=True,
                )
            )

        # Add 1 more completed midterm exam for CS101 so there are multiple transcript rows
        cs_midterm = (await session.execute(
            select(Examination).where(
                Examination.course_id == COURSES["CS101"],
                Examination.exam_type == "MIDTERM",
            )
        )).scalars().first()
        if not cs_midterm:
            cs_midterm = Examination(
                exam_id=uuid.uuid4(),
                college_id=COLLEGE_ID,
                course_id=COURSES["CS101"],
                title="Midterm Evaluation: Algorithms & Data Structures",
                exam_date=datetime.datetime.now(datetime.timezone.utc) - datetime.timedelta(days=22),
                duration_minutes=120,
                venue="Lecture Hall A-102",
                exam_type="MIDTERM",
                total_marks=100.0,
            )
            session.add(cs_midterm)
            await session.flush()

        session.add(
            ExaminationResult(
                result_id=uuid.uuid4(),
                college_id=COLLEGE_ID,
                exam_id=cs_midterm.exam_id,
                student_id=student_id,
                marks_obtained=97.0,
                grade="A+",
                remarks="Rank #1 in section. Exceptional dynamic programming solutions.",
                attended=True,
            )
        )

        # Fee Ledger Records
        print("[*] Seeding fee ledger records...")
        await session.execute(delete(FeeLedger).where(FeeLedger.student_id == student_id))
        
        fee_records = [
            (
                "Fall Semester 2024 Core Tuition Fee",
                3800.0,
                "TUITION",
                datetime.date.today() - datetime.timedelta(days=45),
                "PAID",
                datetime.datetime.now(datetime.timezone.utc) - datetime.timedelta(days=48),
                "REC-2024-VIV01",
                "Bank Wire Transfer",
            ),
            (
                "Advanced Computer Systems Laboratory Fee",
                550.0,
                "LABORATORY",
                datetime.date.today() - datetime.timedelta(days=30),
                "PAID",
                datetime.datetime.now(datetime.timezone.utc) - datetime.timedelta(days=32),
                "REC-2024-VIV02",
                "Credit Card",
            ),
            (
                "Digital Library & ACM Consortium Access",
                180.0,
                "LIBRARY",
                datetime.date.today() - datetime.timedelta(days=20),
                "PAID",
                datetime.datetime.now(datetime.timezone.utc) - datetime.timedelta(days=22),
                "REC-2024-VIV03",
                "UPI Instant",
            ),
            (
                "End-Semester Examination & Evaluation Registration",
                250.0,
                "EXAMINATION",
                datetime.date.today() + datetime.timedelta(days=12),
                "UNPAID",
                None,
                None,
                None,
            ),
            (
                "Campus Recreation & Sports Amenities Fee",
                120.0,
                "OTHER",
                datetime.date.today() - datetime.timedelta(days=5),
                "OVERDUE",
                None,
                None,
                None,
            ),
        ]

        for desc, amt, ftype, due, st, pay_date, rec, pmethod in fee_records:
            session.add(
                FeeLedger(
                    fee_id=uuid.uuid4(),
                    college_id=COLLEGE_ID,
                    student_id=student_id,
                    description=desc,
                    amount=amt,
                    fee_type=ftype,
                    due_date=due,
                    status=st,
                    payment_date=pay_date,
                    receipt_number=rec,
                    payment_method=pmethod,
                )
            )

        await session.commit()
        print("\n[SUCCESS] Successfully seeded student record for Vivek I H!")
        print(f"  User ID:    {user_id}")
        print(f"  Student ID: {student_id}")
        print(f"  Email:      {VIVEK_EMAIL}")
        print(f"  Password:   {VIVEK_PASS}")
        print(f"  Roll No:    {ROLL_NO}")
        print(f"  College:    Apex Institute of Technology ({COLLEGE_ID})")


if __name__ == "__main__":
    asyncio.run(seed())
