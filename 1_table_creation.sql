--
-- PostgreSQL database dump
--

\restrict Gg6hZnkvbwl0qlGwCDK7lWqpnC2KvuHF66SZ7nqcbnHxddEgEtVlEIWLJgJgKvf

-- Dumped from database version 15.19
-- Dumped by pg_dump version 15.19

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

-- *not* creating schema, since initdb creates it


--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS '';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: academic_calendar; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.academic_calendar (
    event_id uuid NOT NULL,
    college_id uuid NOT NULL,
    event_title character varying(200) NOT NULL,
    event_type character varying(30) NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    description text,
    created_at timestamp with time zone NOT NULL,
    CONSTRAINT check_calendar_event_type CHECK (((event_type)::text = ANY ((ARRAY['EXAM'::character varying, 'HOLIDAY'::character varying, 'EVENT'::character varying, 'WORKSHOP'::character varying])::text[])))
);


--
-- Name: admins; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.admins (
    admin_id uuid NOT NULL,
    college_id uuid NOT NULL,
    user_id uuid NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    phone character varying(20),
    created_at timestamp with time zone NOT NULL
);


--
-- Name: announcements; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.announcements (
    announcement_id uuid NOT NULL,
    college_id uuid NOT NULL,
    author_id uuid,
    title character varying(255) NOT NULL,
    content text NOT NULL,
    target_role character varying(20) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    CONSTRAINT check_announcement_target CHECK (((target_role)::text = ANY ((ARRAY['ALL'::character varying, 'FACULTY'::character varying, 'STUDENT'::character varying])::text[])))
);


--
-- Name: assignment_submissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.assignment_submissions (
    submission_id uuid DEFAULT gen_random_uuid() NOT NULL,
    college_id uuid NOT NULL,
    assignment_id uuid NOT NULL,
    student_id uuid NOT NULL,
    submission_date timestamp with time zone DEFAULT now() NOT NULL,
    content text,
    file_url character varying(500),
    status character varying(20) DEFAULT 'SUBMITTED'::character varying NOT NULL,
    marks_obtained numeric(6,2),
    feedback text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT assignment_submissions_status_check CHECK (((status)::text = ANY ((ARRAY['PENDING'::character varying, 'SUBMITTED'::character varying, 'GRADED'::character varying, 'LATE'::character varying])::text[])))
);


--
-- Name: assignments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.assignments (
    assignment_id uuid DEFAULT gen_random_uuid() NOT NULL,
    college_id uuid NOT NULL,
    course_id uuid NOT NULL,
    title character varying(255) NOT NULL,
    description text,
    due_date timestamp with time zone NOT NULL,
    total_marks numeric(6,2) DEFAULT 100.00 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: attendance; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.attendance (
    attendance_id uuid NOT NULL,
    college_id uuid NOT NULL,
    student_id uuid NOT NULL,
    faculty_id uuid,
    course_id uuid NOT NULL,
    date_recorded date NOT NULL,
    status character varying(20) NOT NULL,
    remarks text,
    created_at timestamp with time zone NOT NULL,
    CONSTRAINT check_attendance_status CHECK (((status)::text = ANY ((ARRAY['PRESENT'::character varying, 'ABSENT'::character varying, 'LATE'::character varying, 'EXCUSED'::character varying])::text[])))
);


--
-- Name: colleges; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.colleges (
    college_id uuid NOT NULL,
    name character varying(255) NOT NULL,
    domain character varying(100) NOT NULL,
    code character varying(50) NOT NULL,
    is_active boolean NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: course_enrollments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.course_enrollments (
    enrollment_id uuid NOT NULL,
    college_id uuid NOT NULL,
    course_id uuid NOT NULL,
    student_id uuid NOT NULL,
    enrolled_at timestamp with time zone NOT NULL
);


--
-- Name: course_materials; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.course_materials (
    material_id uuid NOT NULL,
    college_id uuid NOT NULL,
    course_id uuid NOT NULL,
    faculty_id uuid NOT NULL,
    title character varying(200) NOT NULL,
    description text,
    file_url character varying(500) NOT NULL,
    file_type character varying(50) NOT NULL,
    uploaded_at timestamp with time zone NOT NULL
);


--
-- Name: courses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.courses (
    course_id uuid NOT NULL,
    college_id uuid NOT NULL,
    course_code character varying(50) NOT NULL,
    course_name character varying(200) NOT NULL,
    department character varying(100) NOT NULL,
    credits integer NOT NULL,
    semester character varying(20) NOT NULL,
    created_at timestamp with time zone NOT NULL
);


--
-- Name: examination_results; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.examination_results (
    result_id uuid DEFAULT gen_random_uuid() NOT NULL,
    college_id uuid NOT NULL,
    exam_id uuid NOT NULL,
    student_id uuid NOT NULL,
    marks_obtained numeric(6,2) NOT NULL,
    grade character varying(10),
    remarks character varying(255),
    attended boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: examinations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.examinations (
    exam_id uuid DEFAULT gen_random_uuid() NOT NULL,
    college_id uuid NOT NULL,
    course_id uuid NOT NULL,
    title character varying(255) NOT NULL,
    exam_date timestamp with time zone NOT NULL,
    duration_minutes integer DEFAULT 180 NOT NULL,
    venue character varying(150) NOT NULL,
    exam_type character varying(20) DEFAULT 'FINAL'::character varying NOT NULL,
    total_marks numeric(6,2) DEFAULT 100.00 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT examinations_exam_type_check CHECK (((exam_type)::text = ANY ((ARRAY['MIDTERM'::character varying, 'FINAL'::character varying, 'QUIZ'::character varying, 'LAB'::character varying, 'PRACTICAL'::character varying])::text[])))
);


--
-- Name: faculty; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.faculty (
    faculty_id uuid NOT NULL,
    college_id uuid NOT NULL,
    user_id uuid NOT NULL,
    employee_code character varying(50) NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    department character varying(100) NOT NULL,
    designation character varying(100),
    created_at timestamp with time zone NOT NULL
);


--
-- Name: fee_ledger; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fee_ledger (
    fee_id uuid DEFAULT gen_random_uuid() NOT NULL,
    college_id uuid NOT NULL,
    student_id uuid NOT NULL,
    description character varying(255) NOT NULL,
    amount numeric(10,2) NOT NULL,
    fee_type character varying(50) DEFAULT 'TUITION'::character varying NOT NULL,
    due_date date NOT NULL,
    status character varying(20) DEFAULT 'UNPAID'::character varying NOT NULL,
    payment_date timestamp with time zone,
    receipt_number character varying(50),
    payment_method character varying(50),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT fee_ledger_fee_type_check CHECK (((fee_type)::text = ANY ((ARRAY['TUITION'::character varying, 'LIBRARY'::character varying, 'LABORATORY'::character varying, 'HOSTEL'::character varying, 'EXAMINATION'::character varying, 'SPORTS'::character varying, 'OTHER'::character varying])::text[]))),
    CONSTRAINT fee_ledger_status_check CHECK (((status)::text = ANY ((ARRAY['PAID'::character varying, 'UNPAID'::character varying, 'OVERDUE'::character varying, 'PARTIALLY_PAID'::character varying])::text[])))
);


--
-- Name: grades; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.grades (
    grade_id uuid NOT NULL,
    college_id uuid NOT NULL,
    student_id uuid NOT NULL,
    course_id uuid NOT NULL,
    faculty_id uuid,
    assessment_name character varying(100) NOT NULL,
    score numeric(5,2) NOT NULL,
    max_score numeric(5,2) NOT NULL,
    remarks text,
    graded_at timestamp with time zone NOT NULL
);


--
-- Name: students; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.students (
    student_id uuid NOT NULL,
    college_id uuid NOT NULL,
    user_id uuid NOT NULL,
    roll_number character varying(50) NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    enrollment_year character varying(10) NOT NULL,
    semester character varying(20) NOT NULL,
    created_at timestamp with time zone NOT NULL
);


--
-- Name: timetable; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.timetable (
    timetable_id uuid NOT NULL,
    college_id uuid NOT NULL,
    course_id uuid NOT NULL,
    faculty_id uuid NOT NULL,
    day_of_week character varying(15) NOT NULL,
    start_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL,
    room_number character varying(50) NOT NULL,
    CONSTRAINT check_timetable_day CHECK (((day_of_week)::text = ANY ((ARRAY['MONDAY'::character varying, 'TUESDAY'::character varying, 'WEDNESDAY'::character varying, 'THURSDAY'::character varying, 'FRIDAY'::character varying, 'SATURDAY'::character varying])::text[])))
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    user_id uuid NOT NULL,
    college_id uuid NOT NULL,
    email character varying(255) NOT NULL,
    password_hash character varying(255) NOT NULL,
    role character varying(20) NOT NULL,
    is_active boolean NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    CONSTRAINT check_user_role CHECK (((role)::text = ANY ((ARRAY['ADMIN'::character varying, 'FACULTY'::character varying, 'STUDENT'::character varying])::text[])))
);


--
-- Name: academic_calendar academic_calendar_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.academic_calendar
    ADD CONSTRAINT academic_calendar_pkey PRIMARY KEY (event_id);


--
-- Name: admins admins_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_pkey PRIMARY KEY (admin_id);


--
-- Name: admins admins_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_user_id_key UNIQUE (user_id);


--
-- Name: announcements announcements_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.announcements
    ADD CONSTRAINT announcements_pkey PRIMARY KEY (announcement_id);


--
-- Name: assignment_submissions assignment_submissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assignment_submissions
    ADD CONSTRAINT assignment_submissions_pkey PRIMARY KEY (submission_id);


--
-- Name: assignments assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assignments
    ADD CONSTRAINT assignments_pkey PRIMARY KEY (assignment_id);


--
-- Name: attendance attendance_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_pkey PRIMARY KEY (attendance_id);


--
-- Name: colleges colleges_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.colleges
    ADD CONSTRAINT colleges_code_key UNIQUE (code);


--
-- Name: colleges colleges_domain_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.colleges
    ADD CONSTRAINT colleges_domain_key UNIQUE (domain);


--
-- Name: colleges colleges_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.colleges
    ADD CONSTRAINT colleges_pkey PRIMARY KEY (college_id);


--
-- Name: course_enrollments course_enrollments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.course_enrollments
    ADD CONSTRAINT course_enrollments_pkey PRIMARY KEY (enrollment_id);


--
-- Name: course_materials course_materials_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.course_materials
    ADD CONSTRAINT course_materials_pkey PRIMARY KEY (material_id);


--
-- Name: courses courses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_pkey PRIMARY KEY (course_id);


--
-- Name: examination_results examination_results_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.examination_results
    ADD CONSTRAINT examination_results_pkey PRIMARY KEY (result_id);


--
-- Name: examinations examinations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.examinations
    ADD CONSTRAINT examinations_pkey PRIMARY KEY (exam_id);


--
-- Name: faculty faculty_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.faculty
    ADD CONSTRAINT faculty_pkey PRIMARY KEY (faculty_id);


--
-- Name: faculty faculty_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.faculty
    ADD CONSTRAINT faculty_user_id_key UNIQUE (user_id);


--
-- Name: fee_ledger fee_ledger_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fee_ledger
    ADD CONSTRAINT fee_ledger_pkey PRIMARY KEY (fee_id);


--
-- Name: grades grades_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.grades
    ADD CONSTRAINT grades_pkey PRIMARY KEY (grade_id);


--
-- Name: students students_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_pkey PRIMARY KEY (student_id);


--
-- Name: students students_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_user_id_key UNIQUE (user_id);


--
-- Name: timetable timetable_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.timetable
    ADD CONSTRAINT timetable_pkey PRIMARY KEY (timetable_id);


--
-- Name: assignment_submissions uq_assignment_student_submission; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assignment_submissions
    ADD CONSTRAINT uq_assignment_student_submission UNIQUE (assignment_id, student_id);


--
-- Name: courses uq_course_college_code; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT uq_course_college_code UNIQUE (college_id, course_code);


--
-- Name: course_enrollments uq_enrollment_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.course_enrollments
    ADD CONSTRAINT uq_enrollment_unique UNIQUE (college_id, course_id, student_id);


--
-- Name: examination_results uq_exam_student_result; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.examination_results
    ADD CONSTRAINT uq_exam_student_result UNIQUE (exam_id, student_id);


--
-- Name: faculty uq_faculty_college_code; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.faculty
    ADD CONSTRAINT uq_faculty_college_code UNIQUE (college_id, employee_code);


--
-- Name: students uq_student_college_roll; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT uq_student_college_roll UNIQUE (college_id, roll_number);


--
-- Name: users uq_user_college_email; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT uq_user_college_email UNIQUE (college_id, email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: idx_announcements_college_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_announcements_college_date ON public.announcements USING btree (college_id, created_at);


--
-- Name: idx_assignments_course_due; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_assignments_course_due ON public.assignments USING btree (college_id, course_id, due_date);


--
-- Name: idx_attendance_course_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_attendance_course_date ON public.attendance USING btree (college_id, course_id, date_recorded);


--
-- Name: idx_attendance_student_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_attendance_student_date ON public.attendance USING btree (college_id, student_id, date_recorded);


--
-- Name: idx_calendar_dates; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_calendar_dates ON public.academic_calendar USING btree (college_id, start_date, end_date);


--
-- Name: idx_exam_course_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_exam_course_date ON public.examinations USING btree (college_id, course_id, exam_date);


--
-- Name: idx_exam_result_student; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_exam_result_student ON public.examination_results USING btree (college_id, student_id);


--
-- Name: idx_fee_student_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_fee_student_status ON public.fee_ledger USING btree (college_id, student_id, status);


--
-- Name: idx_grades_student_course; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_grades_student_course ON public.grades USING btree (college_id, student_id, course_id);


--
-- Name: idx_materials_course; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_materials_course ON public.course_materials USING btree (college_id, course_id);


--
-- Name: idx_submission_student; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_submission_student ON public.assignment_submissions USING btree (college_id, student_id);


--
-- Name: idx_timetable_course_day; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_timetable_course_day ON public.timetable USING btree (college_id, course_id, day_of_week);


--
-- Name: idx_timetable_faculty_day; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_timetable_faculty_day ON public.timetable USING btree (college_id, faculty_id, day_of_week);


--
-- Name: academic_calendar academic_calendar_college_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.academic_calendar
    ADD CONSTRAINT academic_calendar_college_id_fkey FOREIGN KEY (college_id) REFERENCES public.colleges(college_id) ON DELETE CASCADE;


--
-- Name: admins admins_college_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_college_id_fkey FOREIGN KEY (college_id) REFERENCES public.colleges(college_id) ON DELETE CASCADE;


--
-- Name: admins admins_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: announcements announcements_author_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.announcements
    ADD CONSTRAINT announcements_author_id_fkey FOREIGN KEY (author_id) REFERENCES public.users(user_id) ON DELETE SET NULL;


--
-- Name: announcements announcements_college_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.announcements
    ADD CONSTRAINT announcements_college_id_fkey FOREIGN KEY (college_id) REFERENCES public.colleges(college_id) ON DELETE CASCADE;


--
-- Name: assignment_submissions assignment_submissions_assignment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assignment_submissions
    ADD CONSTRAINT assignment_submissions_assignment_id_fkey FOREIGN KEY (assignment_id) REFERENCES public.assignments(assignment_id) ON DELETE CASCADE;


--
-- Name: assignment_submissions assignment_submissions_college_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assignment_submissions
    ADD CONSTRAINT assignment_submissions_college_id_fkey FOREIGN KEY (college_id) REFERENCES public.colleges(college_id) ON DELETE CASCADE;


--
-- Name: assignment_submissions assignment_submissions_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assignment_submissions
    ADD CONSTRAINT assignment_submissions_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(student_id) ON DELETE CASCADE;


--
-- Name: assignments assignments_college_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assignments
    ADD CONSTRAINT assignments_college_id_fkey FOREIGN KEY (college_id) REFERENCES public.colleges(college_id) ON DELETE CASCADE;


--
-- Name: assignments assignments_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assignments
    ADD CONSTRAINT assignments_course_id_fkey FOREIGN KEY (course_id) REFERENCES public.courses(course_id) ON DELETE CASCADE;


--
-- Name: attendance attendance_college_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_college_id_fkey FOREIGN KEY (college_id) REFERENCES public.colleges(college_id) ON DELETE CASCADE;


--
-- Name: attendance attendance_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_course_id_fkey FOREIGN KEY (course_id) REFERENCES public.courses(course_id) ON DELETE CASCADE;


--
-- Name: attendance attendance_faculty_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_faculty_id_fkey FOREIGN KEY (faculty_id) REFERENCES public.faculty(faculty_id) ON DELETE SET NULL;


--
-- Name: attendance attendance_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(student_id) ON DELETE CASCADE;


--
-- Name: course_enrollments course_enrollments_college_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.course_enrollments
    ADD CONSTRAINT course_enrollments_college_id_fkey FOREIGN KEY (college_id) REFERENCES public.colleges(college_id) ON DELETE CASCADE;


--
-- Name: course_enrollments course_enrollments_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.course_enrollments
    ADD CONSTRAINT course_enrollments_course_id_fkey FOREIGN KEY (course_id) REFERENCES public.courses(course_id) ON DELETE CASCADE;


--
-- Name: course_enrollments course_enrollments_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.course_enrollments
    ADD CONSTRAINT course_enrollments_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(student_id) ON DELETE CASCADE;


--
-- Name: course_materials course_materials_college_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.course_materials
    ADD CONSTRAINT course_materials_college_id_fkey FOREIGN KEY (college_id) REFERENCES public.colleges(college_id) ON DELETE CASCADE;


--
-- Name: course_materials course_materials_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.course_materials
    ADD CONSTRAINT course_materials_course_id_fkey FOREIGN KEY (course_id) REFERENCES public.courses(course_id) ON DELETE CASCADE;


--
-- Name: course_materials course_materials_faculty_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.course_materials
    ADD CONSTRAINT course_materials_faculty_id_fkey FOREIGN KEY (faculty_id) REFERENCES public.faculty(faculty_id) ON DELETE CASCADE;


--
-- Name: courses courses_college_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_college_id_fkey FOREIGN KEY (college_id) REFERENCES public.colleges(college_id) ON DELETE CASCADE;


--
-- Name: examination_results examination_results_college_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.examination_results
    ADD CONSTRAINT examination_results_college_id_fkey FOREIGN KEY (college_id) REFERENCES public.colleges(college_id) ON DELETE CASCADE;


--
-- Name: examination_results examination_results_exam_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.examination_results
    ADD CONSTRAINT examination_results_exam_id_fkey FOREIGN KEY (exam_id) REFERENCES public.examinations(exam_id) ON DELETE CASCADE;


--
-- Name: examination_results examination_results_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.examination_results
    ADD CONSTRAINT examination_results_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(student_id) ON DELETE CASCADE;


--
-- Name: examinations examinations_college_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.examinations
    ADD CONSTRAINT examinations_college_id_fkey FOREIGN KEY (college_id) REFERENCES public.colleges(college_id) ON DELETE CASCADE;


--
-- Name: examinations examinations_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.examinations
    ADD CONSTRAINT examinations_course_id_fkey FOREIGN KEY (course_id) REFERENCES public.courses(course_id) ON DELETE CASCADE;


--
-- Name: faculty faculty_college_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.faculty
    ADD CONSTRAINT faculty_college_id_fkey FOREIGN KEY (college_id) REFERENCES public.colleges(college_id) ON DELETE CASCADE;


--
-- Name: faculty faculty_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.faculty
    ADD CONSTRAINT faculty_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: fee_ledger fee_ledger_college_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fee_ledger
    ADD CONSTRAINT fee_ledger_college_id_fkey FOREIGN KEY (college_id) REFERENCES public.colleges(college_id) ON DELETE CASCADE;


--
-- Name: fee_ledger fee_ledger_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fee_ledger
    ADD CONSTRAINT fee_ledger_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(student_id) ON DELETE CASCADE;


--
-- Name: grades grades_college_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.grades
    ADD CONSTRAINT grades_college_id_fkey FOREIGN KEY (college_id) REFERENCES public.colleges(college_id) ON DELETE CASCADE;


--
-- Name: grades grades_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.grades
    ADD CONSTRAINT grades_course_id_fkey FOREIGN KEY (course_id) REFERENCES public.courses(course_id) ON DELETE CASCADE;


--
-- Name: grades grades_faculty_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.grades
    ADD CONSTRAINT grades_faculty_id_fkey FOREIGN KEY (faculty_id) REFERENCES public.faculty(faculty_id) ON DELETE SET NULL;


--
-- Name: grades grades_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.grades
    ADD CONSTRAINT grades_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(student_id) ON DELETE CASCADE;


--
-- Name: students students_college_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_college_id_fkey FOREIGN KEY (college_id) REFERENCES public.colleges(college_id) ON DELETE CASCADE;


--
-- Name: students students_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: timetable timetable_college_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.timetable
    ADD CONSTRAINT timetable_college_id_fkey FOREIGN KEY (college_id) REFERENCES public.colleges(college_id) ON DELETE CASCADE;


--
-- Name: timetable timetable_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.timetable
    ADD CONSTRAINT timetable_course_id_fkey FOREIGN KEY (course_id) REFERENCES public.courses(course_id) ON DELETE CASCADE;


--
-- Name: timetable timetable_faculty_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.timetable
    ADD CONSTRAINT timetable_faculty_id_fkey FOREIGN KEY (faculty_id) REFERENCES public.faculty(faculty_id) ON DELETE CASCADE;


--
-- Name: users users_college_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_college_id_fkey FOREIGN KEY (college_id) REFERENCES public.colleges(college_id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict Gg6hZnkvbwl0qlGwCDK7lWqpnC2KvuHF66SZ7nqcbnHxddEgEtVlEIWLJgJgKvf

