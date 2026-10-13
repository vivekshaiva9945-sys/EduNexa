-- 1. Assignments Table
CREATE TABLE IF NOT EXISTS public.assignments (
    assignment_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    college_id UUID NOT NULL REFERENCES public.colleges(college_id) ON DELETE CASCADE,
    course_id UUID NOT NULL REFERENCES public.courses(course_id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    due_date TIMESTAMPTZ NOT NULL,
    total_marks NUMERIC(6, 2) NOT NULL DEFAULT 100.00,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_assignments_course_due ON public.assignments(college_id, course_id, due_date);

-- 2. Assignment Submissions Table
CREATE TABLE IF NOT EXISTS public.assignment_submissions (
    submission_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    college_id UUID NOT NULL REFERENCES public.colleges(college_id) ON DELETE CASCADE,
    assignment_id UUID NOT NULL REFERENCES public.assignments(assignment_id) ON DELETE CASCADE,
    student_id UUID NOT NULL REFERENCES public.students(student_id) ON DELETE CASCADE,
    submission_date TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    content TEXT,
    file_url VARCHAR(500),
    status VARCHAR(20) NOT NULL DEFAULT 'SUBMITTED' CHECK (status IN ('PENDING', 'SUBMITTED', 'GRADED', 'LATE')),
    marks_obtained NUMERIC(6, 2),
    feedback TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT uq_assignment_student_submission UNIQUE (assignment_id, student_id)
);
CREATE INDEX IF NOT EXISTS idx_submission_student ON public.assignment_submissions(college_id, student_id);

-- 3. Examinations Table
CREATE TABLE IF NOT EXISTS public.examinations (
    exam_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    college_id UUID NOT NULL REFERENCES public.colleges(college_id) ON DELETE CASCADE,
    course_id UUID NOT NULL REFERENCES public.courses(course_id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    exam_date TIMESTAMPTZ NOT NULL,
    duration_minutes INT NOT NULL DEFAULT 180,
    venue VARCHAR(150) NOT NULL,
    exam_type VARCHAR(20) NOT NULL DEFAULT 'FINAL' CHECK (exam_type IN ('MIDTERM', 'FINAL', 'QUIZ', 'LAB', 'PRACTICAL')),
    total_marks NUMERIC(6, 2) NOT NULL DEFAULT 100.00,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_exam_course_date ON public.examinations(college_id, course_id, exam_date);

-- 4. Examination Results Table
CREATE TABLE IF NOT EXISTS public.examination_results (
    result_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    college_id UUID NOT NULL REFERENCES public.colleges(college_id) ON DELETE CASCADE,
    exam_id UUID NOT NULL REFERENCES public.examinations(exam_id) ON DELETE CASCADE,
    student_id UUID NOT NULL REFERENCES public.students(student_id) ON DELETE CASCADE,
    marks_obtained NUMERIC(6, 2) NOT NULL,
    grade VARCHAR(10),
    remarks VARCHAR(255),
    attended BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT uq_exam_student_result UNIQUE (exam_id, student_id)
);
CREATE INDEX IF NOT EXISTS idx_exam_result_student ON public.examination_results(college_id, student_id);

-- 5. Fee Ledger Table
CREATE TABLE IF NOT EXISTS public.fee_ledger (
    fee_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    college_id UUID NOT NULL REFERENCES public.colleges(college_id) ON DELETE CASCADE,
    student_id UUID NOT NULL REFERENCES public.students(student_id) ON DELETE CASCADE,
    description VARCHAR(255) NOT NULL,
    amount NUMERIC(10, 2) NOT NULL,
    fee_type VARCHAR(50) NOT NULL DEFAULT 'TUITION' CHECK (fee_type IN ('TUITION', 'LIBRARY', 'LABORATORY', 'HOSTEL', 'EXAMINATION', 'SPORTS', 'OTHER')),
    due_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'UNPAID' CHECK (status IN ('PAID', 'UNPAID', 'OVERDUE', 'PARTIALLY_PAID')),
    payment_date TIMESTAMPTZ,
    receipt_number VARCHAR(50),
    payment_method VARCHAR(50),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_fee_student_status ON public.fee_ledger(college_id, student_id, status);

-- Seed initial records for Apex Institute courses and student Aarav Sharma
DO $$
DECLARE
    v_college_id UUID;
    v_student_id UUID;
    v_course1 UUID;
    v_course2 UUID;
    v_course3 UUID;
    v_assign1 UUID;
    v_assign2 UUID;
    v_assign3 UUID;
    v_exam1 UUID;
    v_exam2 UUID;
    v_exam3 UUID;
BEGIN
    SELECT college_id INTO v_college_id FROM public.colleges WHERE domain LIKE '%apex%' LIMIT 1;
    SELECT student_id INTO v_student_id FROM public.students WHERE college_id = v_college_id LIMIT 1;
    
    -- Fetch 3 courses
    SELECT course_id INTO v_course1 FROM public.courses WHERE college_id = v_college_id ORDER BY course_code LIMIT 1 OFFSET 0;
    SELECT course_id INTO v_course2 FROM public.courses WHERE college_id = v_college_id ORDER BY course_code LIMIT 1 OFFSET 1;
    SELECT course_id INTO v_course3 FROM public.courses WHERE college_id = v_college_id ORDER BY course_code LIMIT 1 OFFSET 2;
    
    IF v_college_id IS NOT NULL AND v_student_id IS NOT NULL AND v_course1 IS NOT NULL THEN
        -- 1. Insert sample assignments if not exists
        IF NOT EXISTS (SELECT 1 FROM public.assignments WHERE college_id = v_college_id) THEN
            INSERT INTO public.assignments (assignment_id, college_id, course_id, title, description, due_date, total_marks)
            VALUES 
                (gen_random_uuid(), v_college_id, v_course1, 'Distributed Consensus & Raft Protocol Simulation', 'Implement leader election and log replication using Go or Python.', NOW() + INTERVAL '5 days', 100.00)
            RETURNING assignment_id INTO v_assign1;

            INSERT INTO public.assignments (assignment_id, college_id, course_id, title, description, due_date, total_marks)
            VALUES 
                (gen_random_uuid(), v_college_id, v_course2, 'Deep Learning Transformer Architecture Analysis', 'Fine-tune BERT model on sentiment classification dataset and analyze attention weights.', NOW() + INTERVAL '12 days', 50.00)
            RETURNING assignment_id INTO v_assign2;

            INSERT INTO public.assignments (assignment_id, college_id, course_id, title, description, due_date, total_marks)
            VALUES 
                (gen_random_uuid(), v_college_id, v_course3, 'Relational Query Optimization & Index Benchmarking', 'Profile B-Tree vs Hash index performance under 100k synthetic tuples.', NOW() - INTERVAL '3 days', 100.00)
            RETURNING assignment_id INTO v_assign3;

            -- Submissions for student
            INSERT INTO public.assignment_submissions (college_id, assignment_id, student_id, submission_date, content, status, marks_obtained, feedback)
            VALUES
                (v_college_id, v_assign3, v_student_id, NOW() - INTERVAL '4 days', 'Completed query execution plan analysis with EXPLAIN ANALYZE benchmarks.', 'GRADED', 94.50, 'Excellent index coverage analysis and concise explanations.');

            INSERT INTO public.assignment_submissions (college_id, assignment_id, student_id, submission_date, content, status, marks_obtained, feedback)
            VALUES
                (v_college_id, v_assign1, v_student_id, NOW() - INTERVAL '1 day', 'Implemented 3-node Raft simulation cluster with heartbeat ping-pong.', 'SUBMITTED', NULL, 'Pending evaluation by Prof. Rajesh Nambiar');
        END IF;

        -- 2. Insert Examinations & Results if not exists
        IF NOT EXISTS (SELECT 1 FROM public.examinations WHERE college_id = v_college_id) THEN
            -- Upcoming Final Exams
            INSERT INTO public.examinations (exam_id, college_id, course_id, title, exam_date, duration_minutes, venue, exam_type, total_marks)
            VALUES
                (gen_random_uuid(), v_college_id, v_course1, 'Semester End Examination: Distributed Computing', NOW() + INTERVAL '15 days' + TIME '09:30:00', 180, 'Auditorium Hall B-201', 'FINAL', 100.00)
            RETURNING exam_id INTO v_exam1;

            INSERT INTO public.examinations (exam_id, college_id, course_id, title, exam_date, duration_minutes, venue, exam_type, total_marks)
            VALUES
                (gen_random_uuid(), v_college_id, v_course2, 'Laboratory Practical Assessment: Machine Intelligence', NOW() + INTERVAL '18 days' + TIME '14:00:00', 120, 'Turing Advanced Computing Lab 4', 'LAB', 50.00)
            RETURNING exam_id INTO v_exam2;

            -- Past Midterm Exam with Result
            INSERT INTO public.examinations (exam_id, college_id, course_id, title, exam_date, duration_minutes, venue, exam_type, total_marks)
            VALUES
                (gen_random_uuid(), v_college_id, v_course3, 'Midterm Evaluation: Database Engineering', NOW() - INTERVAL '25 days', 90, 'Lecture Hall 104', 'MIDTERM', 50.00)
            RETURNING exam_id INTO v_exam3;

            INSERT INTO public.examination_results (college_id, exam_id, student_id, marks_obtained, grade, remarks, attended)
            VALUES
                (v_college_id, v_exam3, v_student_id, 46.50, 'A', 'Strong comprehension of ACID transactions and lock isolation levels.', TRUE);
        END IF;

        -- 3. Insert Fee Ledger if not exists
        IF NOT EXISTS (SELECT 1 FROM public.fee_ledger WHERE college_id = v_college_id) THEN
            -- Paid Tuition Fee
            INSERT INTO public.fee_ledger (college_id, student_id, description, amount, fee_type, due_date, status, payment_date, receipt_number, payment_method)
            VALUES
                (v_college_id, v_student_id, 'Fall Semester Academic Tuition Fee 2026', 45000.00, 'TUITION', CURRENT_DATE - INTERVAL '60 days', 'PAID', NOW() - INTERVAL '58 days', 'REC-2026-APEX-8901', 'UPI / Net Banking');

            -- Paid Laboratory Fee
            INSERT INTO public.fee_ledger (college_id, student_id, description, amount, fee_type, due_date, status, payment_date, receipt_number, payment_method)
            VALUES
                (v_college_id, v_student_id, 'Advanced Computing & Network Lab Access', 7500.00, 'LABORATORY', CURRENT_DATE - INTERVAL '45 days', 'PAID', NOW() - INTERVAL '42 days', 'REC-2026-APEX-9124', 'Credit Card');

            -- Paid Library & Digital Consortium
            INSERT INTO public.fee_ledger (college_id, student_id, description, amount, fee_type, due_date, status, payment_date, receipt_number, payment_method)
            VALUES
                (v_college_id, v_student_id, 'IEEE / ACM Digital Library Subscription', 2500.00, 'LIBRARY', CURRENT_DATE - INTERVAL '30 days', 'PAID', NOW() - INTERVAL '28 days', 'REC-2026-APEX-9450', 'Debit Card');

            -- Unpaid Upcoming Exam Assessment Fee
            INSERT INTO public.fee_ledger (college_id, student_id, description, amount, fee_type, due_date, status)
            VALUES
                (v_college_id, v_student_id, 'Term-End Board Examination & Evaluation Fee', 3500.00, 'EXAMINATION', CURRENT_DATE + INTERVAL '10 days', 'UNPAID');

            -- Overdue Campus Maintenance / Hostel Dues
            INSERT INTO public.fee_ledger (college_id, student_id, description, amount, fee_type, due_date, status)
            VALUES
                (v_college_id, v_student_id, 'Residential Hostel & Dining Maintenance Dues (Installment 1)', 12000.00, 'HOSTEL', CURRENT_DATE - INTERVAL '5 days', 'OVERDUE');
        END IF;
    END IF;
END $$;
