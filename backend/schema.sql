--
-- PostgreSQL database dump
--

\restrict sPOBuvfXN3U8U35HCgB04AxwabRTjgvYZNuaz0SKKc3taO4E3Uh7Drf6VbBM6Wi

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

ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_college_id_fkey;
ALTER TABLE IF EXISTS ONLY public.timetable DROP CONSTRAINT IF EXISTS timetable_faculty_id_fkey;
ALTER TABLE IF EXISTS ONLY public.timetable DROP CONSTRAINT IF EXISTS timetable_course_id_fkey;
ALTER TABLE IF EXISTS ONLY public.timetable DROP CONSTRAINT IF EXISTS timetable_college_id_fkey;
ALTER TABLE IF EXISTS ONLY public.students DROP CONSTRAINT IF EXISTS students_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.students DROP CONSTRAINT IF EXISTS students_college_id_fkey;
ALTER TABLE IF EXISTS ONLY public.grades DROP CONSTRAINT IF EXISTS grades_student_id_fkey;
ALTER TABLE IF EXISTS ONLY public.grades DROP CONSTRAINT IF EXISTS grades_faculty_id_fkey;
ALTER TABLE IF EXISTS ONLY public.grades DROP CONSTRAINT IF EXISTS grades_course_id_fkey;
ALTER TABLE IF EXISTS ONLY public.grades DROP CONSTRAINT IF EXISTS grades_college_id_fkey;
ALTER TABLE IF EXISTS ONLY public.faculty DROP CONSTRAINT IF EXISTS faculty_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.faculty DROP CONSTRAINT IF EXISTS faculty_college_id_fkey;
ALTER TABLE IF EXISTS ONLY public.courses DROP CONSTRAINT IF EXISTS courses_college_id_fkey;
ALTER TABLE IF EXISTS ONLY public.course_materials DROP CONSTRAINT IF EXISTS course_materials_faculty_id_fkey;
ALTER TABLE IF EXISTS ONLY public.course_materials DROP CONSTRAINT IF EXISTS course_materials_course_id_fkey;
ALTER TABLE IF EXISTS ONLY public.course_materials DROP CONSTRAINT IF EXISTS course_materials_college_id_fkey;
ALTER TABLE IF EXISTS ONLY public.course_enrollments DROP CONSTRAINT IF EXISTS course_enrollments_student_id_fkey;
ALTER TABLE IF EXISTS ONLY public.course_enrollments DROP CONSTRAINT IF EXISTS course_enrollments_course_id_fkey;
ALTER TABLE IF EXISTS ONLY public.course_enrollments DROP CONSTRAINT IF EXISTS course_enrollments_college_id_fkey;
ALTER TABLE IF EXISTS ONLY public.attendance DROP CONSTRAINT IF EXISTS attendance_student_id_fkey;
ALTER TABLE IF EXISTS ONLY public.attendance DROP CONSTRAINT IF EXISTS attendance_faculty_id_fkey;
ALTER TABLE IF EXISTS ONLY public.attendance DROP CONSTRAINT IF EXISTS attendance_course_id_fkey;
ALTER TABLE IF EXISTS ONLY public.attendance DROP CONSTRAINT IF EXISTS attendance_college_id_fkey;
ALTER TABLE IF EXISTS ONLY public.announcements DROP CONSTRAINT IF EXISTS announcements_college_id_fkey;
ALTER TABLE IF EXISTS ONLY public.announcements DROP CONSTRAINT IF EXISTS announcements_author_id_fkey;
ALTER TABLE IF EXISTS ONLY public.admins DROP CONSTRAINT IF EXISTS admins_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.admins DROP CONSTRAINT IF EXISTS admins_college_id_fkey;
ALTER TABLE IF EXISTS ONLY public.academic_calendar DROP CONSTRAINT IF EXISTS academic_calendar_college_id_fkey;
DROP INDEX IF EXISTS public.idx_timetable_faculty_day;
DROP INDEX IF EXISTS public.idx_timetable_course_day;
DROP INDEX IF EXISTS public.idx_materials_course;
DROP INDEX IF EXISTS public.idx_grades_student_course;
DROP INDEX IF EXISTS public.idx_calendar_dates;
DROP INDEX IF EXISTS public.idx_attendance_student_date;
DROP INDEX IF EXISTS public.idx_attendance_course_date;
DROP INDEX IF EXISTS public.idx_announcements_college_date;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_pkey;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS uq_user_college_email;
ALTER TABLE IF EXISTS ONLY public.students DROP CONSTRAINT IF EXISTS uq_student_college_roll;
ALTER TABLE IF EXISTS ONLY public.faculty DROP CONSTRAINT IF EXISTS uq_faculty_college_code;
ALTER TABLE IF EXISTS ONLY public.course_enrollments DROP CONSTRAINT IF EXISTS uq_enrollment_unique;
ALTER TABLE IF EXISTS ONLY public.courses DROP CONSTRAINT IF EXISTS uq_course_college_code;
ALTER TABLE IF EXISTS ONLY public.timetable DROP CONSTRAINT IF EXISTS timetable_pkey;
ALTER TABLE IF EXISTS ONLY public.students DROP CONSTRAINT IF EXISTS students_user_id_key;
ALTER TABLE IF EXISTS ONLY public.students DROP CONSTRAINT IF EXISTS students_pkey;
ALTER TABLE IF EXISTS ONLY public.grades DROP CONSTRAINT IF EXISTS grades_pkey;
ALTER TABLE IF EXISTS ONLY public.faculty DROP CONSTRAINT IF EXISTS faculty_user_id_key;
ALTER TABLE IF EXISTS ONLY public.faculty DROP CONSTRAINT IF EXISTS faculty_pkey;
ALTER TABLE IF EXISTS ONLY public.courses DROP CONSTRAINT IF EXISTS courses_pkey;
ALTER TABLE IF EXISTS ONLY public.course_materials DROP CONSTRAINT IF EXISTS course_materials_pkey;
ALTER TABLE IF EXISTS ONLY public.course_enrollments DROP CONSTRAINT IF EXISTS course_enrollments_pkey;
ALTER TABLE IF EXISTS ONLY public.colleges DROP CONSTRAINT IF EXISTS colleges_pkey;
ALTER TABLE IF EXISTS ONLY public.colleges DROP CONSTRAINT IF EXISTS colleges_domain_key;
ALTER TABLE IF EXISTS ONLY public.colleges DROP CONSTRAINT IF EXISTS colleges_code_key;
ALTER TABLE IF EXISTS ONLY public.attendance DROP CONSTRAINT IF EXISTS attendance_pkey;
ALTER TABLE IF EXISTS ONLY public.announcements DROP CONSTRAINT IF EXISTS announcements_pkey;
ALTER TABLE IF EXISTS ONLY public.admins DROP CONSTRAINT IF EXISTS admins_user_id_key;
ALTER TABLE IF EXISTS ONLY public.admins DROP CONSTRAINT IF EXISTS admins_pkey;
ALTER TABLE IF EXISTS ONLY public.academic_calendar DROP CONSTRAINT IF EXISTS academic_calendar_pkey;
DROP TABLE IF EXISTS public.users;
DROP TABLE IF EXISTS public.timetable;
DROP TABLE IF EXISTS public.students;
DROP TABLE IF EXISTS public.grades;
DROP TABLE IF EXISTS public.faculty;
DROP TABLE IF EXISTS public.courses;
DROP TABLE IF EXISTS public.course_materials;
DROP TABLE IF EXISTS public.course_enrollments;
DROP TABLE IF EXISTS public.colleges;
DROP TABLE IF EXISTS public.attendance;
DROP TABLE IF EXISTS public.announcements;
DROP TABLE IF EXISTS public.admins;
DROP TABLE IF EXISTS public.academic_calendar;
-- *not* dropping schema, since initdb creates it
--
-- Name: public; Type: SCHEMA; Schema: -; Owner: edunexa_admin
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO edunexa_admin;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: edunexa_admin
--

COMMENT ON SCHEMA public IS '';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: academic_calendar; Type: TABLE; Schema: public; Owner: edunexa_admin
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


ALTER TABLE public.academic_calendar OWNER TO edunexa_admin;

--
-- Name: admins; Type: TABLE; Schema: public; Owner: edunexa_admin
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


ALTER TABLE public.admins OWNER TO edunexa_admin;

--
-- Name: announcements; Type: TABLE; Schema: public; Owner: edunexa_admin
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


ALTER TABLE public.announcements OWNER TO edunexa_admin;

--
-- Name: attendance; Type: TABLE; Schema: public; Owner: edunexa_admin
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


ALTER TABLE public.attendance OWNER TO edunexa_admin;

--
-- Name: colleges; Type: TABLE; Schema: public; Owner: edunexa_admin
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


ALTER TABLE public.colleges OWNER TO edunexa_admin;

--
-- Name: course_enrollments; Type: TABLE; Schema: public; Owner: edunexa_admin
--

CREATE TABLE public.course_enrollments (
    enrollment_id uuid NOT NULL,
    college_id uuid NOT NULL,
    course_id uuid NOT NULL,
    student_id uuid NOT NULL,
    enrolled_at timestamp with time zone NOT NULL
);


ALTER TABLE public.course_enrollments OWNER TO edunexa_admin;

--
-- Name: course_materials; Type: TABLE; Schema: public; Owner: edunexa_admin
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


ALTER TABLE public.course_materials OWNER TO edunexa_admin;

--
-- Name: courses; Type: TABLE; Schema: public; Owner: edunexa_admin
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


ALTER TABLE public.courses OWNER TO edunexa_admin;

--
-- Name: faculty; Type: TABLE; Schema: public; Owner: edunexa_admin
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


ALTER TABLE public.faculty OWNER TO edunexa_admin;

--
-- Name: grades; Type: TABLE; Schema: public; Owner: edunexa_admin
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


ALTER TABLE public.grades OWNER TO edunexa_admin;

--
-- Name: students; Type: TABLE; Schema: public; Owner: edunexa_admin
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


ALTER TABLE public.students OWNER TO edunexa_admin;

--
-- Name: timetable; Type: TABLE; Schema: public; Owner: edunexa_admin
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


ALTER TABLE public.timetable OWNER TO edunexa_admin;

--
-- Name: users; Type: TABLE; Schema: public; Owner: edunexa_admin
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


ALTER TABLE public.users OWNER TO edunexa_admin;

--
-- Data for Name: academic_calendar; Type: TABLE DATA; Schema: public; Owner: edunexa_admin
--

INSERT INTO public.academic_calendar (event_id, college_id, event_title, event_type, start_date, end_date, description, created_at) VALUES ('aced969d-e1f5-4ded-b21a-9e52591b855f', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'Mid-Semester Examinations', 'EXAM', '2026-10-16', '2026-10-23', 'Theory examinations for all departments.', '2026-10-01 14:07:55.686817+00');
INSERT INTO public.academic_calendar (event_id, college_id, event_title, event_type, start_date, end_date, description, created_at) VALUES ('5e7f0fa4-a622-4222-9a11-2c81ed454554', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'Annual Technical Symposium & Hackathon', 'EVENT', '2026-11-05', '2026-11-07', 'Inter-college technical competition and project showcase.', '2026-10-01 14:07:55.68682+00');
INSERT INTO public.academic_calendar (event_id, college_id, event_title, event_type, start_date, end_date, description, created_at) VALUES ('b2fd1c45-60e9-40f3-b824-cc77ec92905e', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'Mid-Semester Examinations', 'EXAM', '2026-10-16', '2026-10-23', 'Theory examinations for all departments.', '2026-10-01 14:07:55.686821+00');
INSERT INTO public.academic_calendar (event_id, college_id, event_title, event_type, start_date, end_date, description, created_at) VALUES ('b97a0732-4651-4e5e-bc2b-c8a182755ef1', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'Annual Technical Symposium & Hackathon', 'EVENT', '2026-11-05', '2026-11-07', 'Inter-college technical competition and project showcase.', '2026-10-01 14:07:55.686821+00');


--
-- Data for Name: admins; Type: TABLE DATA; Schema: public; Owner: edunexa_admin
--

INSERT INTO public.admins (admin_id, college_id, user_id, first_name, last_name, phone, created_at) VALUES ('c69e721e-dbb4-4eb1-b993-37bdf70c9fc0', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '4cfe136a-1566-4f2e-91f9-1515dccaa298', 'Robert', 'Vance', '+1-555-0101', '2026-10-01 14:07:55.421286+00');
INSERT INTO public.admins (admin_id, college_id, user_id, first_name, last_name, phone, created_at) VALUES ('5cf34a94-aebb-4774-bb95-b5aaa8a5e102', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '4e6fa60d-5767-4ea7-8204-8007becd2746', 'Eleanor', 'Sterling', '+1-555-0202', '2026-10-01 14:07:55.423213+00');


--
-- Data for Name: announcements; Type: TABLE DATA; Schema: public; Owner: edunexa_admin
--

INSERT INTO public.announcements (announcement_id, college_id, author_id, title, content, target_role, created_at) VALUES ('e428b27b-e572-4173-8399-98a6b69fb8ba', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', NULL, 'Welcome to Academic Session 2024-2025', 'Welcome back students and faculty members. Please review your lecture timetables on the portal.', 'ALL', '2026-10-01 14:07:55.68876+00');
INSERT INTO public.announcements (announcement_id, college_id, author_id, title, content, target_role, created_at) VALUES ('7aa26171-43e5-4f16-9484-3c6558fbdbcf', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', NULL, 'Midterm Assessment Submission Window', 'All faculty members are requested to complete grade submissions before the upcoming deadline.', 'FACULTY', '2026-10-01 14:07:55.688775+00');
INSERT INTO public.announcements (announcement_id, college_id, author_id, title, content, target_role, created_at) VALUES ('08b76de1-722a-4b64-9a98-c910fba1fe37', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', NULL, 'Welcome to Academic Session 2024-2025', 'Welcome back students and faculty members. Please review your lecture timetables on the portal.', 'ALL', '2026-10-01 14:07:55.688776+00');
INSERT INTO public.announcements (announcement_id, college_id, author_id, title, content, target_role, created_at) VALUES ('0e7a6599-bc87-4c5c-b96a-3e7cc1786987', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', NULL, 'Midterm Assessment Submission Window', 'All faculty members are requested to complete grade submissions before the upcoming deadline.', 'FACULTY', '2026-10-01 14:07:55.688776+00');


--
-- Data for Name: attendance; Type: TABLE DATA; Schema: public; Owner: edunexa_admin
--

INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('0dd76016-5cd3-41c9-9c2d-bc9169f3f831', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'd91be8a0-c589-4080-a507-14f8dfdd23b2', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-30', 'LATE', 'Regular Class Session', '2026-10-01 14:07:55.594341+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('c4930716-ef20-447f-ad52-22da567c49c0', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'd91be8a0-c589-4080-a507-14f8dfdd23b2', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-29', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594345+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('fe87e65e-dfdc-43e1-a7fc-271731b3b877', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'd91be8a0-c589-4080-a507-14f8dfdd23b2', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-28', 'ABSENT', 'Regular Class Session', '2026-10-01 14:07:55.594346+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('7f0f5adb-2f40-447c-beb8-805aef3e5ddb', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'd91be8a0-c589-4080-a507-14f8dfdd23b2', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-30', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594346+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('e52adc0b-4b8d-4bda-841c-24acea72f839', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'd91be8a0-c589-4080-a507-14f8dfdd23b2', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-29', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594347+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('245bea86-0c37-450f-8509-428d16dfc833', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'd91be8a0-c589-4080-a507-14f8dfdd23b2', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-28', 'LATE', 'Regular Class Session', '2026-10-01 14:07:55.594347+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('4825b63d-f00d-4fdd-8105-2d0f85e07211', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '66978ac8-b94a-472f-98c7-012edb67c91b', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-30', 'ABSENT', 'Regular Class Session', '2026-10-01 14:07:55.594348+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('3bcb0bbf-ccf2-4e70-b875-2c7277859d22', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '66978ac8-b94a-472f-98c7-012edb67c91b', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-29', 'LATE', 'Regular Class Session', '2026-10-01 14:07:55.594348+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('195670e0-25c8-473f-bff2-9e4e85130fe7', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '66978ac8-b94a-472f-98c7-012edb67c91b', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-28', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594348+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('e7ec701d-4863-4ba6-a1a4-cd9f3cf3a0e0', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '66978ac8-b94a-472f-98c7-012edb67c91b', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-30', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594349+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('dbd5703b-7ac5-4904-975e-4b2c3fe0751c', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '66978ac8-b94a-472f-98c7-012edb67c91b', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-29', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594349+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('e04e85f1-2e16-4cb4-a16d-f0e107bd7f92', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '66978ac8-b94a-472f-98c7-012edb67c91b', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-28', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.59435+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('0005182b-ad42-4d94-ba05-ff98abe6220d', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'd24111ba-f892-4a39-a392-85e81eb9132c', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-30', 'LATE', 'Regular Class Session', '2026-10-01 14:07:55.59435+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('a8438315-b730-436b-866e-b1711731862c', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'd24111ba-f892-4a39-a392-85e81eb9132c', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-29', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594351+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('1df11b37-0d46-4730-9f94-45e15eaf632a', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'd24111ba-f892-4a39-a392-85e81eb9132c', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-28', 'LATE', 'Regular Class Session', '2026-10-01 14:07:55.594351+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('8fea630b-08e8-4beb-8ed2-235d584a84a8', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'd24111ba-f892-4a39-a392-85e81eb9132c', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-30', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594351+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('1734d1a5-0ef6-488f-9357-d7cacea5b185', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'd24111ba-f892-4a39-a392-85e81eb9132c', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-29', 'ABSENT', 'Regular Class Session', '2026-10-01 14:07:55.594352+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('c2d522ed-987c-449a-974a-530d866be7fc', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'd24111ba-f892-4a39-a392-85e81eb9132c', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-28', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594352+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('03f4b3fe-585a-4a2a-b236-3ae723306737', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'b53d8f73-83df-4762-b522-a445d9933f63', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-30', 'ABSENT', 'Regular Class Session', '2026-10-01 14:07:55.594352+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('2e536cb8-1b38-4913-8d8f-2be1236e231f', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'b53d8f73-83df-4762-b522-a445d9933f63', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-29', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594353+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('cf22a44d-a40d-4c8b-b8d4-dadaf4ffc22e', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'b53d8f73-83df-4762-b522-a445d9933f63', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-28', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594353+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('44b4c0fa-9387-4330-9f32-6fe456af8c3f', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'b53d8f73-83df-4762-b522-a445d9933f63', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-30', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594353+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('e143ccff-29a2-4d0a-8a52-2947410ff7b5', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'b53d8f73-83df-4762-b522-a445d9933f63', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-29', 'LATE', 'Regular Class Session', '2026-10-01 14:07:55.594354+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('48d0cd85-9757-4417-8782-ea42f6c43dc1', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'b53d8f73-83df-4762-b522-a445d9933f63', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-28', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594354+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('70775568-865a-45e2-9478-c8249a75d65d', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'b278f61a-13eb-41c1-99d5-2110b3a1bcc5', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-30', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594355+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('ef564101-80ba-43cb-acb5-c867fda89f4c', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'b278f61a-13eb-41c1-99d5-2110b3a1bcc5', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-29', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594355+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('854ae638-f302-49cd-9a11-840ed11d2d37', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'b278f61a-13eb-41c1-99d5-2110b3a1bcc5', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-28', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594355+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('3e635961-6a1f-4dcf-b34c-7e8fcb6c150a', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'b278f61a-13eb-41c1-99d5-2110b3a1bcc5', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-30', 'LATE', 'Regular Class Session', '2026-10-01 14:07:55.594356+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('7e002cf7-7094-4617-8436-f3094a82e8cb', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'b278f61a-13eb-41c1-99d5-2110b3a1bcc5', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-29', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594356+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('433ec6af-69b9-4b31-af61-399c4a033cf1', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'b278f61a-13eb-41c1-99d5-2110b3a1bcc5', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-28', 'ABSENT', 'Regular Class Session', '2026-10-01 14:07:55.594356+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('d860404b-5d4f-469b-9557-aff6f24e24aa', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '4c6bc0c4-345d-423e-952f-fbd00e9abe3d', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-30', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594357+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('69845017-1e38-450e-a8d7-f2d6281140fc', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '4c6bc0c4-345d-423e-952f-fbd00e9abe3d', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-29', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594357+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('d449d0ad-8106-4884-8da3-db960bd42ecf', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '4c6bc0c4-345d-423e-952f-fbd00e9abe3d', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-28', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594357+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('5cdb0322-41bc-4a06-994e-bd2e96fc4c5f', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '4c6bc0c4-345d-423e-952f-fbd00e9abe3d', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-30', 'LATE', 'Regular Class Session', '2026-10-01 14:07:55.594358+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('2022fed1-7db3-4135-92cd-955c62e9d1e4', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '4c6bc0c4-345d-423e-952f-fbd00e9abe3d', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-29', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594358+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('32eccd17-9f78-4237-8a93-d13aa3e5bc23', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '4c6bc0c4-345d-423e-952f-fbd00e9abe3d', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-28', 'LATE', 'Regular Class Session', '2026-10-01 14:07:55.594358+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('48f2c995-d204-4110-b195-35b5bf32a629', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'a7a87c91-31e1-4c95-9071-39b742346013', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-30', 'LATE', 'Regular Class Session', '2026-10-01 14:07:55.594359+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('a0237f3a-fac7-4643-a1bc-b542f36197b3', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'a7a87c91-31e1-4c95-9071-39b742346013', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-29', 'ABSENT', 'Regular Class Session', '2026-10-01 14:07:55.594359+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('f334fb12-f52b-4e72-8006-2d4aa1b6a741', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'a7a87c91-31e1-4c95-9071-39b742346013', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-28', 'ABSENT', 'Regular Class Session', '2026-10-01 14:07:55.594359+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('5414ff6a-8f88-4ef3-804e-c6554959fc9f', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'a7a87c91-31e1-4c95-9071-39b742346013', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-30', 'ABSENT', 'Regular Class Session', '2026-10-01 14:07:55.59436+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('ecfabdf1-9b48-4bd4-a4c1-5a55860a5510', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'a7a87c91-31e1-4c95-9071-39b742346013', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-29', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.59436+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('727b4879-e703-4e1f-bc4d-6c105fa846a4', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'a7a87c91-31e1-4c95-9071-39b742346013', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-28', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.59436+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('9e891d10-16d0-4f20-920f-5795017d2ccf', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '535e3192-51ae-4e6e-90cf-473b1f0db55c', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-30', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594361+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('635d7287-2d6a-4984-86fc-51fc1a5ef3c0', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '535e3192-51ae-4e6e-90cf-473b1f0db55c', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-29', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594361+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('557a0275-2bb3-408a-993e-24f61298adcb', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '535e3192-51ae-4e6e-90cf-473b1f0db55c', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-28', 'ABSENT', 'Regular Class Session', '2026-10-01 14:07:55.594361+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('833b49d3-8dff-41c9-9ead-cd8557212d05', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '535e3192-51ae-4e6e-90cf-473b1f0db55c', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-30', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594362+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('e13d5d1c-c9f2-4501-bf10-57244b8d2c23', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '535e3192-51ae-4e6e-90cf-473b1f0db55c', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-29', 'ABSENT', 'Regular Class Session', '2026-10-01 14:07:55.594362+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('025dc4c9-2269-4f49-acf4-ff674fd235e9', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '535e3192-51ae-4e6e-90cf-473b1f0db55c', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-28', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594363+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('9d93f953-783a-4dfb-9dd3-059b20f147d3', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '169a3258-9e01-4b90-ace8-66be170c035f', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-30', 'ABSENT', 'Regular Class Session', '2026-10-01 14:07:55.594363+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('2c2dff0b-02d9-4a93-a184-1160257058ad', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '169a3258-9e01-4b90-ace8-66be170c035f', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-29', 'LATE', 'Regular Class Session', '2026-10-01 14:07:55.594363+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('ead9da3f-01e4-4272-932f-8a5180a1ea5c', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '169a3258-9e01-4b90-ace8-66be170c035f', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-28', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594364+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('21b6dd11-c260-4d74-9396-778a5f009d65', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '169a3258-9e01-4b90-ace8-66be170c035f', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-30', 'LATE', 'Regular Class Session', '2026-10-01 14:07:55.594364+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('290393c2-43b8-40bb-aeab-f7829d490c86', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '169a3258-9e01-4b90-ace8-66be170c035f', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-29', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594364+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('fe709571-b5f4-4ea5-b594-ceb0364ab55c', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '169a3258-9e01-4b90-ace8-66be170c035f', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-28', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594365+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('1c792143-0d00-457a-9df2-eb48b4e31d9c', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'a13e1758-df90-4ef6-b7b7-664b5c273eca', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-30', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594365+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('56194e51-5e00-4fba-8620-afc096ac02af', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'a13e1758-df90-4ef6-b7b7-664b5c273eca', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-29', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594365+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('83aae56f-e514-4259-b058-f18ade2b0f8c', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'a13e1758-df90-4ef6-b7b7-664b5c273eca', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-28', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594366+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('d72ce3e1-7f51-4217-8c4d-eb08e056ba12', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'a13e1758-df90-4ef6-b7b7-664b5c273eca', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-30', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594366+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('769aa50e-c330-4b77-a7fa-7dfe8b00d210', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'a13e1758-df90-4ef6-b7b7-664b5c273eca', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-29', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594366+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('745a7865-f159-4787-8b18-f61282f1485f', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'a13e1758-df90-4ef6-b7b7-664b5c273eca', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-28', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594367+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('15cde722-3ee5-4241-a786-223828dfab38', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '4cf325fa-5154-4620-a4fc-049776c9e6b6', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-30', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594367+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('76cca5e6-6901-41d9-b9f9-27525913a298', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '4cf325fa-5154-4620-a4fc-049776c9e6b6', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-29', 'ABSENT', 'Regular Class Session', '2026-10-01 14:07:55.594367+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('8ac7eb4d-2b5d-45dd-b6e0-f4a35289cf37', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '4cf325fa-5154-4620-a4fc-049776c9e6b6', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-28', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594368+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('3d307727-0329-4f9e-a57b-5c9356c43a70', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '4cf325fa-5154-4620-a4fc-049776c9e6b6', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-30', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594368+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('e2ae9884-031c-4e08-a70b-c022b7688d9e', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '4cf325fa-5154-4620-a4fc-049776c9e6b6', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-29', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594368+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('6cd254ba-7018-4183-81fb-122c5ed6b63b', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '4cf325fa-5154-4620-a4fc-049776c9e6b6', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-28', 'LATE', 'Regular Class Session', '2026-10-01 14:07:55.594369+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('aa270446-e4fe-4fc6-9ea6-dfc4149591a3', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '03ac1155-58c5-4b44-b605-4ccaf8d6a02d', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-30', 'LATE', 'Regular Class Session', '2026-10-01 14:07:55.594369+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('d664229e-e546-4fac-857a-e81f5d48e009', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '03ac1155-58c5-4b44-b605-4ccaf8d6a02d', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-29', 'LATE', 'Regular Class Session', '2026-10-01 14:07:55.594369+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('1244799e-888d-43b3-8053-e1f634f688db', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '03ac1155-58c5-4b44-b605-4ccaf8d6a02d', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-28', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594371+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('ca7a29a2-f714-46cf-b949-18556582f255', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '03ac1155-58c5-4b44-b605-4ccaf8d6a02d', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-30', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594371+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('7b2f90ee-ad87-4d91-af2a-821c1d35da4a', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '03ac1155-58c5-4b44-b605-4ccaf8d6a02d', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-29', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594372+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('c67efab4-9d06-42d6-9385-4c7e2a231aa3', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '03ac1155-58c5-4b44-b605-4ccaf8d6a02d', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-28', 'ABSENT', 'Regular Class Session', '2026-10-01 14:07:55.594372+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('a7e31166-e7a7-471a-aa59-5bdc9c116271', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'fdeb06a3-74da-4120-bc71-653085b7aea0', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-30', 'ABSENT', 'Regular Class Session', '2026-10-01 14:07:55.594373+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('e723c379-d9fc-4604-9aaf-7d09f291b9ce', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'fdeb06a3-74da-4120-bc71-653085b7aea0', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-29', 'LATE', 'Regular Class Session', '2026-10-01 14:07:55.594373+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('f61a6bde-1569-4569-9c31-d75caea33a34', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'fdeb06a3-74da-4120-bc71-653085b7aea0', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-28', 'LATE', 'Regular Class Session', '2026-10-01 14:07:55.594373+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('a064dcc7-becb-4e1b-9e5b-7e8ef94de0e0', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'fdeb06a3-74da-4120-bc71-653085b7aea0', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-30', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594374+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('524353fa-9293-4bab-956c-5d7634b543fa', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'fdeb06a3-74da-4120-bc71-653085b7aea0', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-29', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594374+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('94e3d4fa-c0aa-4a0d-ad67-76a217d94997', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'fdeb06a3-74da-4120-bc71-653085b7aea0', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-28', 'LATE', 'Regular Class Session', '2026-10-01 14:07:55.594374+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('c600c9f4-f893-4d9d-84fc-05721f1fba35', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'fc0f5eed-999f-4329-8368-17737a95e148', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-30', 'LATE', 'Regular Class Session', '2026-10-01 14:07:55.594375+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('1fde12cb-53e5-4e14-b662-7d8a8d84d116', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'fc0f5eed-999f-4329-8368-17737a95e148', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-29', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594375+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('67bc3958-62b1-4675-a32a-758e09afa009', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'fc0f5eed-999f-4329-8368-17737a95e148', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-28', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594375+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('7aab42e3-62da-422b-b334-39e719b993e7', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'fc0f5eed-999f-4329-8368-17737a95e148', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-30', 'ABSENT', 'Regular Class Session', '2026-10-01 14:07:55.594376+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('83801383-b042-4fd7-8609-792d29602b76', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'fc0f5eed-999f-4329-8368-17737a95e148', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-29', 'ABSENT', 'Regular Class Session', '2026-10-01 14:07:55.594376+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('5f22f90d-5229-4af5-b31d-967e4a8ab851', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'fc0f5eed-999f-4329-8368-17737a95e148', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-28', 'ABSENT', 'Regular Class Session', '2026-10-01 14:07:55.594376+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('35531b99-e85b-4885-864f-7958d5259543', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '44da7ddf-963f-4685-8d4b-f09eb6900c65', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-30', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594377+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('e7da4d7b-765a-44a2-bab6-61fb34ee473d', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '44da7ddf-963f-4685-8d4b-f09eb6900c65', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-29', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594377+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('6f801201-bbca-4cad-b309-b495efd49976', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '44da7ddf-963f-4685-8d4b-f09eb6900c65', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-28', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594377+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('c7647e77-6aa5-4012-8644-a0f32198337e', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '44da7ddf-963f-4685-8d4b-f09eb6900c65', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-30', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594378+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('a41fd10e-9591-49b4-8bc7-ead5eb0daa8a', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '44da7ddf-963f-4685-8d4b-f09eb6900c65', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-29', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594378+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('a4e60d57-c542-4a12-a6c5-79cb7a967957', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '44da7ddf-963f-4685-8d4b-f09eb6900c65', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-28', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594378+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('c5f4bb72-c132-4188-9bfd-93a0b78dd7d4', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '487eef9d-7e83-44ff-ba05-5633563d482c', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-30', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594379+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('4b119f28-5a3b-4332-9392-919f0efe6121', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '487eef9d-7e83-44ff-ba05-5633563d482c', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-29', 'LATE', 'Regular Class Session', '2026-10-01 14:07:55.594379+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('f1938bd6-f087-43b4-b5ec-db0f731e04c3', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '487eef9d-7e83-44ff-ba05-5633563d482c', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-28', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594379+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('e7215d56-0561-4371-b78c-af01566487ed', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '487eef9d-7e83-44ff-ba05-5633563d482c', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-30', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.59438+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('c5dbc4d5-810f-4e7d-8e19-964ab0f48d7d', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '487eef9d-7e83-44ff-ba05-5633563d482c', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-29', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.59438+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('ecfe2d45-9ee3-4626-9b53-1a0e4eab5d82', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '487eef9d-7e83-44ff-ba05-5633563d482c', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-28', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.59438+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('edd962c5-1d86-4502-8d7b-26f39c0cf4e9', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '3c246328-8187-4c8f-8785-1fbc652f0b34', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-30', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594381+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('b1ecc27c-5ee3-4a96-93a1-e0f96868484a', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '3c246328-8187-4c8f-8785-1fbc652f0b34', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-29', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594381+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('b145a2a4-a696-46f5-866e-b96fd12672b9', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '3c246328-8187-4c8f-8785-1fbc652f0b34', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-28', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594381+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('fce1bf6a-0c97-43fc-8466-69ddcdd87a59', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '3c246328-8187-4c8f-8785-1fbc652f0b34', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-30', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594382+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('a9746bae-2c87-4dd3-b467-d6f285fc509f', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '3c246328-8187-4c8f-8785-1fbc652f0b34', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-29', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594382+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('6ea66273-aa2c-4c08-acda-f64b4a46faf2', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '3c246328-8187-4c8f-8785-1fbc652f0b34', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-28', 'LATE', 'Regular Class Session', '2026-10-01 14:07:55.594382+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('268bf264-2aeb-407c-9663-cd2007bfaf89', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '09c8b7bd-6217-42a5-ab71-19de2a0f887c', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-30', 'ABSENT', 'Regular Class Session', '2026-10-01 14:07:55.594383+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('fdc6db85-0f12-44db-91ee-090226f728fc', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '09c8b7bd-6217-42a5-ab71-19de2a0f887c', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-29', 'LATE', 'Regular Class Session', '2026-10-01 14:07:55.594383+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('44eccb35-6963-4dc9-adb6-f1a3eb5ab2fd', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '09c8b7bd-6217-42a5-ab71-19de2a0f887c', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-28', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594383+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('0723bdd3-2c52-46e6-909d-4b30d5d17892', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '09c8b7bd-6217-42a5-ab71-19de2a0f887c', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-30', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594384+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('30064679-0da9-4cff-8e07-5150a06ea907', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '09c8b7bd-6217-42a5-ab71-19de2a0f887c', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-29', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594384+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('99125dd6-cfd2-4ce9-846b-0671c78f0f61', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '09c8b7bd-6217-42a5-ab71-19de2a0f887c', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-28', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594384+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('ff766c73-9df2-41e7-b797-4e09dc30cbb0', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '8a408aa6-acc8-4897-96a9-219db1fa2552', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-30', 'ABSENT', 'Regular Class Session', '2026-10-01 14:07:55.594385+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('00faa838-39d6-402d-a7ad-2014593a6abd', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '8a408aa6-acc8-4897-96a9-219db1fa2552', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-29', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594385+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('236bdcb6-3878-4c32-ba16-2aa81972f627', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '8a408aa6-acc8-4897-96a9-219db1fa2552', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-28', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594385+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('8062a790-892d-4273-809c-e6fa9a13414f', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '8a408aa6-acc8-4897-96a9-219db1fa2552', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-30', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594386+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('c6635418-739e-4292-9896-0c919c0b6c9f', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '8a408aa6-acc8-4897-96a9-219db1fa2552', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-29', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594386+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('0861c5bc-9dc6-452b-b790-45ed0d7868ff', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '8a408aa6-acc8-4897-96a9-219db1fa2552', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-28', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594386+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('e049ece0-5aff-4796-a43d-ffc5b2d609f0', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'cd824327-8e9e-4e04-8d37-3de8f110cda1', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-30', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594387+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('0b4a97eb-106b-435f-82f8-5eab58893970', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'cd824327-8e9e-4e04-8d37-3de8f110cda1', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-29', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594387+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('ea203c91-64d7-4ebc-a114-33137a989f91', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'cd824327-8e9e-4e04-8d37-3de8f110cda1', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-28', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594387+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('fff9ad73-c60d-4c5e-a696-156806b4d8be', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'cd824327-8e9e-4e04-8d37-3de8f110cda1', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-30', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594388+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('43ec8605-9818-445d-8e80-528ea0ac785c', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'cd824327-8e9e-4e04-8d37-3de8f110cda1', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-29', 'ABSENT', 'Regular Class Session', '2026-10-01 14:07:55.594388+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('1937a1b2-7261-4d77-9eef-32b3ca51e6c2', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'cd824327-8e9e-4e04-8d37-3de8f110cda1', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-28', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594388+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('1cc4d83c-f2e4-44d6-ae98-f86c29227d8a', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'aeafaeb3-92d4-4889-9cab-23453afefb31', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-30', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594389+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('301a3299-d3be-4449-957d-1aa4f26b43d7', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'aeafaeb3-92d4-4889-9cab-23453afefb31', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-29', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594389+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('9368f0a9-d62f-4ac3-887a-dd4652dce93b', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'aeafaeb3-92d4-4889-9cab-23453afefb31', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-28', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594389+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('87c94591-ae38-4635-8de5-d3153089efb0', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'aeafaeb3-92d4-4889-9cab-23453afefb31', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-30', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.59439+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('f5ffd5a1-e6d8-4293-89f2-ea44411882e0', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'aeafaeb3-92d4-4889-9cab-23453afefb31', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-29', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.59439+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('e95ee363-dcf4-47e0-8340-b63826dc4b58', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'aeafaeb3-92d4-4889-9cab-23453afefb31', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-28', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.59439+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('cee1662a-c66c-47a3-a6d2-8b8c08e4dc99', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '4276399b-c86e-48fa-8165-70f0968bc730', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-30', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594391+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('424c1862-79eb-46f4-b43e-0f78244470da', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '4276399b-c86e-48fa-8165-70f0968bc730', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-29', 'ABSENT', 'Regular Class Session', '2026-10-01 14:07:55.594391+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('04ad9883-b0f5-4a5a-9d4c-ec18a042bf3e', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '4276399b-c86e-48fa-8165-70f0968bc730', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-28', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594391+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('16fb9677-dbf1-435a-b1c4-d1532ea575e1', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '4276399b-c86e-48fa-8165-70f0968bc730', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-30', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594392+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('546e4b8e-a34e-4254-8621-648fd4f53b86', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '4276399b-c86e-48fa-8165-70f0968bc730', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-29', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594392+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('fcbaf393-b27b-44ce-87a1-96f7ff81c814', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '4276399b-c86e-48fa-8165-70f0968bc730', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-28', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594392+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('9cd0b146-f208-4f66-ba93-7ead0ff38340', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '8754eeda-ec00-4dfc-a714-3f667eb1b492', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-30', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594393+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('2936f42c-cc91-4950-ab92-d702b4b71079', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '8754eeda-ec00-4dfc-a714-3f667eb1b492', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-29', 'ABSENT', 'Regular Class Session', '2026-10-01 14:07:55.594393+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('275057aa-41f5-4bce-93d2-bdb8521fc2ff', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '8754eeda-ec00-4dfc-a714-3f667eb1b492', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-28', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594393+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('38ea3ede-2385-4e19-9ed0-8afa800ef0fc', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '8754eeda-ec00-4dfc-a714-3f667eb1b492', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-30', 'LATE', 'Regular Class Session', '2026-10-01 14:07:55.594394+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('4a6c883b-cca5-497d-9b67-f464fa7235c4', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '8754eeda-ec00-4dfc-a714-3f667eb1b492', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-29', 'LATE', 'Regular Class Session', '2026-10-01 14:07:55.594394+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('2be9bf11-c0df-4b52-b5f8-1d5e5c605b6e', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '8754eeda-ec00-4dfc-a714-3f667eb1b492', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-28', 'ABSENT', 'Regular Class Session', '2026-10-01 14:07:55.594394+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('819cbd2d-aac6-4d61-8218-821604ca41fd', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '9851826b-3a5e-47ab-a7b6-6bda495e7d74', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-30', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594395+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('c14ff9b8-5e0e-484b-bb41-a4691343c347', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '9851826b-3a5e-47ab-a7b6-6bda495e7d74', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-29', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594395+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('1f67627a-903b-4943-9202-2b6b66322e15', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '9851826b-3a5e-47ab-a7b6-6bda495e7d74', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-28', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594395+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('02b92b90-af6d-464e-a605-51be469733de', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '9851826b-3a5e-47ab-a7b6-6bda495e7d74', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-30', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594396+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('50a424ba-1e87-4681-ad07-6647366fd972', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '9851826b-3a5e-47ab-a7b6-6bda495e7d74', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-29', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594396+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('0a5f8d95-8b32-4613-82c0-4e7c803f5f05', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '9851826b-3a5e-47ab-a7b6-6bda495e7d74', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-28', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594396+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('70667e04-8157-40d2-860f-26cf3cbd63f8', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'dc3ce680-65f9-4f03-a7da-e652279761c3', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-30', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594397+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('150e951f-4479-43d1-991d-646c2a7774f7', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'dc3ce680-65f9-4f03-a7da-e652279761c3', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-29', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594397+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('a9f7bb64-3103-462d-b2af-a44c422b80ca', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'dc3ce680-65f9-4f03-a7da-e652279761c3', '616d5366-a221-4453-9443-fdc767fb95fb', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '2026-09-28', 'LATE', 'Regular Class Session', '2026-10-01 14:07:55.594397+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('13330c6b-b77c-47a1-9a8b-9c3a549d374c', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'dc3ce680-65f9-4f03-a7da-e652279761c3', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-30', 'ABSENT', 'Regular Class Session', '2026-10-01 14:07:55.594398+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('dd967401-0024-4d51-8b36-c864fa214a2a', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'dc3ce680-65f9-4f03-a7da-e652279761c3', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-29', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594398+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('df1e5374-dc49-4906-b79f-e79ed8faa37f', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'dc3ce680-65f9-4f03-a7da-e652279761c3', '616d5366-a221-4453-9443-fdc767fb95fb', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '2026-09-28', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594398+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('014c5f2b-7e8c-4fa2-acb7-01a3bf88d78c', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '71aaa9bd-e82a-4900-a620-67ff94d964e4', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-30', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594399+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('2df62013-5bd1-4fbe-903e-d32ad6b3d646', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '71aaa9bd-e82a-4900-a620-67ff94d964e4', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-29', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594399+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('8806d448-2169-43c2-bb07-805a530bc2d4', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '71aaa9bd-e82a-4900-a620-67ff94d964e4', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-28', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594399+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('e4daa67d-166e-4888-9ad5-f323592f920b', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '71aaa9bd-e82a-4900-a620-67ff94d964e4', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-30', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594401+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('1c827933-5f67-4143-8a68-f21eef286803', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '71aaa9bd-e82a-4900-a620-67ff94d964e4', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-29', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594401+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('39e004e8-c6c2-4a9b-880d-4c34d54c5350', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '71aaa9bd-e82a-4900-a620-67ff94d964e4', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-28', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594402+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('2450035a-a85c-40c3-9254-11e0f9c5aa59', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'c64aa5ae-72f6-4039-882d-500a2910f82a', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-30', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594402+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('d107c71c-1152-4fa2-bef7-995fb5308a32', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'c64aa5ae-72f6-4039-882d-500a2910f82a', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-29', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594402+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('17489e36-6f1c-4ac4-aece-53980b3d28b8', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'c64aa5ae-72f6-4039-882d-500a2910f82a', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-28', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594403+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('57a3efe9-543a-4fbe-a11a-d8cbcbdadafb', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'c64aa5ae-72f6-4039-882d-500a2910f82a', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-30', 'ABSENT', 'Regular Class Session', '2026-10-01 14:07:55.594403+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('81180f1a-6073-48fe-842f-d7b8196231b1', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'c64aa5ae-72f6-4039-882d-500a2910f82a', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-29', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594403+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('e85835be-07e4-44e1-b511-d8f8f70fae74', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'c64aa5ae-72f6-4039-882d-500a2910f82a', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-28', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594404+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('69d119d4-41ab-4088-ac1c-8871ac00060b', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '87d56bfa-b1a5-4bba-bf20-2de8f4aaed2d', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-30', 'LATE', 'Regular Class Session', '2026-10-01 14:07:55.594404+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('81a1c148-96f9-42bb-90f1-978cc5471102', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '87d56bfa-b1a5-4bba-bf20-2de8f4aaed2d', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-29', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594404+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('e95fd64b-825b-4375-a053-fef1575189c8', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '87d56bfa-b1a5-4bba-bf20-2de8f4aaed2d', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-28', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594405+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('ed95b249-3821-4e8c-abe3-cb3699359972', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '87d56bfa-b1a5-4bba-bf20-2de8f4aaed2d', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-30', 'ABSENT', 'Regular Class Session', '2026-10-01 14:07:55.594405+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('01fedc1d-c9e7-4fab-a082-de02ef49c564', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '87d56bfa-b1a5-4bba-bf20-2de8f4aaed2d', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-29', 'LATE', 'Regular Class Session', '2026-10-01 14:07:55.594405+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('d9d75a8e-6993-4775-a9ff-6bb71ef56c8f', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '87d56bfa-b1a5-4bba-bf20-2de8f4aaed2d', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-28', 'ABSENT', 'Regular Class Session', '2026-10-01 14:07:55.594406+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('dd76fcfa-04af-4bcd-b5f8-b0cec2ef9f8b', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '074ca893-80f4-4ea5-8556-d2b9be73b57f', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-30', 'ABSENT', 'Regular Class Session', '2026-10-01 14:07:55.594406+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('08356670-5066-4af8-a8b6-9fff5a5128d5', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '074ca893-80f4-4ea5-8556-d2b9be73b57f', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-29', 'LATE', 'Regular Class Session', '2026-10-01 14:07:55.594406+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('91fa16c1-04bb-42fb-89e4-7fb7ee442c69', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '074ca893-80f4-4ea5-8556-d2b9be73b57f', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-28', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594407+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('2f608e74-d911-440d-aa0d-db5c4f4cfcfc', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '074ca893-80f4-4ea5-8556-d2b9be73b57f', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-30', 'LATE', 'Regular Class Session', '2026-10-01 14:07:55.594407+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('2380c287-da03-43d6-a83b-53fb63c98418', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '074ca893-80f4-4ea5-8556-d2b9be73b57f', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-29', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594407+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('7998b042-048f-4990-aff7-3d326fe5c419', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '074ca893-80f4-4ea5-8556-d2b9be73b57f', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-28', 'LATE', 'Regular Class Session', '2026-10-01 14:07:55.594408+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('d44bf461-b3fd-4358-8e74-344062ba4b71', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '9c4cc771-5fbf-4ed3-9d79-90bc19db71bd', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-30', 'ABSENT', 'Regular Class Session', '2026-10-01 14:07:55.594408+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('8a0f3683-1ed9-4001-9e4c-5eea4dccd3ff', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '9c4cc771-5fbf-4ed3-9d79-90bc19db71bd', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-29', 'LATE', 'Regular Class Session', '2026-10-01 14:07:55.594408+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('3bcc1360-9df1-4f50-8fcf-db4c7e36e721', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '9c4cc771-5fbf-4ed3-9d79-90bc19db71bd', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-28', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594409+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('c252edcc-362e-45c1-90bf-29e8012b6815', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '9c4cc771-5fbf-4ed3-9d79-90bc19db71bd', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-30', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594409+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('f6797733-bad9-401c-b4e3-d251fbb3e820', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '9c4cc771-5fbf-4ed3-9d79-90bc19db71bd', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-29', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594409+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('b405ff84-a963-41be-8206-68f2e6792581', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '9c4cc771-5fbf-4ed3-9d79-90bc19db71bd', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-28', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.59441+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('8a711409-0eb7-466c-974e-867d262f7b86', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '822f260b-d92f-4caf-b5f4-2c612e7ae673', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-30', 'ABSENT', 'Regular Class Session', '2026-10-01 14:07:55.59441+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('a4985ea0-0367-4b41-86e7-901e9138e15b', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '822f260b-d92f-4caf-b5f4-2c612e7ae673', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-29', 'LATE', 'Regular Class Session', '2026-10-01 14:07:55.59441+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('bfccf58c-b391-4e81-a7b4-471195b6c494', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '822f260b-d92f-4caf-b5f4-2c612e7ae673', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-28', 'ABSENT', 'Regular Class Session', '2026-10-01 14:07:55.594411+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('edf4b37d-eb15-4157-8bca-8a275a02a7f1', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '822f260b-d92f-4caf-b5f4-2c612e7ae673', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-30', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594411+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('72da2a8c-46e0-4c1b-8933-01e1dbb45f8d', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '822f260b-d92f-4caf-b5f4-2c612e7ae673', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-29', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594411+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('61d5ccfe-7952-40cb-92f9-e233b8461a68', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '822f260b-d92f-4caf-b5f4-2c612e7ae673', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-28', 'LATE', 'Regular Class Session', '2026-10-01 14:07:55.594412+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('af354a1f-4e00-4303-ad0c-257a6247f652', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '0ade34fc-97f5-4862-ae56-6955897e6e52', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-30', 'ABSENT', 'Regular Class Session', '2026-10-01 14:07:55.594412+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('2d202476-3212-4823-ac4b-5581eb29dd0c', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '0ade34fc-97f5-4862-ae56-6955897e6e52', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-29', 'ABSENT', 'Regular Class Session', '2026-10-01 14:07:55.594412+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('3f834031-a60b-4909-acd1-90fdc396ee24', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '0ade34fc-97f5-4862-ae56-6955897e6e52', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-28', 'LATE', 'Regular Class Session', '2026-10-01 14:07:55.594413+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('12be2053-e157-4220-a5ab-b136acc5afeb', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '0ade34fc-97f5-4862-ae56-6955897e6e52', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-30', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594413+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('5dc43980-b1a3-4d1e-a520-91bcd28bd17f', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '0ade34fc-97f5-4862-ae56-6955897e6e52', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-29', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594413+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('8cf9e3e3-2dbc-487f-bb6a-4ba10481c299', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '0ade34fc-97f5-4862-ae56-6955897e6e52', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-28', 'ABSENT', 'Regular Class Session', '2026-10-01 14:07:55.594414+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('e53f2266-1d76-4d85-9fff-634c809e6dfb', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'e3eb2c1a-0420-4d7e-84d5-483831168795', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-30', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594414+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('4e43f949-86bc-40c7-93c1-3607c2d3eb13', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'e3eb2c1a-0420-4d7e-84d5-483831168795', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-29', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594414+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('9fa6672b-8815-4e65-bff0-4f4d9ee70882', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'e3eb2c1a-0420-4d7e-84d5-483831168795', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-28', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594415+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('db1701f7-9bae-4c99-8a14-1d327554b416', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'e3eb2c1a-0420-4d7e-84d5-483831168795', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-30', 'ABSENT', 'Regular Class Session', '2026-10-01 14:07:55.594415+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('0c80201f-b76f-4dd0-8bd4-37068bfe05d6', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'e3eb2c1a-0420-4d7e-84d5-483831168795', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-29', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594415+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('514f34b1-0d99-4da0-af27-4812ac1ffb87', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'e3eb2c1a-0420-4d7e-84d5-483831168795', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-28', 'ABSENT', 'Regular Class Session', '2026-10-01 14:07:55.594416+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('22873733-8df9-449a-89dd-20901b270f25', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '3f360886-48d8-4ae6-8198-2eda870872a0', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-30', 'ABSENT', 'Regular Class Session', '2026-10-01 14:07:55.594416+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('0f566d21-2432-484b-81f1-24afac46cdb3', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '3f360886-48d8-4ae6-8198-2eda870872a0', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-29', 'ABSENT', 'Regular Class Session', '2026-10-01 14:07:55.594416+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('e0bb74d8-9fbe-41be-99b6-8b56aa43edb9', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '3f360886-48d8-4ae6-8198-2eda870872a0', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-28', 'ABSENT', 'Regular Class Session', '2026-10-01 14:07:55.594417+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('a5c9a88c-b96e-4c2c-93ce-f91dd9052f80', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '3f360886-48d8-4ae6-8198-2eda870872a0', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-30', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594417+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('4b4284be-364d-49c0-aa98-02888fb150e8', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '3f360886-48d8-4ae6-8198-2eda870872a0', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-29', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594417+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('68a23d9f-5652-4fdd-9b35-8c7a98d62326', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '3f360886-48d8-4ae6-8198-2eda870872a0', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-28', 'ABSENT', 'Regular Class Session', '2026-10-01 14:07:55.594417+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('c67612e8-4948-44e2-b496-ac1bd89531ed', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'db150926-30fe-438c-ad52-bae56bf264a4', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-30', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594418+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('984aa7fc-50db-43ed-b598-e4e1575c77ef', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'db150926-30fe-438c-ad52-bae56bf264a4', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-29', 'ABSENT', 'Regular Class Session', '2026-10-01 14:07:55.594418+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('2faede5d-95e2-463d-ba8b-b53ec2e9c81c', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'db150926-30fe-438c-ad52-bae56bf264a4', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-28', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594418+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('050d7a58-6d64-4909-8ef5-e0a3b29a3abc', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'db150926-30fe-438c-ad52-bae56bf264a4', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-30', 'LATE', 'Regular Class Session', '2026-10-01 14:07:55.594419+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('428171ae-6034-4359-99b0-0e59aa46fe38', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'db150926-30fe-438c-ad52-bae56bf264a4', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-29', 'LATE', 'Regular Class Session', '2026-10-01 14:07:55.594419+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('c42f7fb5-b7e4-4643-aada-840dd7eb0711', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'db150926-30fe-438c-ad52-bae56bf264a4', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-28', 'LATE', 'Regular Class Session', '2026-10-01 14:07:55.594419+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('b1621486-70d2-4507-b836-8f67352bd1c4', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '98d26b99-1717-4c95-839d-0925c0d5b707', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-30', 'LATE', 'Regular Class Session', '2026-10-01 14:07:55.59442+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('2eceaf4b-5b3c-4870-a3e5-9f4e29369323', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '98d26b99-1717-4c95-839d-0925c0d5b707', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-29', 'LATE', 'Regular Class Session', '2026-10-01 14:07:55.59442+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('826571b1-3c39-489b-a84f-c5a7159b69f9', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '98d26b99-1717-4c95-839d-0925c0d5b707', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-28', 'LATE', 'Regular Class Session', '2026-10-01 14:07:55.59442+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('40e5dde8-f5a4-4619-9272-4298f4126de4', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '98d26b99-1717-4c95-839d-0925c0d5b707', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-30', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594421+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('cb05c12b-bd19-452a-a687-e0dae42c5685', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '98d26b99-1717-4c95-839d-0925c0d5b707', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-29', 'ABSENT', 'Regular Class Session', '2026-10-01 14:07:55.594421+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('91044838-5d8f-4923-b0c8-86fd14f75726', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '98d26b99-1717-4c95-839d-0925c0d5b707', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-28', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594421+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('cfda5f3b-363c-43e3-95ab-9dff08278ede', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'afd5a403-53e9-4742-a84c-931bd047a5a6', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-30', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594422+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('75839576-1a91-495c-96b8-4d74850badc8', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'afd5a403-53e9-4742-a84c-931bd047a5a6', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-29', 'LATE', 'Regular Class Session', '2026-10-01 14:07:55.594422+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('123efdf8-c768-4730-9195-d19d0eccdbcd', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'afd5a403-53e9-4742-a84c-931bd047a5a6', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-28', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594422+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('fd5a0be0-c022-40a4-97b1-af3bdc8aa84a', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'afd5a403-53e9-4742-a84c-931bd047a5a6', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-30', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594423+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('19784da6-5bbb-4b91-a0ae-4c8c04d98107', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'afd5a403-53e9-4742-a84c-931bd047a5a6', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-29', 'ABSENT', 'Regular Class Session', '2026-10-01 14:07:55.594423+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('4a14846d-b812-4c3c-b983-896222100843', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'afd5a403-53e9-4742-a84c-931bd047a5a6', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-28', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594423+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('facd9057-bba1-46e4-9849-ca9384ef5fb3', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '937c027a-cff8-4739-af56-462c021e612f', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-30', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594424+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('6b4e2d96-99d1-4219-bd66-46deebbf5d9a', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '937c027a-cff8-4739-af56-462c021e612f', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-29', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594424+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('316d6bc1-d131-4231-aec0-15bd9c1286bb', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '937c027a-cff8-4739-af56-462c021e612f', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-28', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594424+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('e6b82aee-c10f-4682-a124-511d6bba37b6', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '937c027a-cff8-4739-af56-462c021e612f', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-30', 'ABSENT', 'Regular Class Session', '2026-10-01 14:07:55.594425+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('99dad5c2-b143-49eb-8290-3ee092a08c14', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '937c027a-cff8-4739-af56-462c021e612f', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-29', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594425+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('89a16306-92ed-44d7-b954-0acea87edd15', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '937c027a-cff8-4739-af56-462c021e612f', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-28', 'ABSENT', 'Regular Class Session', '2026-10-01 14:07:55.594425+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('430f1718-d104-4de4-b945-adc2da11fec5', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '3242e419-6976-4b15-9cfb-088e13b3ddfe', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-30', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594426+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('001f0195-52a0-4054-9678-cef18cef8236', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '3242e419-6976-4b15-9cfb-088e13b3ddfe', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-29', 'ABSENT', 'Regular Class Session', '2026-10-01 14:07:55.594426+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('f176d28c-d3af-4488-89a6-645d16e6c0f5', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '3242e419-6976-4b15-9cfb-088e13b3ddfe', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-28', 'LATE', 'Regular Class Session', '2026-10-01 14:07:55.594426+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('1610c991-8939-4ffe-86a0-b6e169fc9e37', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '3242e419-6976-4b15-9cfb-088e13b3ddfe', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-30', 'ABSENT', 'Regular Class Session', '2026-10-01 14:07:55.594427+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('0dfc73ab-97e9-4def-ad49-d35336a151c3', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '3242e419-6976-4b15-9cfb-088e13b3ddfe', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-29', 'ABSENT', 'Regular Class Session', '2026-10-01 14:07:55.594427+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('d408f51d-4b52-46fb-a10e-e2f70e5b965f', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '3242e419-6976-4b15-9cfb-088e13b3ddfe', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-28', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594427+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('f8a7953f-c0a8-403c-a882-c14adde19198', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'b123200c-4226-4092-9fea-a2c9ad5d3d5b', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-30', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594428+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('278fe881-8983-4c23-9a7a-1fc92cb03c1d', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'b123200c-4226-4092-9fea-a2c9ad5d3d5b', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-29', 'LATE', 'Regular Class Session', '2026-10-01 14:07:55.594428+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('db45a912-4520-4297-a50b-58b98f10398d', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'b123200c-4226-4092-9fea-a2c9ad5d3d5b', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-28', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594428+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('4629a29e-1a69-48a9-b803-d9d91a77f72e', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'b123200c-4226-4092-9fea-a2c9ad5d3d5b', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-30', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594429+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('a04512d5-2fb5-405a-a4da-86fff099a729', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'b123200c-4226-4092-9fea-a2c9ad5d3d5b', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-29', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594429+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('653eb7a9-ff5d-4096-a8f0-e30cb7354203', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'b123200c-4226-4092-9fea-a2c9ad5d3d5b', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-28', 'LATE', 'Regular Class Session', '2026-10-01 14:07:55.59443+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('0c3941c9-654a-41eb-b93f-6e20065bb570', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'db794458-90cc-4c01-b8de-9e6e5eb71af1', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-30', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594431+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('b0633ecc-db2f-447d-9405-e16fb90f173d', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'db794458-90cc-4c01-b8de-9e6e5eb71af1', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-29', 'ABSENT', 'Regular Class Session', '2026-10-01 14:07:55.594431+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('2f50447b-358a-485c-b08a-2887d4457a2c', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'db794458-90cc-4c01-b8de-9e6e5eb71af1', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-28', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594431+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('6a9c4316-75f6-423c-a89f-3b38d98d716e', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'db794458-90cc-4c01-b8de-9e6e5eb71af1', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-30', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594432+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('0b90ecd9-0ef2-43cf-bc49-0abb062a9d27', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'db794458-90cc-4c01-b8de-9e6e5eb71af1', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-29', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594432+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('878d6a22-5413-46e9-8ad4-fe65d1cef6ea', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'db794458-90cc-4c01-b8de-9e6e5eb71af1', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-28', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594432+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('ae35c5c5-4336-4600-993c-4964fccf8994', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '2d65c079-20d2-4f92-8c9d-93175fffda44', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-30', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594433+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('7052dc68-ff00-4083-aa29-363b94c4a577', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '2d65c079-20d2-4f92-8c9d-93175fffda44', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-29', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594433+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('c3dfe829-4447-4d6a-a600-43efdaaf0271', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '2d65c079-20d2-4f92-8c9d-93175fffda44', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-28', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594433+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('f5360e5b-8e30-4c43-9700-32b971492176', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '2d65c079-20d2-4f92-8c9d-93175fffda44', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-30', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594434+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('af372e2c-82b5-46fd-b59d-60e9ff487ee5', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '2d65c079-20d2-4f92-8c9d-93175fffda44', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-29', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594434+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('9b74133b-7b52-4b61-8565-a4ba3f142d2f', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '2d65c079-20d2-4f92-8c9d-93175fffda44', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-28', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594434+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('807d9e09-c67c-45c8-b7e5-3ad3f1f99265', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '62f68269-f2ce-478c-8eaa-7e3271ec8492', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-30', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594435+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('82634768-95d9-4057-94ba-e8c227a2bc74', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '62f68269-f2ce-478c-8eaa-7e3271ec8492', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-29', 'LATE', 'Regular Class Session', '2026-10-01 14:07:55.594435+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('efdc9456-9fb3-41b6-b3af-174fe12bb6e8', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '62f68269-f2ce-478c-8eaa-7e3271ec8492', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-28', 'LATE', 'Regular Class Session', '2026-10-01 14:07:55.594435+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('e1a8b3ea-49e8-4dbf-a370-9324352b695a', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '62f68269-f2ce-478c-8eaa-7e3271ec8492', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-30', 'ABSENT', 'Regular Class Session', '2026-10-01 14:07:55.594436+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('f704aa19-4917-4913-b7a4-39faafc5b67d', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '62f68269-f2ce-478c-8eaa-7e3271ec8492', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-29', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594436+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('2bd991b9-6e1f-4048-8aa8-6a409ed9006b', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '62f68269-f2ce-478c-8eaa-7e3271ec8492', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-28', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594436+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('bc5a940f-5a7b-4380-a59b-cb19f8281455', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '9df10543-26a7-4877-a1bc-ddb48e8792a5', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-30', 'LATE', 'Regular Class Session', '2026-10-01 14:07:55.594437+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('0b3b40e3-f898-49c0-a9be-b97c142f485f', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '9df10543-26a7-4877-a1bc-ddb48e8792a5', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-29', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594437+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('3a8b0d15-e7c0-4652-a73e-335cac787c83', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '9df10543-26a7-4877-a1bc-ddb48e8792a5', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-28', 'LATE', 'Regular Class Session', '2026-10-01 14:07:55.594437+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('98ceddb1-7979-4f82-be10-40876baaa587', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '9df10543-26a7-4877-a1bc-ddb48e8792a5', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-30', 'LATE', 'Regular Class Session', '2026-10-01 14:07:55.594438+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('88792a17-0465-4e07-8838-bd5f327f9d33', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '9df10543-26a7-4877-a1bc-ddb48e8792a5', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-29', 'LATE', 'Regular Class Session', '2026-10-01 14:07:55.594438+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('2217132a-7218-41a8-8d19-149887744d49', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '9df10543-26a7-4877-a1bc-ddb48e8792a5', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-28', 'ABSENT', 'Regular Class Session', '2026-10-01 14:07:55.594438+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('b1038fb7-6c39-4767-a3c7-3e7e6f8273a1', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '1aad71cc-7350-40c4-8e73-a71b0cca63b0', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-30', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594439+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('d0169a63-a8ef-409f-9b5b-5d76b0083e91', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '1aad71cc-7350-40c4-8e73-a71b0cca63b0', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-29', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594439+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('8b2b0662-4ef1-404e-a177-a31fa07b221f', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '1aad71cc-7350-40c4-8e73-a71b0cca63b0', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-28', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594439+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('e1e278a1-7e21-42bf-b8a9-9d575a406f2b', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '1aad71cc-7350-40c4-8e73-a71b0cca63b0', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-30', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.59444+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('8900f578-c23f-450d-9419-7dcabcadf049', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '1aad71cc-7350-40c4-8e73-a71b0cca63b0', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-29', 'LATE', 'Regular Class Session', '2026-10-01 14:07:55.59444+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('4651c86f-b467-4b8f-ab99-d84742c08bd0', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '1aad71cc-7350-40c4-8e73-a71b0cca63b0', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-28', 'ABSENT', 'Regular Class Session', '2026-10-01 14:07:55.59444+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('ca91411b-3534-4503-8e60-adc3691dfac0', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'c71667dd-879d-4fef-b0cd-79d29591b0fd', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-30', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594441+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('f18de763-6f59-4ca9-947e-c0f38837e5a5', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'c71667dd-879d-4fef-b0cd-79d29591b0fd', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-29', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594441+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('4d14d196-0da9-42b6-9448-ff62a4c98133', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'c71667dd-879d-4fef-b0cd-79d29591b0fd', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-28', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594441+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('0b5cebd9-cb6c-4ff1-b0cb-7fbe1bad169a', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'c71667dd-879d-4fef-b0cd-79d29591b0fd', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-30', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594442+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('0e13ba7b-5698-465a-a8a5-91818a837478', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'c71667dd-879d-4fef-b0cd-79d29591b0fd', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-29', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594442+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('e2184eef-5a3b-4543-b7e1-6d6fabd39ee6', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'c71667dd-879d-4fef-b0cd-79d29591b0fd', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-28', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594442+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('40bba8cc-9a64-4d5e-983a-684ca5bc0fab', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '8d6c7b94-6c9b-4feb-9325-d0041a7ed3af', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-30', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594443+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('9322e7ef-40e2-47bb-b3d9-17cae2b737d2', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '8d6c7b94-6c9b-4feb-9325-d0041a7ed3af', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-29', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594443+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('2d55fad8-aa04-445d-9976-f0b9f2ad40db', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '8d6c7b94-6c9b-4feb-9325-d0041a7ed3af', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-28', 'ABSENT', 'Regular Class Session', '2026-10-01 14:07:55.594443+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('358d5d6c-04b9-4a29-ac8f-45c58930880a', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '8d6c7b94-6c9b-4feb-9325-d0041a7ed3af', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-30', 'LATE', 'Regular Class Session', '2026-10-01 14:07:55.594444+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('f1eba857-b4c4-4388-8453-35ace239b234', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '8d6c7b94-6c9b-4feb-9325-d0041a7ed3af', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-29', 'ABSENT', 'Regular Class Session', '2026-10-01 14:07:55.594444+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('345ec6c5-ab40-4c62-b00b-dfcf09c1c834', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '8d6c7b94-6c9b-4feb-9325-d0041a7ed3af', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-28', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594444+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('3efab1ee-bcd4-49e5-b9b7-e6ccee17f38d', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '99bcb5e7-1a64-469e-b3d0-e1c732109f0a', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-30', 'ABSENT', 'Regular Class Session', '2026-10-01 14:07:55.594445+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('c82d54f5-cac6-4b45-a4f7-be0ded2f9f11', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '99bcb5e7-1a64-469e-b3d0-e1c732109f0a', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-29', 'ABSENT', 'Regular Class Session', '2026-10-01 14:07:55.594445+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('07ef08dd-fa50-41a1-ac3b-5939d62a9dd6', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '99bcb5e7-1a64-469e-b3d0-e1c732109f0a', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-28', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594445+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('e979e1d0-b72c-49d5-9de7-4660c0301e54', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '99bcb5e7-1a64-469e-b3d0-e1c732109f0a', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-30', 'LATE', 'Regular Class Session', '2026-10-01 14:07:55.594446+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('d2f7130d-dd28-4c93-bcfb-1a621ea59243', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '99bcb5e7-1a64-469e-b3d0-e1c732109f0a', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-29', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594446+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('0b9a835c-8d86-44c8-b889-af4fba59780d', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '99bcb5e7-1a64-469e-b3d0-e1c732109f0a', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-28', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594446+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('4485a2d4-10d0-407b-b8d2-bf3d19bdaec0', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '8f574cd6-62ea-4dd4-8165-d3c411b220b8', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-30', 'ABSENT', 'Regular Class Session', '2026-10-01 14:07:55.594447+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('470186ae-1794-4e97-8afd-8f9d1d134b2b', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '8f574cd6-62ea-4dd4-8165-d3c411b220b8', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-29', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594447+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('da21223c-fa19-4cc3-8c9c-99181c0ce20e', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '8f574cd6-62ea-4dd4-8165-d3c411b220b8', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-28', 'LATE', 'Regular Class Session', '2026-10-01 14:07:55.594447+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('fca87923-e91b-4eaf-b5c2-4f78045c636a', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '8f574cd6-62ea-4dd4-8165-d3c411b220b8', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-30', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594448+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('61ab19be-2150-42bb-9200-272db194da19', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '8f574cd6-62ea-4dd4-8165-d3c411b220b8', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-29', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594448+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('a0e333d4-22ca-4c1b-a1d1-55d89ac58dce', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '8f574cd6-62ea-4dd4-8165-d3c411b220b8', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-28', 'ABSENT', 'Regular Class Session', '2026-10-01 14:07:55.594448+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('5cee2252-5e65-4d70-89e1-978395806c60', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '1aac8640-517f-4334-9ffa-4dfa85cca0dd', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-30', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.594449+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('db011616-b797-458d-a1ec-21bce4c1f8ea', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '1aac8640-517f-4334-9ffa-4dfa85cca0dd', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-29', 'ABSENT', 'Regular Class Session', '2026-10-01 14:07:55.594449+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('e0f17116-05e3-4212-8081-fe4e6872aa59', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '1aac8640-517f-4334-9ffa-4dfa85cca0dd', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2026-09-28', 'LATE', 'Regular Class Session', '2026-10-01 14:07:55.594449+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('a4ab6bf8-307f-4ecb-8266-19ece2642d09', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '1aac8640-517f-4334-9ffa-4dfa85cca0dd', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-30', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.59445+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('7f1f152c-f450-431c-81f8-36529c0dcc0a', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '1aac8640-517f-4334-9ffa-4dfa85cca0dd', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-29', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.59445+00');
INSERT INTO public.attendance (attendance_id, college_id, student_id, faculty_id, course_id, date_recorded, status, remarks, created_at) VALUES ('8badd2f8-453c-4597-9d69-28caa75697f9', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '1aac8640-517f-4334-9ffa-4dfa85cca0dd', '535ee669-c190-4ff6-bd43-2d93d325feb3', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2026-09-28', 'PRESENT', 'Regular Class Session', '2026-10-01 14:07:55.59445+00');


--
-- Data for Name: colleges; Type: TABLE DATA; Schema: public; Owner: edunexa_admin
--

INSERT INTO public.colleges (college_id, name, domain, code, is_active, created_at, updated_at) VALUES ('4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'Apex Institute of Technology', 'apex.edunexa.edu', 'APEX', true, '2026-10-01 14:07:55.41281+00', '2026-10-01 14:07:55.412814+00');
INSERT INTO public.colleges (college_id, name, domain, code, is_active, created_at, updated_at) VALUES ('f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'Horizon University', 'horizon.edunexa.edu', 'HORIZON', true, '2026-10-01 14:07:55.412815+00', '2026-10-01 14:07:55.412816+00');


--
-- Data for Name: course_enrollments; Type: TABLE DATA; Schema: public; Owner: edunexa_admin
--

INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('e8a728ac-4c37-45a1-a7fc-2059dfcd48e7', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', 'd91be8a0-c589-4080-a507-14f8dfdd23b2', '2026-08-11 14:07:55.520829+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('fa66d59c-c6c5-41be-96e1-66e855904ff9', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', 'd91be8a0-c589-4080-a507-14f8dfdd23b2', '2026-08-07 14:07:55.520892+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('2efdff8e-7a9c-4ed2-b6a5-0ebec3c476fe', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '2353386e-f081-41a6-9acb-36523f07448a', 'd91be8a0-c589-4080-a507-14f8dfdd23b2', '2026-09-04 14:07:55.520917+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('2f3f1545-253f-46bf-945c-d236c5322bcd', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '66978ac8-b94a-472f-98c7-012edb67c91b', '2026-08-05 14:07:55.520945+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('8c9d9591-f2c9-40a7-b462-e516fb39c44a', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '66978ac8-b94a-472f-98c7-012edb67c91b', '2026-08-04 14:07:55.520963+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('6e9854c3-ef95-40ad-aa12-63f09a729d93', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '3cbb2009-12af-42cc-a809-d3f4e9cf6fa8', '66978ac8-b94a-472f-98c7-012edb67c91b', '2026-09-20 14:07:55.520979+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('73340dcb-5af8-4448-ad3f-75aa62aa757c', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', 'd24111ba-f892-4a39-a392-85e81eb9132c', '2026-09-05 14:07:55.520998+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('1fd73321-ea87-4678-a676-119f369ff990', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', 'd24111ba-f892-4a39-a392-85e81eb9132c', '2026-08-07 14:07:55.521013+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('e60835e6-e20c-4d5a-ac2f-3b8b77109a4e', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '9a5913dd-4485-420e-80a9-7ebaa12a550c', 'd24111ba-f892-4a39-a392-85e81eb9132c', '2026-08-22 14:07:55.521028+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('a5984992-eaa1-4f11-9986-e976c8635a86', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', 'b53d8f73-83df-4762-b522-a445d9933f63', '2026-09-17 14:07:55.521045+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('c50d788d-0932-4787-9695-44ee54406746', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', 'b53d8f73-83df-4762-b522-a445d9933f63', '2026-08-04 14:07:55.521059+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('4f837529-80b9-429d-ab9b-e3869d218a92', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'ce1e25f8-aa32-4583-9e7e-25f94a894ca2', 'b53d8f73-83df-4762-b522-a445d9933f63', '2026-09-14 14:07:55.521075+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('abbdcbf8-00e6-4323-9bdc-c3be9860def8', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', 'b278f61a-13eb-41c1-99d5-2110b3a1bcc5', '2026-08-30 14:07:55.521092+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('9d49979d-f7ee-4e44-a22d-6ebbb2db1d60', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', 'b278f61a-13eb-41c1-99d5-2110b3a1bcc5', '2026-08-03 14:07:55.521107+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('a7c390ba-eb03-4cd6-b1f6-b65aeeccff71', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '4c6bc0c4-345d-423e-952f-fbd00e9abe3d', '2026-08-09 14:07:55.521124+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('e83fb5c0-3b61-46e1-ad0b-f743b6b44871', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '4c6bc0c4-345d-423e-952f-fbd00e9abe3d', '2026-08-28 14:07:55.521139+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('55e8b3d7-f3a1-4955-af79-1f85397d2448', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '2353386e-f081-41a6-9acb-36523f07448a', '4c6bc0c4-345d-423e-952f-fbd00e9abe3d', '2026-08-05 14:07:55.521152+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('902f12b3-895b-4598-84fa-de77bd759d29', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', 'a7a87c91-31e1-4c95-9071-39b742346013', '2026-08-19 14:07:55.521172+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('5928a79c-968a-4473-a2ca-4442638e61b0', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', 'a7a87c91-31e1-4c95-9071-39b742346013', '2026-09-09 14:07:55.521186+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('cb6d3b1b-d37e-4f9c-b05a-931420f5f011', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '3cbb2009-12af-42cc-a809-d3f4e9cf6fa8', 'a7a87c91-31e1-4c95-9071-39b742346013', '2026-08-14 14:07:55.5212+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('d6cd7ab1-95e8-49fc-ba2f-1f79c89b4719', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '535e3192-51ae-4e6e-90cf-473b1f0db55c', '2026-09-10 14:07:55.521219+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('152dd846-fd53-46c7-992e-109d6266acf8', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '535e3192-51ae-4e6e-90cf-473b1f0db55c', '2026-08-27 14:07:55.521234+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('43192474-4f23-44ba-b748-a6bd6d9f7bc0', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '9a5913dd-4485-420e-80a9-7ebaa12a550c', '535e3192-51ae-4e6e-90cf-473b1f0db55c', '2026-09-10 14:07:55.521252+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('b683c457-1162-47e4-a16e-38da4a5cd89c', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '169a3258-9e01-4b90-ace8-66be170c035f', '2026-08-11 14:07:55.521269+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('6c64fc2a-dd31-4046-9f84-479f6896af49', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '169a3258-9e01-4b90-ace8-66be170c035f', '2026-08-10 14:07:55.521284+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('99dab8a1-c3d5-417b-8960-a2dc7cb36fdd', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'ce1e25f8-aa32-4583-9e7e-25f94a894ca2', '169a3258-9e01-4b90-ace8-66be170c035f', '2026-09-05 14:07:55.521298+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('78499f26-6dc9-4164-927e-c42365a81bb6', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', 'a13e1758-df90-4ef6-b7b7-664b5c273eca', '2026-09-10 14:07:55.521316+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('5c64e751-9909-4ca8-9477-82d96e6893e0', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', 'a13e1758-df90-4ef6-b7b7-664b5c273eca', '2026-09-15 14:07:55.52133+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('f4c57218-8c52-4c4e-959e-c508fecec3a9', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '4cf325fa-5154-4620-a4fc-049776c9e6b6', '2026-08-26 14:07:55.521348+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('c724b39b-d67c-4534-8e7f-922a580d8a94', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '4cf325fa-5154-4620-a4fc-049776c9e6b6', '2026-08-27 14:07:55.521362+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('3913469c-338a-4f3d-9ac6-9cd87cf1d5a3', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '2353386e-f081-41a6-9acb-36523f07448a', '4cf325fa-5154-4620-a4fc-049776c9e6b6', '2026-09-12 14:07:55.521376+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('48cfd4f3-6955-4138-ad48-446aef89297f', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '03ac1155-58c5-4b44-b605-4ccaf8d6a02d', '2026-08-30 14:07:55.521393+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('6be438d3-bbda-44a1-bc00-d2cbe8c05ef6', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '03ac1155-58c5-4b44-b605-4ccaf8d6a02d', '2026-08-11 14:07:55.521406+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('5282d312-6709-4b91-b6f4-7fd613f00689', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '3cbb2009-12af-42cc-a809-d3f4e9cf6fa8', '03ac1155-58c5-4b44-b605-4ccaf8d6a02d', '2026-09-07 14:07:55.52142+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('bf06c447-48dd-4ec6-9d4e-7835ed0b9774', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', 'fdeb06a3-74da-4120-bc71-653085b7aea0', '2026-09-16 14:07:55.521441+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('c2d8010a-3deb-4417-9487-8217ee8370f5', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', 'fdeb06a3-74da-4120-bc71-653085b7aea0', '2026-08-09 14:07:55.521454+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('91d590c4-3c7d-4ca7-85cb-1f3b8ace9d5f', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '9a5913dd-4485-420e-80a9-7ebaa12a550c', 'fdeb06a3-74da-4120-bc71-653085b7aea0', '2026-09-14 14:07:55.521469+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('d41f71fd-1545-4768-9f4c-a2ba81a4fd30', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', 'fc0f5eed-999f-4329-8368-17737a95e148', '2026-08-27 14:07:55.521485+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('9e286ef1-81d2-4da1-ac5e-6a4605135b31', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', 'fc0f5eed-999f-4329-8368-17737a95e148', '2026-08-11 14:07:55.521499+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('e6df9158-3464-4fcc-91be-ea75f57df3af', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'ce1e25f8-aa32-4583-9e7e-25f94a894ca2', 'fc0f5eed-999f-4329-8368-17737a95e148', '2026-08-07 14:07:55.521513+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('91f4f85f-3d96-4175-bfb3-cce254efe637', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '44da7ddf-963f-4685-8d4b-f09eb6900c65', '2026-08-23 14:07:55.521528+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('cce420b9-3b76-4af9-a539-d4388eafeb75', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '44da7ddf-963f-4685-8d4b-f09eb6900c65', '2026-08-21 14:07:55.521544+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('c2df08b6-c652-4281-abcf-542675bf3cd4', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '487eef9d-7e83-44ff-ba05-5633563d482c', '2026-08-03 14:07:55.52156+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('5f4335a0-7049-480b-9659-7393b8636615', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '487eef9d-7e83-44ff-ba05-5633563d482c', '2026-09-16 14:07:55.521575+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('c4bfe8b7-0a6a-4924-827a-310104dc6601', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '2353386e-f081-41a6-9acb-36523f07448a', '487eef9d-7e83-44ff-ba05-5633563d482c', '2026-09-20 14:07:55.521588+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('7c3b369b-017e-459a-ab78-9d315cc3d2ba', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '3c246328-8187-4c8f-8785-1fbc652f0b34', '2026-08-09 14:07:55.521604+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('03e9aeec-a4fd-4cc3-a36b-52c6a588c569', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '3c246328-8187-4c8f-8785-1fbc652f0b34', '2026-09-10 14:07:55.521619+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('8327a9a8-4952-4876-a668-67dd86aa57e1', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '3cbb2009-12af-42cc-a809-d3f4e9cf6fa8', '3c246328-8187-4c8f-8785-1fbc652f0b34', '2026-09-19 14:07:55.521633+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('1a0631dd-6436-468f-832b-4fb5fb08407b', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '09c8b7bd-6217-42a5-ab71-19de2a0f887c', '2026-09-07 14:07:55.52165+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('5b56c07e-349e-4b67-8b14-132f6ea29ce7', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '09c8b7bd-6217-42a5-ab71-19de2a0f887c', '2026-08-27 14:07:55.521665+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('7981c612-3269-4a2d-abf1-d3a028ec3a68', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '9a5913dd-4485-420e-80a9-7ebaa12a550c', '09c8b7bd-6217-42a5-ab71-19de2a0f887c', '2026-08-10 14:07:55.521678+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('9367646a-dd85-49b9-bcb4-6f021e27af8c', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '8a408aa6-acc8-4897-96a9-219db1fa2552', '2026-09-08 14:07:55.521694+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('c5f42a41-7b7a-45d2-8f59-9f7c5f45114f', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '8a408aa6-acc8-4897-96a9-219db1fa2552', '2026-08-13 14:07:55.521707+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('a3d1234f-58b1-4b18-9ea7-792e0e14a938', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'ce1e25f8-aa32-4583-9e7e-25f94a894ca2', '8a408aa6-acc8-4897-96a9-219db1fa2552', '2026-09-15 14:07:55.521721+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('6393be27-3951-4248-93bc-d9eb311905b6', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', 'cd824327-8e9e-4e04-8d37-3de8f110cda1', '2026-08-09 14:07:55.521737+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('a4766496-c3a5-4f79-bf60-4218baa1272c', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', 'cd824327-8e9e-4e04-8d37-3de8f110cda1', '2026-08-17 14:07:55.521751+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('85e6a844-4e85-4746-b937-3fcd941d4a18', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', 'aeafaeb3-92d4-4889-9cab-23453afefb31', '2026-09-17 14:07:55.521769+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('ba192f6e-c2d6-4324-9bd1-3dfb43c89862', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', 'aeafaeb3-92d4-4889-9cab-23453afefb31', '2026-09-10 14:07:55.521784+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('b7ad125e-c5a8-4bb4-90ad-ea0e1a9433b3', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '2353386e-f081-41a6-9acb-36523f07448a', 'aeafaeb3-92d4-4889-9cab-23453afefb31', '2026-09-04 14:07:55.521798+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('bff78432-0ae3-4035-aaab-93f54fb5da90', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '4276399b-c86e-48fa-8165-70f0968bc730', '2026-09-21 14:07:55.521814+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('cd30dde7-8713-45cb-91f4-e3edfe27cdbe', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '4276399b-c86e-48fa-8165-70f0968bc730', '2026-09-18 14:07:55.521827+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('b6092fc1-5239-4714-9962-0fe0d83f3fb1', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '3cbb2009-12af-42cc-a809-d3f4e9cf6fa8', '4276399b-c86e-48fa-8165-70f0968bc730', '2026-09-06 14:07:55.521841+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('6b1188d0-0b6f-40e9-84a0-8abbfe567d45', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '8754eeda-ec00-4dfc-a714-3f667eb1b492', '2026-08-19 14:07:55.521858+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('8ab4e54b-de7b-4428-a043-fef3e3efc9e2', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '8754eeda-ec00-4dfc-a714-3f667eb1b492', '2026-08-05 14:07:55.521873+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('834e3549-6169-4d9f-8997-23500b9e9ae1', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '9a5913dd-4485-420e-80a9-7ebaa12a550c', '8754eeda-ec00-4dfc-a714-3f667eb1b492', '2026-08-28 14:07:55.521888+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('aca714dd-b30e-4594-aa82-cb43474359fb', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '9851826b-3a5e-47ab-a7b6-6bda495e7d74', '2026-09-08 14:07:55.521903+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('f43299f1-b4e8-4c2e-8464-6b3a78ba1576', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '9851826b-3a5e-47ab-a7b6-6bda495e7d74', '2026-09-01 14:07:55.521918+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('d5135b44-fc11-4863-b15d-eed5e1d3f75c', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'ce1e25f8-aa32-4583-9e7e-25f94a894ca2', '9851826b-3a5e-47ab-a7b6-6bda495e7d74', '2026-08-14 14:07:55.521931+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('db9be40d-c6ad-41ad-93ba-dd4ff57f53c5', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', 'dc3ce680-65f9-4f03-a7da-e652279761c3', '2026-08-11 14:07:55.521947+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('ce891709-9d60-44e7-b80d-aa4413fb85cb', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', 'dc3ce680-65f9-4f03-a7da-e652279761c3', '2026-08-25 14:07:55.521962+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('31db6700-bf0c-41a9-ba66-0d778ef74225', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '71aaa9bd-e82a-4900-a620-67ff94d964e4', '2026-08-21 14:07:55.52198+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('57cf3525-b934-47f6-8f0a-6b859fc384be', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '71aaa9bd-e82a-4900-a620-67ff94d964e4', '2026-08-09 14:07:55.521995+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('86d32fcc-3739-45cb-a463-9ed8576836fe', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '02fbcbc6-d3a1-48eb-9f4f-dddeb49c0eb1', '71aaa9bd-e82a-4900-a620-67ff94d964e4', '2026-08-25 14:07:55.52201+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('1e4fb5d3-70fe-46d0-84aa-969e85e4bbd5', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', 'c64aa5ae-72f6-4039-882d-500a2910f82a', '2026-09-14 14:07:55.522026+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('60d067b3-c696-4bd8-9460-11aa55f797e6', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', 'c64aa5ae-72f6-4039-882d-500a2910f82a', '2026-09-14 14:07:55.52204+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('4f450801-789e-441d-a54e-8fc06d014242', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '3dc4c150-7432-4cc4-897e-5aecfdaa4825', 'c64aa5ae-72f6-4039-882d-500a2910f82a', '2026-08-20 14:07:55.522053+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('1e38fdc6-11c1-4881-ac95-60ac718f9a39', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '87d56bfa-b1a5-4bba-bf20-2de8f4aaed2d', '2026-08-17 14:07:55.522071+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('1577af18-94ae-4614-84ad-5f339d8ec53c', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '87d56bfa-b1a5-4bba-bf20-2de8f4aaed2d', '2026-09-08 14:07:55.522085+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('df90c684-f73e-4d6d-900a-d7aff99df7f6', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '63444ba5-7d8a-47fd-b7a6-e07b44433311', '87d56bfa-b1a5-4bba-bf20-2de8f4aaed2d', '2026-08-11 14:07:55.522099+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('eaa77058-bb98-4400-bda3-bb1f5f3c5715', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '074ca893-80f4-4ea5-8556-d2b9be73b57f', '2026-08-05 14:07:55.522116+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('9850b7f5-2ec2-400a-8617-90d34361b51e', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '074ca893-80f4-4ea5-8556-d2b9be73b57f', '2026-08-15 14:07:55.52213+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('5833b941-7ce3-4204-95c3-707fff162cb4', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '9c4cc771-5fbf-4ed3-9d79-90bc19db71bd', '2026-08-26 14:07:55.522145+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('475bc2ae-2fd0-4bbf-aa29-cb5d57ba9c25', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '9c4cc771-5fbf-4ed3-9d79-90bc19db71bd', '2026-08-21 14:07:55.52216+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('64819be1-61d7-4b9e-ad9c-7ba09418d821', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '766f6d65-d163-4121-81b5-1167e84d8176', '9c4cc771-5fbf-4ed3-9d79-90bc19db71bd', '2026-08-30 14:07:55.522173+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('dc5266cd-3463-4555-931d-3c0ea96f14e7', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '822f260b-d92f-4caf-b5f4-2c612e7ae673', '2026-08-09 14:07:55.522189+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('bf643019-0b1c-49f9-87bc-5e25ca3834d9', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '822f260b-d92f-4caf-b5f4-2c612e7ae673', '2026-08-26 14:07:55.522203+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('3277f7a4-3b2a-4af7-8924-18469bd36b12', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '02fbcbc6-d3a1-48eb-9f4f-dddeb49c0eb1', '822f260b-d92f-4caf-b5f4-2c612e7ae673', '2026-09-01 14:07:55.522221+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('0f65c159-3f2c-4b13-acbe-4f1d62143bbd', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '0ade34fc-97f5-4862-ae56-6955897e6e52', '2026-08-25 14:07:55.522237+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('fa20525a-dfed-4cff-977b-c6003bef475b', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '0ade34fc-97f5-4862-ae56-6955897e6e52', '2026-08-27 14:07:55.52225+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('3c64bc46-7d11-40b9-9cad-7d9d5aaace7f', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '3dc4c150-7432-4cc4-897e-5aecfdaa4825', '0ade34fc-97f5-4862-ae56-6955897e6e52', '2026-08-09 14:07:55.522264+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('824cf421-8f1f-48d1-a578-0d71547115f6', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', 'e3eb2c1a-0420-4d7e-84d5-483831168795', '2026-08-04 14:07:55.522281+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('376c1e91-c9bf-4bf4-bbd3-1d256572cc66', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', 'e3eb2c1a-0420-4d7e-84d5-483831168795', '2026-09-13 14:07:55.522294+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('21b9607a-3f0f-43dc-bc17-c0850c6597c9', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '63444ba5-7d8a-47fd-b7a6-e07b44433311', 'e3eb2c1a-0420-4d7e-84d5-483831168795', '2026-09-20 14:07:55.522309+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('7ab7736f-3bfa-4d0d-907f-ad6cd8a68864', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '3f360886-48d8-4ae6-8198-2eda870872a0', '2026-08-08 14:07:55.522325+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('48e264e0-5e9b-44b9-b000-a6a13d54c9f6', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '3f360886-48d8-4ae6-8198-2eda870872a0', '2026-09-17 14:07:55.52234+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('2cb8718f-986b-4e6e-afe5-d14d58429621', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', 'db150926-30fe-438c-ad52-bae56bf264a4', '2026-09-13 14:07:55.522356+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('1d983bd0-368e-4aea-a430-9a53af949958', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', 'db150926-30fe-438c-ad52-bae56bf264a4', '2026-09-03 14:07:55.522369+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('4a30fbce-b573-471c-8c66-866a059be5c6', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '766f6d65-d163-4121-81b5-1167e84d8176', 'db150926-30fe-438c-ad52-bae56bf264a4', '2026-08-26 14:07:55.522383+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('74bb743e-b075-4cf1-9236-bbbae44777e3', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '98d26b99-1717-4c95-839d-0925c0d5b707', '2026-08-13 14:07:55.522398+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('b8891a55-70b7-4abb-8514-b024fcba2e95', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '98d26b99-1717-4c95-839d-0925c0d5b707', '2026-08-23 14:07:55.522412+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('af110758-94ee-4c57-9d7f-00479d234d4a', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '02fbcbc6-d3a1-48eb-9f4f-dddeb49c0eb1', '98d26b99-1717-4c95-839d-0925c0d5b707', '2026-08-11 14:07:55.522426+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('65e107f2-a0e5-4b46-ac11-fa69984770aa', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', 'afd5a403-53e9-4742-a84c-931bd047a5a6', '2026-08-04 14:07:55.525821+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('29613c9b-a262-472c-b1e7-4f4863096b9b', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', 'afd5a403-53e9-4742-a84c-931bd047a5a6', '2026-08-30 14:07:55.525855+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('07d11392-49b3-4c33-ad87-b5a9c53b98b4', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '3dc4c150-7432-4cc4-897e-5aecfdaa4825', 'afd5a403-53e9-4742-a84c-931bd047a5a6', '2026-09-01 14:07:55.525875+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('6dceee8a-8503-452a-9d86-928eccae8912', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '937c027a-cff8-4739-af56-462c021e612f', '2026-09-19 14:07:55.525899+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('0cac9b5c-6eb1-4ce7-873a-ef55438892c8', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '937c027a-cff8-4739-af56-462c021e612f', '2026-08-23 14:07:55.525919+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('6962adb5-961e-4ac3-92ad-a1fe465e7fba', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '63444ba5-7d8a-47fd-b7a6-e07b44433311', '937c027a-cff8-4739-af56-462c021e612f', '2026-08-16 14:07:55.525935+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('249ed06f-77b5-4165-ba72-05a75e6af199', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '3242e419-6976-4b15-9cfb-088e13b3ddfe', '2026-09-17 14:07:55.525951+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('3539dc3f-11ff-4344-9cca-4116738d0406', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '3242e419-6976-4b15-9cfb-088e13b3ddfe', '2026-08-31 14:07:55.525966+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('57ad5a57-6034-40ff-8ff8-842844bdabcb', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', 'b123200c-4226-4092-9fea-a2c9ad5d3d5b', '2026-09-05 14:07:55.525983+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('4670d072-4737-4e34-8af6-76094bd59f20', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', 'b123200c-4226-4092-9fea-a2c9ad5d3d5b', '2026-08-27 14:07:55.526003+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('33406985-62b2-4fd5-8bb1-463aad834085', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '766f6d65-d163-4121-81b5-1167e84d8176', 'b123200c-4226-4092-9fea-a2c9ad5d3d5b', '2026-09-10 14:07:55.52602+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('cefb4cbf-4ed1-4a60-be6d-981b7d5d0cac', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', 'db794458-90cc-4c01-b8de-9e6e5eb71af1', '2026-08-06 14:07:55.526036+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('b1c486d0-6721-43e0-8cea-802ba542aebf', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', 'db794458-90cc-4c01-b8de-9e6e5eb71af1', '2026-08-02 14:07:55.526051+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('412a683f-60f5-4a21-b5a0-430f9d9ba4f6', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '02fbcbc6-d3a1-48eb-9f4f-dddeb49c0eb1', 'db794458-90cc-4c01-b8de-9e6e5eb71af1', '2026-08-03 14:07:55.526065+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('0a57509b-7160-45bb-a282-4b5996dfc75f', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '2d65c079-20d2-4f92-8c9d-93175fffda44', '2026-09-04 14:07:55.526081+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('30d09561-2b95-4fa9-a988-38cb0633f23c', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2d65c079-20d2-4f92-8c9d-93175fffda44', '2026-08-28 14:07:55.526095+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('1227d044-8571-43c7-bac7-b33fa40d73e6', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '3dc4c150-7432-4cc4-897e-5aecfdaa4825', '2d65c079-20d2-4f92-8c9d-93175fffda44', '2026-08-29 14:07:55.52611+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('8f166fec-09a8-4dc7-8e82-8f1980af44b8', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '62f68269-f2ce-478c-8eaa-7e3271ec8492', '2026-08-30 14:07:55.526127+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('32a475e8-dedc-4885-8c03-c77d59d2db40', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '62f68269-f2ce-478c-8eaa-7e3271ec8492', '2026-09-13 14:07:55.526142+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('8e18219b-9293-431f-9970-bccc5a15f9d7', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '63444ba5-7d8a-47fd-b7a6-e07b44433311', '62f68269-f2ce-478c-8eaa-7e3271ec8492', '2026-08-11 14:07:55.526155+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('efd24eff-ad03-42ef-9d8e-71c0efbb6fcc', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '9df10543-26a7-4877-a1bc-ddb48e8792a5', '2026-09-20 14:07:55.526172+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('e3a2bf98-311b-49d7-805b-94bde9fff52d', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '9df10543-26a7-4877-a1bc-ddb48e8792a5', '2026-08-27 14:07:55.526186+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('669ff700-9d30-423b-9f9d-857345dbba0a', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '1aad71cc-7350-40c4-8e73-a71b0cca63b0', '2026-08-02 14:07:55.526202+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('0b973273-7cc2-4bae-90e0-66cecfc15f12', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '1aad71cc-7350-40c4-8e73-a71b0cca63b0', '2026-08-17 14:07:55.526218+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('726fe06b-1cf0-4bb2-b4f5-14c7fb6f5947', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '766f6d65-d163-4121-81b5-1167e84d8176', '1aad71cc-7350-40c4-8e73-a71b0cca63b0', '2026-09-15 14:07:55.526232+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('470e7b35-f6c5-47d9-b02a-1d7e6b237329', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', 'c71667dd-879d-4fef-b0cd-79d29591b0fd', '2026-08-26 14:07:55.526249+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('c631f62e-612c-4cdd-ac83-9b73fb0464f0', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', 'c71667dd-879d-4fef-b0cd-79d29591b0fd', '2026-09-15 14:07:55.526263+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('2291f936-da68-44c3-8101-e6941d65069a', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '02fbcbc6-d3a1-48eb-9f4f-dddeb49c0eb1', 'c71667dd-879d-4fef-b0cd-79d29591b0fd', '2026-09-19 14:07:55.526277+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('bf3df3c6-7555-4c2e-ab1d-ab87809d790c', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '8d6c7b94-6c9b-4feb-9325-d0041a7ed3af', '2026-09-07 14:07:55.526292+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('a518900d-7d2b-46ee-a388-3b4ca9dd534e', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '8d6c7b94-6c9b-4feb-9325-d0041a7ed3af', '2026-08-20 14:07:55.526307+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('94d1b5d2-b09c-4035-a753-3b776ea78ae4', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '3dc4c150-7432-4cc4-897e-5aecfdaa4825', '8d6c7b94-6c9b-4feb-9325-d0041a7ed3af', '2026-08-24 14:07:55.526321+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('37d33a06-580c-4497-93d8-a252c7ab0f47', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '99bcb5e7-1a64-469e-b3d0-e1c732109f0a', '2026-09-06 14:07:55.526339+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('5564a5e1-5f17-4bed-ab7d-ba7ddd5ef00b', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '99bcb5e7-1a64-469e-b3d0-e1c732109f0a', '2026-08-30 14:07:55.526353+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('3cf28fed-1364-4016-8f95-25d29d897005', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '63444ba5-7d8a-47fd-b7a6-e07b44433311', '99bcb5e7-1a64-469e-b3d0-e1c732109f0a', '2026-08-31 14:07:55.526367+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('a739017c-d86e-49a2-92b1-3e8debeb5371', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '8f574cd6-62ea-4dd4-8165-d3c411b220b8', '2026-09-16 14:07:55.526382+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('09d6a1ec-693d-42f9-bd96-dbf69b4f654c', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '8f574cd6-62ea-4dd4-8165-d3c411b220b8', '2026-08-20 14:07:55.526397+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('940f2359-a604-4133-a6c5-5df395af658f', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '1aac8640-517f-4334-9ffa-4dfa85cca0dd', '2026-08-13 14:07:55.526413+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('2f44a26e-00d8-476c-8940-8e5a0478b6dc', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '1aac8640-517f-4334-9ffa-4dfa85cca0dd', '2026-08-02 14:07:55.526427+00');
INSERT INTO public.course_enrollments (enrollment_id, college_id, course_id, student_id, enrolled_at) VALUES ('94a0022f-5816-4de4-8141-ab43a74ccda5', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '766f6d65-d163-4121-81b5-1167e84d8176', '1aac8640-517f-4334-9ffa-4dfa85cca0dd', '2026-08-07 14:07:55.52644+00');


--
-- Data for Name: course_materials; Type: TABLE DATA; Schema: public; Owner: edunexa_admin
--

INSERT INTO public.course_materials (material_id, college_id, course_id, faculty_id, title, description, file_url, file_type, uploaded_at) VALUES ('f991d6e2-0def-4236-b8d5-2fee32488c96', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '616d5366-a221-4453-9443-fdc767fb95fb', 'Lecture Notes - Module 1 for Data Structures & Algorithms', 'Comprehensive study notes, code examples, and practice problems.', 'https://storage.edunexa.edu/materials/apex/apex-cs101_module1.pdf', 'application/pdf', '2026-10-01 14:07:55.691201+00');
INSERT INTO public.course_materials (material_id, college_id, course_id, faculty_id, title, description, file_url, file_type, uploaded_at) VALUES ('1f6d0bf3-f320-47f7-b0e7-5520bfacbd29', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '91b41366-50ee-4f8e-b21f-d7fa7f0adac2', 'Lecture Notes - Module 2 for Database Management Systems', 'Comprehensive study notes, code examples, and practice problems.', 'https://storage.edunexa.edu/materials/apex/apex-cs102_module2.pdf', 'application/pdf', '2026-10-01 14:07:55.691204+00');
INSERT INTO public.course_materials (material_id, college_id, course_id, faculty_id, title, description, file_url, file_type, uploaded_at) VALUES ('860ed582-4599-4a79-a823-490e4f10d069', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '2353386e-f081-41a6-9acb-36523f07448a', 'ebfb52fe-6eb1-4b18-9d85-87e28faf36fa', 'Lecture Notes - Module 3 for Web Application Development', 'Comprehensive study notes, code examples, and practice problems.', 'https://storage.edunexa.edu/materials/apex/apex-it201_module3.pdf', 'application/pdf', '2026-10-01 14:07:55.691205+00');
INSERT INTO public.course_materials (material_id, college_id, course_id, faculty_id, title, description, file_url, file_type, uploaded_at) VALUES ('340ccc60-9ca8-4d84-81f4-f89483e7bee8', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'Lecture Notes - Module 1 for Data Structures & Algorithms', 'Comprehensive study notes, code examples, and practice problems.', 'https://storage.edunexa.edu/materials/horizon/horizon-cs101_module1.pdf', 'application/pdf', '2026-10-01 14:07:55.691206+00');
INSERT INTO public.course_materials (material_id, college_id, course_id, faculty_id, title, description, file_url, file_type, uploaded_at) VALUES ('afabc2c2-719d-462a-94d3-f2815a9830be', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2250c28f-e303-4468-9a97-1f156bd367a2', 'Lecture Notes - Module 2 for Database Management Systems', 'Comprehensive study notes, code examples, and practice problems.', 'https://storage.edunexa.edu/materials/horizon/horizon-cs102_module2.pdf', 'application/pdf', '2026-10-01 14:07:55.691206+00');
INSERT INTO public.course_materials (material_id, college_id, course_id, faculty_id, title, description, file_url, file_type, uploaded_at) VALUES ('004523a4-11be-4b39-963c-a085511d4684', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '766f6d65-d163-4121-81b5-1167e84d8176', '2c59b27d-49b6-4b00-b43b-663cfb61cfe3', 'Lecture Notes - Module 3 for Web Application Development', 'Comprehensive study notes, code examples, and practice problems.', 'https://storage.edunexa.edu/materials/horizon/horizon-it201_module3.pdf', 'application/pdf', '2026-10-01 14:07:55.691207+00');


--
-- Data for Name: courses; Type: TABLE DATA; Schema: public; Owner: edunexa_admin
--

INSERT INTO public.courses (course_id, college_id, course_code, course_name, department, credits, semester, created_at) VALUES ('ed911e71-dea5-4896-a6f6-5b943628dbbb', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'APEX-CS101', 'Data Structures & Algorithms', 'Computer Science', 4, 'Sem 3', '2026-10-01 14:07:55.425105+00');
INSERT INTO public.courses (course_id, college_id, course_code, course_name, department, credits, semester, created_at) VALUES ('e64f4d99-4d3a-48bf-bc08-78ff381948db', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'APEX-CS102', 'Database Management Systems', 'Computer Science', 4, 'Sem 3', '2026-10-01 14:07:55.425108+00');
INSERT INTO public.courses (course_id, college_id, course_code, course_name, department, credits, semester, created_at) VALUES ('2353386e-f081-41a6-9acb-36523f07448a', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'APEX-IT201', 'Web Application Development', 'Information Technology', 3, 'Sem 3', '2026-10-01 14:07:55.425109+00');
INSERT INTO public.courses (course_id, college_id, course_code, course_name, department, credits, semester, created_at) VALUES ('3cbb2009-12af-42cc-a809-d3f4e9cf6fa8', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'APEX-EC201', 'Digital Signal Processing', 'Electronics & Comm', 4, 'Sem 5', '2026-10-01 14:07:55.425109+00');
INSERT INTO public.courses (course_id, college_id, course_code, course_name, department, credits, semester, created_at) VALUES ('9a5913dd-4485-420e-80a9-7ebaa12a550c', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'APEX-ME301', 'Thermodynamics & Heat Transfer', 'Mechanical Eng', 3, 'Sem 5', '2026-10-01 14:07:55.425109+00');
INSERT INTO public.courses (course_id, college_id, course_code, course_name, department, credits, semester, created_at) VALUES ('ce1e25f8-aa32-4583-9e7e-25f94a894ca2', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'APEX-CE101', 'Structural Mechanics', 'Civil Eng', 3, 'Sem 1', '2026-10-01 14:07:55.42511+00');
INSERT INTO public.courses (course_id, college_id, course_code, course_name, department, credits, semester, created_at) VALUES ('f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'HORIZON-CS101', 'Data Structures & Algorithms', 'Computer Science', 4, 'Sem 3', '2026-10-01 14:07:55.42511+00');
INSERT INTO public.courses (course_id, college_id, course_code, course_name, department, credits, semester, created_at) VALUES ('0af8e7ab-4c82-4a1f-bbde-6742fff408a5', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'HORIZON-CS102', 'Database Management Systems', 'Computer Science', 4, 'Sem 3', '2026-10-01 14:07:55.425111+00');
INSERT INTO public.courses (course_id, college_id, course_code, course_name, department, credits, semester, created_at) VALUES ('766f6d65-d163-4121-81b5-1167e84d8176', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'HORIZON-IT201', 'Web Application Development', 'Information Technology', 3, 'Sem 3', '2026-10-01 14:07:55.425111+00');
INSERT INTO public.courses (course_id, college_id, course_code, course_name, department, credits, semester, created_at) VALUES ('02fbcbc6-d3a1-48eb-9f4f-dddeb49c0eb1', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'HORIZON-EC201', 'Digital Signal Processing', 'Electronics & Comm', 4, 'Sem 5', '2026-10-01 14:07:55.425111+00');
INSERT INTO public.courses (course_id, college_id, course_code, course_name, department, credits, semester, created_at) VALUES ('3dc4c150-7432-4cc4-897e-5aecfdaa4825', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'HORIZON-ME301', 'Thermodynamics & Heat Transfer', 'Mechanical Eng', 3, 'Sem 5', '2026-10-01 14:07:55.425112+00');
INSERT INTO public.courses (course_id, college_id, course_code, course_name, department, credits, semester, created_at) VALUES ('63444ba5-7d8a-47fd-b7a6-e07b44433311', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'HORIZON-CE101', 'Structural Mechanics', 'Civil Eng', 3, 'Sem 1', '2026-10-01 14:07:55.425112+00');


--
-- Data for Name: faculty; Type: TABLE DATA; Schema: public; Owner: edunexa_admin
--

INSERT INTO public.faculty (faculty_id, college_id, user_id, employee_code, first_name, last_name, department, designation, created_at) VALUES ('616d5366-a221-4453-9443-fdc767fb95fb', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '008bbe33-c477-468b-97ba-076f6a0074a3', 'APEX-FAC-1001', 'Dr. Rajesh', 'Nambiar', 'Computer Science', 'Professor', '2026-10-01 14:07:55.430318+00');
INSERT INTO public.faculty (faculty_id, college_id, user_id, employee_code, first_name, last_name, department, designation, created_at) VALUES ('91b41366-50ee-4f8e-b21f-d7fa7f0adac2', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '70fa4209-d390-4366-a09f-93fd36406080', 'APEX-FAC-1002', 'Dr. Sunita', 'Raman', 'Computer Science', 'Associate Professor', '2026-10-01 14:07:55.432951+00');
INSERT INTO public.faculty (faculty_id, college_id, user_id, employee_code, first_name, last_name, department, designation, created_at) VALUES ('ebfb52fe-6eb1-4b18-9d85-87e28faf36fa', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '1e347a19-aa04-45ab-bb93-54243c4749eb', 'APEX-FAC-1003', 'Prof. Amit', 'Deshmukh', 'Information Technology', 'Assistant Professor', '2026-10-01 14:07:55.434816+00');
INSERT INTO public.faculty (faculty_id, college_id, user_id, employee_code, first_name, last_name, department, designation, created_at) VALUES ('e9a0cabe-6409-4152-b0dc-883cef5e0cad', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '016be7c9-9f12-49ed-ae85-456cb332171c', 'APEX-FAC-1004', 'Dr. Kavita', 'Menon', 'Electronics & Comm', 'Associate Professor', '2026-10-01 14:07:55.43629+00');
INSERT INTO public.faculty (faculty_id, college_id, user_id, employee_code, first_name, last_name, department, designation, created_at) VALUES ('ad73351c-bf89-4702-b749-df50fb5eba9a', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '7fe0df9b-f846-4842-b449-f637a34bed37', 'APEX-FAC-1005', 'Prof. Ramesh', 'Pawar', 'Mechanical Eng', 'Professor', '2026-10-01 14:07:55.437711+00');
INSERT INTO public.faculty (faculty_id, college_id, user_id, employee_code, first_name, last_name, department, designation, created_at) VALUES ('535ee669-c190-4ff6-bd43-2d93d325feb3', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'ede481cf-34f8-4415-aa15-d8966ea70019', 'HORIZON-FAC-1001', 'Dr. Alistair', 'Crawford', 'Computer Science', 'Professor', '2026-10-01 14:07:55.439175+00');
INSERT INTO public.faculty (faculty_id, college_id, user_id, employee_code, first_name, last_name, department, designation, created_at) VALUES ('2250c28f-e303-4468-9a97-1f156bd367a2', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '083ada4c-8c3f-4f11-bf06-ef2f38be7710', 'HORIZON-FAC-1002', 'Dr. Sarah', 'Jenkins', 'Information Technology', 'Associate Professor', '2026-10-01 14:07:55.440943+00');
INSERT INTO public.faculty (faculty_id, college_id, user_id, employee_code, first_name, last_name, department, designation, created_at) VALUES ('2c59b27d-49b6-4b00-b43b-663cfb61cfe3', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '063f1291-8bc0-4854-86e9-c70da56cdff3', 'HORIZON-FAC-1003', 'Prof. Marcus', 'Vaughn', 'Electronics & Comm', 'Assistant Professor', '2026-10-01 14:07:55.44276+00');
INSERT INTO public.faculty (faculty_id, college_id, user_id, employee_code, first_name, last_name, department, designation, created_at) VALUES ('cb636a9c-a484-42a0-a0c9-d494ae5b816f', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '19002895-0aa1-4b8c-bf5f-335f4df424ff', 'HORIZON-FAC-1004', 'Dr. Elena', 'Rostova', 'Mechanical Eng', 'Associate Professor', '2026-10-01 14:07:55.444334+00');
INSERT INTO public.faculty (faculty_id, college_id, user_id, employee_code, first_name, last_name, department, designation, created_at) VALUES ('5cb1dbf1-af43-4276-9cd1-5f8a676a2503', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '26e41dd3-f32d-4598-bc36-29b6c3dd647c', 'HORIZON-FAC-1005', 'Prof. David', 'Kim', 'Civil Eng', 'Assistant Professor', '2026-10-01 14:07:55.445077+00');


--
-- Data for Name: grades; Type: TABLE DATA; Schema: public; Owner: edunexa_admin
--

INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('0f85b51b-b0c0-4701-b372-3f6f835173f7', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'd91be8a0-c589-4080-a507-14f8dfdd23b2', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '616d5366-a221-4453-9443-fdc767fb95fb', 'Midterm Examination 2024', 84.50, 100.00, 'Good conceptual clarity', '2026-10-01 14:07:55.628942+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('dc107cf6-1a2b-45e5-a552-20d3807d0cd0', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'd91be8a0-c589-4080-a507-14f8dfdd23b2', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '616d5366-a221-4453-9443-fdc767fb95fb', 'Midterm Examination 2024', 72.50, 100.00, 'Satisfactory', '2026-10-01 14:07:55.628945+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('0e960426-f94f-45d5-ae3d-1236973dfbf5', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '66978ac8-b94a-472f-98c7-012edb67c91b', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '616d5366-a221-4453-9443-fdc767fb95fb', 'Midterm Examination 2024', 95.50, 100.00, 'Good conceptual clarity', '2026-10-01 14:07:55.628946+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('3aba3dfd-775b-4b17-9842-871d886b3800', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '66978ac8-b94a-472f-98c7-012edb67c91b', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '616d5366-a221-4453-9443-fdc767fb95fb', 'Midterm Examination 2024', 88.50, 100.00, 'Good conceptual clarity', '2026-10-01 14:07:55.628946+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('f3939acc-470c-42ae-be3d-02cc117d4618', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'd24111ba-f892-4a39-a392-85e81eb9132c', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '616d5366-a221-4453-9443-fdc767fb95fb', 'Midterm Examination 2024', 77.50, 100.00, 'Satisfactory', '2026-10-01 14:07:55.628947+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('bba6d1ae-cfef-4054-84e3-08271f04920e', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'd24111ba-f892-4a39-a392-85e81eb9132c', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '616d5366-a221-4453-9443-fdc767fb95fb', 'Midterm Examination 2024', 76.50, 100.00, 'Satisfactory', '2026-10-01 14:07:55.628947+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('c11ef091-f9ba-4151-833e-38feb11c3df3', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'b53d8f73-83df-4762-b522-a445d9933f63', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '616d5366-a221-4453-9443-fdc767fb95fb', 'Midterm Examination 2024', 75.50, 100.00, 'Satisfactory', '2026-10-01 14:07:55.628948+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('984ac6c2-b374-482c-82d0-f46eb4e03e3a', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'b53d8f73-83df-4762-b522-a445d9933f63', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '616d5366-a221-4453-9443-fdc767fb95fb', 'Midterm Examination 2024', 72.50, 100.00, 'Satisfactory', '2026-10-01 14:07:55.628948+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('eb342370-4fd7-45ca-9ba5-3150d750fc93', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'b278f61a-13eb-41c1-99d5-2110b3a1bcc5', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '616d5366-a221-4453-9443-fdc767fb95fb', 'Midterm Examination 2024', 92.50, 100.00, 'Good conceptual clarity', '2026-10-01 14:07:55.628948+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('9d60db0f-c09d-4337-8299-b7a02161967b', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'b278f61a-13eb-41c1-99d5-2110b3a1bcc5', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '616d5366-a221-4453-9443-fdc767fb95fb', 'Midterm Examination 2024', 95.50, 100.00, 'Good conceptual clarity', '2026-10-01 14:07:55.628949+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('8b4099b3-863e-4345-bb52-b8bfb5cbcdc9', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '4c6bc0c4-345d-423e-952f-fbd00e9abe3d', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '616d5366-a221-4453-9443-fdc767fb95fb', 'Midterm Examination 2024', 82.50, 100.00, 'Good conceptual clarity', '2026-10-01 14:07:55.628949+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('fdceb842-5c1d-4713-aa18-08543566de9a', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '4c6bc0c4-345d-423e-952f-fbd00e9abe3d', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '616d5366-a221-4453-9443-fdc767fb95fb', 'Midterm Examination 2024', 74.50, 100.00, 'Satisfactory', '2026-10-01 14:07:55.628949+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('97a861b1-3df8-4d2e-87b2-c05206e2941c', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'a7a87c91-31e1-4c95-9071-39b742346013', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '616d5366-a221-4453-9443-fdc767fb95fb', 'Midterm Examination 2024', 91.50, 100.00, 'Good conceptual clarity', '2026-10-01 14:07:55.62895+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('53a20b42-b188-403c-9bc8-d1dc9e93ab56', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'a7a87c91-31e1-4c95-9071-39b742346013', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '616d5366-a221-4453-9443-fdc767fb95fb', 'Midterm Examination 2024', 71.50, 100.00, 'Satisfactory', '2026-10-01 14:07:55.62895+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('04575744-5be7-4355-913b-07511030fcad', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '535e3192-51ae-4e6e-90cf-473b1f0db55c', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '616d5366-a221-4453-9443-fdc767fb95fb', 'Midterm Examination 2024', 75.50, 100.00, 'Satisfactory', '2026-10-01 14:07:55.628951+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('8e67dd44-5607-441f-9775-b67c7f914daf', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '535e3192-51ae-4e6e-90cf-473b1f0db55c', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '616d5366-a221-4453-9443-fdc767fb95fb', 'Midterm Examination 2024', 79.50, 100.00, 'Satisfactory', '2026-10-01 14:07:55.628951+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('f14a1ec8-9f63-420b-8a7e-b9ef6f407b73', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '169a3258-9e01-4b90-ace8-66be170c035f', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '616d5366-a221-4453-9443-fdc767fb95fb', 'Midterm Examination 2024', 89.50, 100.00, 'Good conceptual clarity', '2026-10-01 14:07:55.628951+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('f044e5d3-d361-4b89-8f06-24fc0809e26f', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '169a3258-9e01-4b90-ace8-66be170c035f', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '616d5366-a221-4453-9443-fdc767fb95fb', 'Midterm Examination 2024', 79.50, 100.00, 'Satisfactory', '2026-10-01 14:07:55.628952+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('709e226c-cae4-4c2a-b178-3253b7861fee', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'a13e1758-df90-4ef6-b7b7-664b5c273eca', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '616d5366-a221-4453-9443-fdc767fb95fb', 'Midterm Examination 2024', 93.50, 100.00, 'Good conceptual clarity', '2026-10-01 14:07:55.628952+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('999f52ab-2b95-4ba0-b6bf-05473856140f', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'a13e1758-df90-4ef6-b7b7-664b5c273eca', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '616d5366-a221-4453-9443-fdc767fb95fb', 'Midterm Examination 2024', 98.50, 100.00, 'Good conceptual clarity', '2026-10-01 14:07:55.628952+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('3288be9e-0933-4dad-adaf-d6f120076c6c', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '4cf325fa-5154-4620-a4fc-049776c9e6b6', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '616d5366-a221-4453-9443-fdc767fb95fb', 'Midterm Examination 2024', 79.50, 100.00, 'Satisfactory', '2026-10-01 14:07:55.628953+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('87c82782-1e86-4013-b37b-af99ef8688e0', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '4cf325fa-5154-4620-a4fc-049776c9e6b6', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '616d5366-a221-4453-9443-fdc767fb95fb', 'Midterm Examination 2024', 85.50, 100.00, 'Good conceptual clarity', '2026-10-01 14:07:55.628953+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('ff28a60e-2fc0-44bc-a624-24332b4a455e', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '03ac1155-58c5-4b44-b605-4ccaf8d6a02d', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '616d5366-a221-4453-9443-fdc767fb95fb', 'Midterm Examination 2024', 79.50, 100.00, 'Satisfactory', '2026-10-01 14:07:55.628953+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('6f77af12-5d49-4d9a-ab53-b57c52b953fb', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '03ac1155-58c5-4b44-b605-4ccaf8d6a02d', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '616d5366-a221-4453-9443-fdc767fb95fb', 'Midterm Examination 2024', 89.50, 100.00, 'Good conceptual clarity', '2026-10-01 14:07:55.628954+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('a2777896-48bd-441a-a7aa-a0054a9e44c8', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'fdeb06a3-74da-4120-bc71-653085b7aea0', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '616d5366-a221-4453-9443-fdc767fb95fb', 'Midterm Examination 2024', 98.50, 100.00, 'Good conceptual clarity', '2026-10-01 14:07:55.628954+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('cd1f0957-dd51-4685-9be2-ea928ae136e0', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'fdeb06a3-74da-4120-bc71-653085b7aea0', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '616d5366-a221-4453-9443-fdc767fb95fb', 'Midterm Examination 2024', 97.50, 100.00, 'Good conceptual clarity', '2026-10-01 14:07:55.628954+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('165b58c0-74cc-475c-acb0-5670a7976ea9', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'fc0f5eed-999f-4329-8368-17737a95e148', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '616d5366-a221-4453-9443-fdc767fb95fb', 'Midterm Examination 2024', 76.50, 100.00, 'Satisfactory', '2026-10-01 14:07:55.628955+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('641ac6a7-2f05-4889-a837-f02d8c069bfa', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'fc0f5eed-999f-4329-8368-17737a95e148', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '616d5366-a221-4453-9443-fdc767fb95fb', 'Midterm Examination 2024', 77.50, 100.00, 'Satisfactory', '2026-10-01 14:07:55.628955+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('0c7e07e9-86f3-4783-a92b-ccfbd347edc0', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '44da7ddf-963f-4685-8d4b-f09eb6900c65', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '616d5366-a221-4453-9443-fdc767fb95fb', 'Midterm Examination 2024', 72.50, 100.00, 'Satisfactory', '2026-10-01 14:07:55.628956+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('fcecdc18-3ea9-4784-a56f-343f820fd7ae', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '44da7ddf-963f-4685-8d4b-f09eb6900c65', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '616d5366-a221-4453-9443-fdc767fb95fb', 'Midterm Examination 2024', 83.50, 100.00, 'Good conceptual clarity', '2026-10-01 14:07:55.628956+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('b0e2611b-8e5e-4a74-803d-4e008af1d1c8', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '487eef9d-7e83-44ff-ba05-5633563d482c', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '616d5366-a221-4453-9443-fdc767fb95fb', 'Midterm Examination 2024', 71.50, 100.00, 'Satisfactory', '2026-10-01 14:07:55.628956+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('40012bd3-790e-4ccc-883c-94de16d0c902', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '487eef9d-7e83-44ff-ba05-5633563d482c', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '616d5366-a221-4453-9443-fdc767fb95fb', 'Midterm Examination 2024', 83.50, 100.00, 'Good conceptual clarity', '2026-10-01 14:07:55.628957+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('a64c338e-716e-4d63-8cc8-a62e10ad8769', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '3c246328-8187-4c8f-8785-1fbc652f0b34', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '616d5366-a221-4453-9443-fdc767fb95fb', 'Midterm Examination 2024', 78.50, 100.00, 'Satisfactory', '2026-10-01 14:07:55.628957+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('ce261d50-5c34-4abf-98ef-a59f6f84a8d9', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '3c246328-8187-4c8f-8785-1fbc652f0b34', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '616d5366-a221-4453-9443-fdc767fb95fb', 'Midterm Examination 2024', 86.50, 100.00, 'Good conceptual clarity', '2026-10-01 14:07:55.628957+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('28caa137-4b99-450e-a5f9-467b5d2c3e85', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '09c8b7bd-6217-42a5-ab71-19de2a0f887c', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '616d5366-a221-4453-9443-fdc767fb95fb', 'Midterm Examination 2024', 77.50, 100.00, 'Satisfactory', '2026-10-01 14:07:55.628958+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('ae03bb38-8aed-4875-b77e-ff56109ce13c', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '09c8b7bd-6217-42a5-ab71-19de2a0f887c', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '616d5366-a221-4453-9443-fdc767fb95fb', 'Midterm Examination 2024', 96.50, 100.00, 'Good conceptual clarity', '2026-10-01 14:07:55.628958+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('b448a377-95ca-48f6-b6df-cd2fb48d94ef', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '8a408aa6-acc8-4897-96a9-219db1fa2552', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '616d5366-a221-4453-9443-fdc767fb95fb', 'Midterm Examination 2024', 90.50, 100.00, 'Good conceptual clarity', '2026-10-01 14:07:55.628958+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('45a20845-371a-4433-94fe-a430876ea49c', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '8a408aa6-acc8-4897-96a9-219db1fa2552', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '616d5366-a221-4453-9443-fdc767fb95fb', 'Midterm Examination 2024', 73.50, 100.00, 'Satisfactory', '2026-10-01 14:07:55.628959+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('74711e94-cca6-424a-9ab4-04e7d2a258f5', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'cd824327-8e9e-4e04-8d37-3de8f110cda1', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '616d5366-a221-4453-9443-fdc767fb95fb', 'Midterm Examination 2024', 89.50, 100.00, 'Good conceptual clarity', '2026-10-01 14:07:55.628959+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('b0c50999-d503-4f32-8045-cf502a85033a', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'cd824327-8e9e-4e04-8d37-3de8f110cda1', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '616d5366-a221-4453-9443-fdc767fb95fb', 'Midterm Examination 2024', 77.50, 100.00, 'Satisfactory', '2026-10-01 14:07:55.628959+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('e660630d-196a-4b9a-80ef-a1f5b47d638d', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'aeafaeb3-92d4-4889-9cab-23453afefb31', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '616d5366-a221-4453-9443-fdc767fb95fb', 'Midterm Examination 2024', 88.50, 100.00, 'Good conceptual clarity', '2026-10-01 14:07:55.62896+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('bf35e144-38a0-4fa3-a06d-cdb2382765f2', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'aeafaeb3-92d4-4889-9cab-23453afefb31', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '616d5366-a221-4453-9443-fdc767fb95fb', 'Midterm Examination 2024', 87.50, 100.00, 'Good conceptual clarity', '2026-10-01 14:07:55.62896+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('398cd57c-c8af-4ba5-9124-b23990adbef2', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '4276399b-c86e-48fa-8165-70f0968bc730', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '616d5366-a221-4453-9443-fdc767fb95fb', 'Midterm Examination 2024', 86.50, 100.00, 'Good conceptual clarity', '2026-10-01 14:07:55.62896+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('15a63945-495a-4906-91c6-30f3fe2e2168', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '4276399b-c86e-48fa-8165-70f0968bc730', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '616d5366-a221-4453-9443-fdc767fb95fb', 'Midterm Examination 2024', 76.50, 100.00, 'Satisfactory', '2026-10-01 14:07:55.628961+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('3ad9cc1c-6866-4650-9df1-469dcac9def8', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '8754eeda-ec00-4dfc-a714-3f667eb1b492', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '616d5366-a221-4453-9443-fdc767fb95fb', 'Midterm Examination 2024', 86.50, 100.00, 'Good conceptual clarity', '2026-10-01 14:07:55.628961+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('911dcf8d-6ec4-40d4-a9e7-627997907a8c', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '8754eeda-ec00-4dfc-a714-3f667eb1b492', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '616d5366-a221-4453-9443-fdc767fb95fb', 'Midterm Examination 2024', 85.50, 100.00, 'Good conceptual clarity', '2026-10-01 14:07:55.628961+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('6952070b-efe9-408a-8abb-6109d8328b76', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '9851826b-3a5e-47ab-a7b6-6bda495e7d74', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '616d5366-a221-4453-9443-fdc767fb95fb', 'Midterm Examination 2024', 93.50, 100.00, 'Good conceptual clarity', '2026-10-01 14:07:55.628962+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('262e047a-6f7c-47a0-bcdb-453393f24d29', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '9851826b-3a5e-47ab-a7b6-6bda495e7d74', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '616d5366-a221-4453-9443-fdc767fb95fb', 'Midterm Examination 2024', 83.50, 100.00, 'Good conceptual clarity', '2026-10-01 14:07:55.628962+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('96c9953e-ba01-4cf1-90ec-ecfe156220ae', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'dc3ce680-65f9-4f03-a7da-e652279761c3', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '616d5366-a221-4453-9443-fdc767fb95fb', 'Midterm Examination 2024', 82.50, 100.00, 'Good conceptual clarity', '2026-10-01 14:07:55.628963+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('5ba79cb4-838f-4b74-9cba-8de8ee2450a7', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'dc3ce680-65f9-4f03-a7da-e652279761c3', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '616d5366-a221-4453-9443-fdc767fb95fb', 'Midterm Examination 2024', 76.50, 100.00, 'Satisfactory', '2026-10-01 14:07:55.628963+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('84945f9f-8164-4fe6-9720-922a4df2ce3a', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '71aaa9bd-e82a-4900-a620-67ff94d964e4', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'Midterm Examination 2024', 77.50, 100.00, 'Satisfactory', '2026-10-01 14:07:55.628963+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('492978a0-542f-43ef-9b45-ba3afc0fb2b0', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '71aaa9bd-e82a-4900-a620-67ff94d964e4', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'Midterm Examination 2024', 77.50, 100.00, 'Satisfactory', '2026-10-01 14:07:55.628964+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('74458fe5-8ecb-4b88-99b2-cf70e613878c', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'c64aa5ae-72f6-4039-882d-500a2910f82a', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'Midterm Examination 2024', 94.50, 100.00, 'Good conceptual clarity', '2026-10-01 14:07:55.628965+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('5de9689e-5fa1-475d-a678-ee6ac6a21f8a', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'c64aa5ae-72f6-4039-882d-500a2910f82a', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'Midterm Examination 2024', 79.50, 100.00, 'Satisfactory', '2026-10-01 14:07:55.628965+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('1b62c06f-1f80-4edc-943c-078c28e7a02f', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '87d56bfa-b1a5-4bba-bf20-2de8f4aaed2d', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'Midterm Examination 2024', 97.50, 100.00, 'Good conceptual clarity', '2026-10-01 14:07:55.628965+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('f59eda0f-27ad-4c73-9828-fe573aa56f9c', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '87d56bfa-b1a5-4bba-bf20-2de8f4aaed2d', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'Midterm Examination 2024', 79.50, 100.00, 'Satisfactory', '2026-10-01 14:07:55.628966+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('1fe9f59e-68ab-46b6-bbc8-fc2e8fdcf62e', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '074ca893-80f4-4ea5-8556-d2b9be73b57f', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'Midterm Examination 2024', 82.50, 100.00, 'Good conceptual clarity', '2026-10-01 14:07:55.628966+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('7de30c99-9a0e-42a1-9938-7e1d3e14d84d', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '074ca893-80f4-4ea5-8556-d2b9be73b57f', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'Midterm Examination 2024', 73.50, 100.00, 'Satisfactory', '2026-10-01 14:07:55.628967+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('a5d41135-ea4b-4227-bd5f-17c8b42cdf91', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '9c4cc771-5fbf-4ed3-9d79-90bc19db71bd', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'Midterm Examination 2024', 89.50, 100.00, 'Good conceptual clarity', '2026-10-01 14:07:55.628967+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('685dfabf-b890-4622-9a54-f7da7eb2303d', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '9c4cc771-5fbf-4ed3-9d79-90bc19db71bd', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'Midterm Examination 2024', 78.50, 100.00, 'Satisfactory', '2026-10-01 14:07:55.628967+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('6c8b4778-9018-4de6-b18e-bfddddd74c5b', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '822f260b-d92f-4caf-b5f4-2c612e7ae673', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'Midterm Examination 2024', 86.50, 100.00, 'Good conceptual clarity', '2026-10-01 14:07:55.628968+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('50ab0df8-6834-4117-b38e-d5aebea3d2e2', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '822f260b-d92f-4caf-b5f4-2c612e7ae673', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'Midterm Examination 2024', 87.50, 100.00, 'Good conceptual clarity', '2026-10-01 14:07:55.628968+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('c74bc46b-4aa7-4590-bf98-d64227ede3e6', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '0ade34fc-97f5-4862-ae56-6955897e6e52', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'Midterm Examination 2024', 91.50, 100.00, 'Good conceptual clarity', '2026-10-01 14:07:55.628968+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('6fe9023b-8add-461e-8ca3-6c3c11133722', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '0ade34fc-97f5-4862-ae56-6955897e6e52', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'Midterm Examination 2024', 92.50, 100.00, 'Good conceptual clarity', '2026-10-01 14:07:55.628969+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('aa13bc23-bbbf-4301-a523-c109ff38aa28', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'e3eb2c1a-0420-4d7e-84d5-483831168795', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'Midterm Examination 2024', 76.50, 100.00, 'Satisfactory', '2026-10-01 14:07:55.628969+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('004ae016-be7c-4d25-86aa-92f9442891c1', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'e3eb2c1a-0420-4d7e-84d5-483831168795', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'Midterm Examination 2024', 72.50, 100.00, 'Satisfactory', '2026-10-01 14:07:55.628969+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('0d1d37d2-b7f3-4a09-928f-adaa27586990', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '3f360886-48d8-4ae6-8198-2eda870872a0', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'Midterm Examination 2024', 84.50, 100.00, 'Good conceptual clarity', '2026-10-01 14:07:55.62897+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('d8c21104-d462-405b-b00b-5076fd9fea63', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '3f360886-48d8-4ae6-8198-2eda870872a0', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'Midterm Examination 2024', 82.50, 100.00, 'Good conceptual clarity', '2026-10-01 14:07:55.62897+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('8ee2f352-5582-4789-beb3-d47712878195', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'db150926-30fe-438c-ad52-bae56bf264a4', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'Midterm Examination 2024', 98.50, 100.00, 'Good conceptual clarity', '2026-10-01 14:07:55.62897+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('6cfc7258-135f-4795-80ad-9561c8539aa5', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'db150926-30fe-438c-ad52-bae56bf264a4', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'Midterm Examination 2024', 98.50, 100.00, 'Good conceptual clarity', '2026-10-01 14:07:55.628971+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('6cedd380-4059-4bad-9614-bedeed1842f0', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '98d26b99-1717-4c95-839d-0925c0d5b707', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'Midterm Examination 2024', 81.50, 100.00, 'Good conceptual clarity', '2026-10-01 14:07:55.628971+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('93815ec5-2df2-433c-9097-576a0d1afc31', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '98d26b99-1717-4c95-839d-0925c0d5b707', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'Midterm Examination 2024', 82.50, 100.00, 'Good conceptual clarity', '2026-10-01 14:07:55.628971+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('5ed7dd9c-e048-4105-9271-3480d9adc57d', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'afd5a403-53e9-4742-a84c-931bd047a5a6', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'Midterm Examination 2024', 74.50, 100.00, 'Satisfactory', '2026-10-01 14:07:55.628972+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('b66f60a2-9152-4b43-bf7f-5808464206bd', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'afd5a403-53e9-4742-a84c-931bd047a5a6', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'Midterm Examination 2024', 89.50, 100.00, 'Good conceptual clarity', '2026-10-01 14:07:55.628972+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('99079619-5879-4671-927d-54974d5bc037', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '937c027a-cff8-4739-af56-462c021e612f', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'Midterm Examination 2024', 79.50, 100.00, 'Satisfactory', '2026-10-01 14:07:55.628972+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('0514d5a1-e2c6-422a-90bd-097ac522e553', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '937c027a-cff8-4739-af56-462c021e612f', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'Midterm Examination 2024', 73.50, 100.00, 'Satisfactory', '2026-10-01 14:07:55.628973+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('5a8462b4-9d8c-495a-b008-71bf22ca2acd', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '3242e419-6976-4b15-9cfb-088e13b3ddfe', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'Midterm Examination 2024', 98.50, 100.00, 'Good conceptual clarity', '2026-10-01 14:07:55.628973+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('0778feb8-92a7-4353-a611-b86eb15aa9b9', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '3242e419-6976-4b15-9cfb-088e13b3ddfe', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'Midterm Examination 2024', 96.50, 100.00, 'Good conceptual clarity', '2026-10-01 14:07:55.628973+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('0c1fd7a5-4415-4c36-bcb1-9ac3e643b59c', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'b123200c-4226-4092-9fea-a2c9ad5d3d5b', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'Midterm Examination 2024', 75.50, 100.00, 'Satisfactory', '2026-10-01 14:07:55.628974+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('b376d982-b87a-4af4-bbb4-88ced523b3d7', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'b123200c-4226-4092-9fea-a2c9ad5d3d5b', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'Midterm Examination 2024', 78.50, 100.00, 'Satisfactory', '2026-10-01 14:07:55.628974+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('0906bc5f-c8f5-4c09-aa6e-da36ccedf03f', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'db794458-90cc-4c01-b8de-9e6e5eb71af1', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'Midterm Examination 2024', 70.50, 100.00, 'Satisfactory', '2026-10-01 14:07:55.628974+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('04352360-6b7e-476f-b34c-251fa653cd6e', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'db794458-90cc-4c01-b8de-9e6e5eb71af1', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'Midterm Examination 2024', 87.50, 100.00, 'Good conceptual clarity', '2026-10-01 14:07:55.628975+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('9deba5ec-73d8-43e4-891e-23d4ad90705b', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '2d65c079-20d2-4f92-8c9d-93175fffda44', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'Midterm Examination 2024', 93.50, 100.00, 'Good conceptual clarity', '2026-10-01 14:07:55.628975+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('efa1c679-f0ba-4a52-8792-257bc7d1d4f3', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '2d65c079-20d2-4f92-8c9d-93175fffda44', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'Midterm Examination 2024', 79.50, 100.00, 'Satisfactory', '2026-10-01 14:07:55.628975+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('f0cd472a-18dd-4275-9a33-5a6fcba798c7', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '62f68269-f2ce-478c-8eaa-7e3271ec8492', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'Midterm Examination 2024', 93.50, 100.00, 'Good conceptual clarity', '2026-10-01 14:07:55.628976+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('681961a9-cf81-4f3d-b764-a44638401dfe', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '62f68269-f2ce-478c-8eaa-7e3271ec8492', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'Midterm Examination 2024', 75.50, 100.00, 'Satisfactory', '2026-10-01 14:07:55.628976+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('a75ba87d-36d1-4099-a4e7-d4df4f89cd8a', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '9df10543-26a7-4877-a1bc-ddb48e8792a5', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'Midterm Examination 2024', 78.50, 100.00, 'Satisfactory', '2026-10-01 14:07:55.628976+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('fa5c633a-88c6-4b65-a114-359be695da29', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '9df10543-26a7-4877-a1bc-ddb48e8792a5', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'Midterm Examination 2024', 72.50, 100.00, 'Satisfactory', '2026-10-01 14:07:55.628977+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('6f6da82d-bdc5-4f1d-943e-e8b3a41970ee', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '1aad71cc-7350-40c4-8e73-a71b0cca63b0', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'Midterm Examination 2024', 91.50, 100.00, 'Good conceptual clarity', '2026-10-01 14:07:55.628977+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('3f8d6e53-5329-494f-9249-66352d2b753f', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '1aad71cc-7350-40c4-8e73-a71b0cca63b0', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'Midterm Examination 2024', 71.50, 100.00, 'Satisfactory', '2026-10-01 14:07:55.628977+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('20147a10-3c44-4565-b6f2-a1438079e0ff', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'c71667dd-879d-4fef-b0cd-79d29591b0fd', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'Midterm Examination 2024', 77.50, 100.00, 'Satisfactory', '2026-10-01 14:07:55.628978+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('f7999314-3336-423a-abcd-a76c0364b63c', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'c71667dd-879d-4fef-b0cd-79d29591b0fd', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'Midterm Examination 2024', 97.50, 100.00, 'Good conceptual clarity', '2026-10-01 14:07:55.628978+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('6b3b7220-1112-4b5c-bdc0-a5b2323ad08a', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '8d6c7b94-6c9b-4feb-9325-d0041a7ed3af', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'Midterm Examination 2024', 73.50, 100.00, 'Satisfactory', '2026-10-01 14:07:55.628978+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('71e91d36-4acb-4ab4-8ad1-4cae431f2d01', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '8d6c7b94-6c9b-4feb-9325-d0041a7ed3af', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'Midterm Examination 2024', 82.50, 100.00, 'Good conceptual clarity', '2026-10-01 14:07:55.628979+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('e2eba163-54ee-4012-8673-cd77ffc9f33f', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '99bcb5e7-1a64-469e-b3d0-e1c732109f0a', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'Midterm Examination 2024', 91.50, 100.00, 'Good conceptual clarity', '2026-10-01 14:07:55.628979+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('40ea12c9-5f8c-47e0-ad28-0c0bf015c97c', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '99bcb5e7-1a64-469e-b3d0-e1c732109f0a', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'Midterm Examination 2024', 72.50, 100.00, 'Satisfactory', '2026-10-01 14:07:55.628979+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('58010192-0f93-4070-bf91-7f295b6fe20b', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '8f574cd6-62ea-4dd4-8165-d3c411b220b8', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'Midterm Examination 2024', 88.50, 100.00, 'Good conceptual clarity', '2026-10-01 14:07:55.62898+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('e28755fc-3a6e-41c4-a7c1-59020c814803', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '8f574cd6-62ea-4dd4-8165-d3c411b220b8', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'Midterm Examination 2024', 89.50, 100.00, 'Good conceptual clarity', '2026-10-01 14:07:55.62898+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('b99b4c39-de98-4c00-970c-1898d285dd74', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '1aac8640-517f-4334-9ffa-4dfa85cca0dd', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'Midterm Examination 2024', 98.50, 100.00, 'Good conceptual clarity', '2026-10-01 14:07:55.628981+00');
INSERT INTO public.grades (grade_id, college_id, student_id, course_id, faculty_id, assessment_name, score, max_score, remarks, graded_at) VALUES ('08c7d2b0-495b-4f22-8955-a9212ea89cad', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '1aac8640-517f-4334-9ffa-4dfa85cca0dd', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'Midterm Examination 2024', 84.50, 100.00, 'Good conceptual clarity', '2026-10-01 14:07:55.628981+00');


--
-- Data for Name: students; Type: TABLE DATA; Schema: public; Owner: edunexa_admin
--

INSERT INTO public.students (student_id, college_id, user_id, roll_number, first_name, last_name, enrollment_year, semester, created_at) VALUES ('d91be8a0-c589-4080-a507-14f8dfdd23b2', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '48a5d816-6975-4d4b-8578-755eb8115b63', 'APEX-2024-101', 'Aarav', 'Reddy', '2023', 'Sem 3', '2026-10-01 14:07:55.447704+00');
INSERT INTO public.students (student_id, college_id, user_id, roll_number, first_name, last_name, enrollment_year, semester, created_at) VALUES ('66978ac8-b94a-472f-98c7-012edb67c91b', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'ca1fbb42-c8aa-430f-9c82-c13d6824639f', 'APEX-2024-102', 'Aditi', 'Gupta', '2022', 'Sem 5', '2026-10-01 14:07:55.45067+00');
INSERT INTO public.students (student_id, college_id, user_id, roll_number, first_name, last_name, enrollment_year, semester, created_at) VALUES ('d24111ba-f892-4a39-a392-85e81eb9132c', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '245f59ed-2975-433d-9231-fb8561811f25', 'APEX-2024-103', 'Rohan', 'Mehta', '2024', 'Sem 1', '2026-10-01 14:07:55.452102+00');
INSERT INTO public.students (student_id, college_id, user_id, roll_number, first_name, last_name, enrollment_year, semester, created_at) VALUES ('b53d8f73-83df-4762-b522-a445d9933f63', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '652c9469-6b8d-4be1-bdb6-46f8b00d8683', 'APEX-2024-104', 'Priya', 'Iyer', '2023', 'Sem 3', '2026-10-01 14:07:55.453454+00');
INSERT INTO public.students (student_id, college_id, user_id, roll_number, first_name, last_name, enrollment_year, semester, created_at) VALUES ('b278f61a-13eb-41c1-99d5-2110b3a1bcc5', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '00b7fa1f-8c61-4269-ba9c-c250f08f3d08', 'APEX-2024-105', 'Ananya', 'Nair', '2022', 'Sem 5', '2026-10-01 14:07:55.454773+00');
INSERT INTO public.students (student_id, college_id, user_id, roll_number, first_name, last_name, enrollment_year, semester, created_at) VALUES ('4c6bc0c4-345d-423e-952f-fbd00e9abe3d', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '00050f49-2744-4aae-8dca-4aba6b4da94f', 'APEX-2024-106', 'Vikram', 'Singh', '2024', 'Sem 1', '2026-10-01 14:07:55.456247+00');
INSERT INTO public.students (student_id, college_id, user_id, roll_number, first_name, last_name, enrollment_year, semester, created_at) VALUES ('a7a87c91-31e1-4c95-9071-39b742346013', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '790dfbca-d1d8-40a7-9baa-272f518a45c1', 'APEX-2024-107', 'Neha', 'Chauhan', '2023', 'Sem 3', '2026-10-01 14:07:55.458662+00');
INSERT INTO public.students (student_id, college_id, user_id, roll_number, first_name, last_name, enrollment_year, semester, created_at) VALUES ('535e3192-51ae-4e6e-90cf-473b1f0db55c', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '7dd37663-ac81-4322-90e6-7c21df325edb', 'APEX-2024-108', 'Rahul', 'Deshmukh', '2022', 'Sem 5', '2026-10-01 14:07:55.460399+00');
INSERT INTO public.students (student_id, college_id, user_id, roll_number, first_name, last_name, enrollment_year, semester, created_at) VALUES ('169a3258-9e01-4b90-ace8-66be170c035f', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '2d983437-8361-46c4-9df3-ec6efb8bad49', 'APEX-2024-109', 'Sneha', 'Kulkarni', '2024', 'Sem 1', '2026-10-01 14:07:55.46176+00');
INSERT INTO public.students (student_id, college_id, user_id, roll_number, first_name, last_name, enrollment_year, semester, created_at) VALUES ('a13e1758-df90-4ef6-b7b7-664b5c273eca', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '13f4d2dd-ed25-4ca9-ae76-d392264fc173', 'APEX-2024-110', 'Karan', 'Bhat', '2023', 'Sem 3', '2026-10-01 14:07:55.463093+00');
INSERT INTO public.students (student_id, college_id, user_id, roll_number, first_name, last_name, enrollment_year, semester, created_at) VALUES ('4cf325fa-5154-4620-a4fc-049776c9e6b6', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '8e83d186-8097-4115-b39f-f670924c6284', 'APEX-2024-111', 'Pooja', 'Rao', '2022', 'Sem 5', '2026-10-01 14:07:55.464402+00');
INSERT INTO public.students (student_id, college_id, user_id, roll_number, first_name, last_name, enrollment_year, semester, created_at) VALUES ('03ac1155-58c5-4b44-b605-4ccaf8d6a02d', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'fec465ec-252d-4a11-8c66-f0beab419d22', 'APEX-2024-112', 'Arjun', 'Joshi', '2024', 'Sem 1', '2026-10-01 14:07:55.465859+00');
INSERT INTO public.students (student_id, college_id, user_id, roll_number, first_name, last_name, enrollment_year, semester, created_at) VALUES ('fdeb06a3-74da-4120-bc71-653085b7aea0', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '2f32dcc6-00c3-49da-b597-5928de59d82d', 'APEX-2024-113', 'Kavya', 'Kapoor', '2023', 'Sem 3', '2026-10-01 14:07:55.467248+00');
INSERT INTO public.students (student_id, college_id, user_id, roll_number, first_name, last_name, enrollment_year, semester, created_at) VALUES ('fc0f5eed-999f-4329-8368-17737a95e148', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'ce3df62f-11fd-421b-9af3-d00bd14bfa31', 'APEX-2024-114', 'Siddharth', 'Malhotra', '2022', 'Sem 5', '2026-10-01 14:07:55.468524+00');
INSERT INTO public.students (student_id, college_id, user_id, roll_number, first_name, last_name, enrollment_year, semester, created_at) VALUES ('44da7ddf-963f-4685-8d4b-f09eb6900c65', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'afbd20db-63a5-4a8d-a699-962a30f77b97', 'APEX-2024-115', 'Divya', 'Saxena', '2024', 'Sem 1', '2026-10-01 14:07:55.469764+00');
INSERT INTO public.students (student_id, college_id, user_id, roll_number, first_name, last_name, enrollment_year, semester, created_at) VALUES ('487eef9d-7e83-44ff-ba05-5633563d482c', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '6bf6db62-dc37-4df6-829e-46530867abcc', 'APEX-2024-116', 'Varun', 'Choudhury', '2023', 'Sem 3', '2026-10-01 14:07:55.470983+00');
INSERT INTO public.students (student_id, college_id, user_id, roll_number, first_name, last_name, enrollment_year, semester, created_at) VALUES ('3c246328-8187-4c8f-8785-1fbc652f0b34', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'd14a4d30-cf54-4e6c-a905-5b4d727eea51', 'APEX-2024-117', 'Meera', 'Menon', '2022', 'Sem 5', '2026-10-01 14:07:55.472368+00');
INSERT INTO public.students (student_id, college_id, user_id, roll_number, first_name, last_name, enrollment_year, semester, created_at) VALUES ('09c8b7bd-6217-42a5-ab71-19de2a0f887c', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '6a3a7065-0183-4537-85bb-00a9eb17614e', 'APEX-2024-118', 'Aditya', 'Banerjee', '2024', 'Sem 1', '2026-10-01 14:07:55.473888+00');
INSERT INTO public.students (student_id, college_id, user_id, roll_number, first_name, last_name, enrollment_year, semester, created_at) VALUES ('8a408aa6-acc8-4897-96a9-219db1fa2552', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'a9736f18-9c3c-421f-aafd-d7239d1564d1', 'APEX-2024-119', 'Rhea', 'Chatterjee', '2023', 'Sem 3', '2026-10-01 14:07:55.475718+00');
INSERT INTO public.students (student_id, college_id, user_id, roll_number, first_name, last_name, enrollment_year, semester, created_at) VALUES ('cd824327-8e9e-4e04-8d37-3de8f110cda1', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '9996c81b-98a8-409e-b760-302b4fb63976', 'APEX-2024-120', 'Manish', 'Mishra', '2022', 'Sem 5', '2026-10-01 14:07:55.477309+00');
INSERT INTO public.students (student_id, college_id, user_id, roll_number, first_name, last_name, enrollment_year, semester, created_at) VALUES ('aeafaeb3-92d4-4889-9cab-23453afefb31', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'f2596b62-e777-4632-a36c-69680da30757', 'APEX-2024-121', 'Tanvi', 'Pandey', '2024', 'Sem 1', '2026-10-01 14:07:55.478846+00');
INSERT INTO public.students (student_id, college_id, user_id, roll_number, first_name, last_name, enrollment_year, semester, created_at) VALUES ('4276399b-c86e-48fa-8165-70f0968bc730', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'fef2b46e-0f5b-4088-b27f-c36240ac6696', 'APEX-2024-122', 'Gaurav', 'Sharma', '2023', 'Sem 3', '2026-10-01 14:07:55.480393+00');
INSERT INTO public.students (student_id, college_id, user_id, roll_number, first_name, last_name, enrollment_year, semester, created_at) VALUES ('8754eeda-ec00-4dfc-a714-3f667eb1b492', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '7af689d9-6d41-49de-94d7-742774940c41', 'APEX-2024-123', 'Isha', 'Verma', '2022', 'Sem 5', '2026-10-01 14:07:55.481816+00');
INSERT INTO public.students (student_id, college_id, user_id, roll_number, first_name, last_name, enrollment_year, semester, created_at) VALUES ('9851826b-3a5e-47ab-a7b6-6bda495e7d74', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '0a496d74-62c0-4754-b231-61e09ecaa1a2', 'APEX-2024-124', 'Nikhil', 'Patel', '2024', 'Sem 1', '2026-10-01 14:07:55.483262+00');
INSERT INTO public.students (student_id, college_id, user_id, roll_number, first_name, last_name, enrollment_year, semester, created_at) VALUES ('dc3ce680-65f9-4f03-a7da-e652279761c3', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'aab51903-2680-4610-a2a7-5d43d6919908', 'APEX-2024-125', 'Swati', 'Reddy', '2023', 'Sem 3', '2026-10-01 14:07:55.484753+00');
INSERT INTO public.students (student_id, college_id, user_id, roll_number, first_name, last_name, enrollment_year, semester, created_at) VALUES ('71aaa9bd-e82a-4900-a620-67ff94d964e4', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '74480686-d83b-4355-b004-932e6ac77b61', 'HORIZON-2024-101', 'Harsh', 'Gupta', '2023', 'Sem 3', '2026-10-01 14:07:55.486106+00');
INSERT INTO public.students (student_id, college_id, user_id, roll_number, first_name, last_name, enrollment_year, semester, created_at) VALUES ('c64aa5ae-72f6-4039-882d-500a2910f82a', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'abbae22d-1c6a-46bb-b828-deb25de409d0', 'HORIZON-2024-102', 'Simran', 'Mehta', '2022', 'Sem 5', '2026-10-01 14:07:55.487563+00');
INSERT INTO public.students (student_id, college_id, user_id, roll_number, first_name, last_name, enrollment_year, semester, created_at) VALUES ('87d56bfa-b1a5-4bba-bf20-2de8f4aaed2d', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '3857e0f0-42e1-42de-993a-acfef7a99938', 'HORIZON-2024-103', 'Akash', 'Iyer', '2024', 'Sem 1', '2026-10-01 14:07:55.489025+00');
INSERT INTO public.students (student_id, college_id, user_id, roll_number, first_name, last_name, enrollment_year, semester, created_at) VALUES ('074ca893-80f4-4ea5-8556-d2b9be73b57f', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '4570c249-e6de-421a-bfef-c2cfd2c09509', 'HORIZON-2024-104', 'Ritu', 'Nair', '2023', 'Sem 3', '2026-10-01 14:07:55.490661+00');
INSERT INTO public.students (student_id, college_id, user_id, roll_number, first_name, last_name, enrollment_year, semester, created_at) VALUES ('9c4cc771-5fbf-4ed3-9d79-90bc19db71bd', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '61e49ce0-a85e-42f6-9faf-3a19ed3b3c3d', 'HORIZON-2024-105', 'Dev', 'Singh', '2022', 'Sem 5', '2026-10-01 14:07:55.49281+00');
INSERT INTO public.students (student_id, college_id, user_id, roll_number, first_name, last_name, enrollment_year, semester, created_at) VALUES ('822f260b-d92f-4caf-b5f4-2c612e7ae673', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '011504eb-042a-4591-9575-415986f8f3ce', 'HORIZON-2024-106', 'Payal', 'Chauhan', '2024', 'Sem 1', '2026-10-01 14:07:55.494417+00');
INSERT INTO public.students (student_id, college_id, user_id, roll_number, first_name, last_name, enrollment_year, semester, created_at) VALUES ('0ade34fc-97f5-4862-ae56-6955897e6e52', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '936628b4-8d8d-46ab-94ab-abd34fc0f2e5', 'HORIZON-2024-107', 'Amit', 'Deshmukh', '2023', 'Sem 3', '2026-10-01 14:07:55.495864+00');
INSERT INTO public.students (student_id, college_id, user_id, roll_number, first_name, last_name, enrollment_year, semester, created_at) VALUES ('e3eb2c1a-0420-4d7e-84d5-483831168795', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '44ea36f2-2a50-4771-bbf0-cedf4fe8f87b', 'HORIZON-2024-108', 'Shruti', 'Kulkarni', '2022', 'Sem 5', '2026-10-01 14:07:55.498125+00');
INSERT INTO public.students (student_id, college_id, user_id, roll_number, first_name, last_name, enrollment_year, semester, created_at) VALUES ('3f360886-48d8-4ae6-8198-2eda870872a0', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '891077ae-99c5-492d-86cc-b373f28b5b84', 'HORIZON-2024-109', 'Suresh', 'Bhat', '2024', 'Sem 1', '2026-10-01 14:07:55.499523+00');
INSERT INTO public.students (student_id, college_id, user_id, roll_number, first_name, last_name, enrollment_year, semester, created_at) VALUES ('db150926-30fe-438c-ad52-bae56bf264a4', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '6cdea7a7-6ef9-41ff-b599-2ce5b99029e2', 'HORIZON-2024-110', 'Shweta', 'Rao', '2023', 'Sem 3', '2026-10-01 14:07:55.500905+00');
INSERT INTO public.students (student_id, college_id, user_id, roll_number, first_name, last_name, enrollment_year, semester, created_at) VALUES ('98d26b99-1717-4c95-839d-0925c0d5b707', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '42ec3fe3-81a7-4db0-8a89-5e4ab6588a2c', 'HORIZON-2024-111', 'Raj', 'Joshi', '2022', 'Sem 5', '2026-10-01 14:07:55.502247+00');
INSERT INTO public.students (student_id, college_id, user_id, roll_number, first_name, last_name, enrollment_year, semester, created_at) VALUES ('afd5a403-53e9-4742-a84c-931bd047a5a6', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'e95e4c84-e06e-4b03-9e96-a5d011c70c8b', 'HORIZON-2024-112', 'Komal', 'Kapoor', '2024', 'Sem 1', '2026-10-01 14:07:55.503506+00');
INSERT INTO public.students (student_id, college_id, user_id, roll_number, first_name, last_name, enrollment_year, semester, created_at) VALUES ('937c027a-cff8-4739-af56-462c021e612f', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'bb0c0242-9787-4965-ac88-912799dce370', 'HORIZON-2024-113', 'Deepak', 'Malhotra', '2023', 'Sem 3', '2026-10-01 14:07:55.504719+00');
INSERT INTO public.students (student_id, college_id, user_id, roll_number, first_name, last_name, enrollment_year, semester, created_at) VALUES ('3242e419-6976-4b15-9cfb-088e13b3ddfe', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '833ea7b2-8652-4a06-8a6e-c8082b182618', 'HORIZON-2024-114', 'Sunita', 'Saxena', '2022', 'Sem 5', '2026-10-01 14:07:55.505928+00');
INSERT INTO public.students (student_id, college_id, user_id, roll_number, first_name, last_name, enrollment_year, semester, created_at) VALUES ('b123200c-4226-4092-9fea-a2c9ad5d3d5b', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '74684551-e1bc-4bec-b9d9-ab4ac2176d5f', 'HORIZON-2024-115', 'Vishal', 'Choudhury', '2024', 'Sem 1', '2026-10-01 14:07:55.507524+00');
INSERT INTO public.students (student_id, college_id, user_id, roll_number, first_name, last_name, enrollment_year, semester, created_at) VALUES ('db794458-90cc-4c01-b8de-9e6e5eb71af1', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '66df01b0-9b3d-4f48-93c0-5d6d96740937', 'HORIZON-2024-116', 'Tara', 'Menon', '2023', 'Sem 3', '2026-10-01 14:07:55.509189+00');
INSERT INTO public.students (student_id, college_id, user_id, roll_number, first_name, last_name, enrollment_year, semester, created_at) VALUES ('2d65c079-20d2-4f92-8c9d-93175fffda44', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'eb94d76b-3a38-4855-bea0-cb51fc8fa7fd', 'HORIZON-2024-117', 'Mayank', 'Banerjee', '2022', 'Sem 5', '2026-10-01 14:07:55.510697+00');
INSERT INTO public.students (student_id, college_id, user_id, roll_number, first_name, last_name, enrollment_year, semester, created_at) VALUES ('62f68269-f2ce-478c-8eaa-7e3271ec8492', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'af8b45d7-4552-4d50-b811-0ffc134b8eea', 'HORIZON-2024-118', 'Pallavi', 'Chatterjee', '2024', 'Sem 1', '2026-10-01 14:07:55.51207+00');
INSERT INTO public.students (student_id, college_id, user_id, roll_number, first_name, last_name, enrollment_year, semester, created_at) VALUES ('9df10543-26a7-4877-a1bc-ddb48e8792a5', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '80c3e0f1-0733-48a4-b3ac-85716aab845c', 'HORIZON-2024-119', 'Sameer', 'Mishra', '2023', 'Sem 3', '2026-10-01 14:07:55.513386+00');
INSERT INTO public.students (student_id, college_id, user_id, roll_number, first_name, last_name, enrollment_year, semester, created_at) VALUES ('1aad71cc-7350-40c4-8e73-a71b0cca63b0', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '5c652a50-36de-433f-92e5-6e48b7c1823e', 'HORIZON-2024-120', 'Geeta', 'Pandey', '2022', 'Sem 5', '2026-10-01 14:07:55.514675+00');
INSERT INTO public.students (student_id, college_id, user_id, roll_number, first_name, last_name, enrollment_year, semester, created_at) VALUES ('c71667dd-879d-4fef-b0cd-79d29591b0fd', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '618fa3d8-2770-4ef1-b447-4720832345e5', 'HORIZON-2024-121', 'Abhishek', 'Sharma', '2024', 'Sem 1', '2026-10-01 14:07:55.516092+00');
INSERT INTO public.students (student_id, college_id, user_id, roll_number, first_name, last_name, enrollment_year, semester, created_at) VALUES ('8d6c7b94-6c9b-4feb-9325-d0041a7ed3af', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '34cfe50c-1299-4467-9f1d-f42b0029881b', 'HORIZON-2024-122', 'Kritika', 'Verma', '2023', 'Sem 3', '2026-10-01 14:07:55.517355+00');
INSERT INTO public.students (student_id, college_id, user_id, roll_number, first_name, last_name, enrollment_year, semester, created_at) VALUES ('99bcb5e7-1a64-469e-b3d0-e1c732109f0a', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '0b094a09-db56-4a7b-b238-c7a6be0530c5', 'HORIZON-2024-123', 'Alok', 'Patel', '2022', 'Sem 5', '2026-10-01 14:07:55.518565+00');
INSERT INTO public.students (student_id, college_id, user_id, roll_number, first_name, last_name, enrollment_year, semester, created_at) VALUES ('8f574cd6-62ea-4dd4-8165-d3c411b220b8', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'c87c7a3e-be10-4bf6-bdf7-4d6b132fb21a', 'HORIZON-2024-124', 'Bhavna', 'Reddy', '2024', 'Sem 1', '2026-10-01 14:07:55.519726+00');
INSERT INTO public.students (student_id, college_id, user_id, roll_number, first_name, last_name, enrollment_year, semester, created_at) VALUES ('1aac8640-517f-4334-9ffa-4dfa85cca0dd', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '1366dfbf-94db-46b6-8ecc-7a11456dc1a5', 'HORIZON-2024-125', 'Kunal', 'Gupta', '2023', 'Sem 3', '2026-10-01 14:07:55.520306+00');


--
-- Data for Name: timetable; Type: TABLE DATA; Schema: public; Owner: edunexa_admin
--

INSERT INTO public.timetable (timetable_id, college_id, course_id, faculty_id, day_of_week, start_time, end_time, room_number) VALUES ('fdda8a06-d853-4797-a59e-3519a11af932', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'ed911e71-dea5-4896-a6f6-5b943628dbbb', '616d5366-a221-4453-9443-fdc767fb95fb', 'MONDAY', '09:00:00', '10:30:00', 'Lecture Hall A-101');
INSERT INTO public.timetable (timetable_id, college_id, course_id, faculty_id, day_of_week, start_time, end_time, room_number) VALUES ('44cbce0f-1033-49c0-bfb7-3b53bcd9ea04', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'e64f4d99-4d3a-48bf-bc08-78ff381948db', '91b41366-50ee-4f8e-b21f-d7fa7f0adac2', 'TUESDAY', '11:00:00', '12:30:00', 'Lab 203');
INSERT INTO public.timetable (timetable_id, college_id, course_id, faculty_id, day_of_week, start_time, end_time, room_number) VALUES ('516d3692-57c7-4ab7-9e0e-99161d249ce1', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '2353386e-f081-41a6-9acb-36523f07448a', 'ebfb52fe-6eb1-4b18-9d85-87e28faf36fa', 'WEDNESDAY', '14:00:00', '15:30:00', 'Room 304');
INSERT INTO public.timetable (timetable_id, college_id, course_id, faculty_id, day_of_week, start_time, end_time, room_number) VALUES ('f6701f23-49f7-412e-aaf6-ef524b432bd1', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '3cbb2009-12af-42cc-a809-d3f4e9cf6fa8', 'e9a0cabe-6409-4152-b0dc-883cef5e0cad', 'THURSDAY', '09:00:00', '10:30:00', 'Auditorium 1');
INSERT INTO public.timetable (timetable_id, college_id, course_id, faculty_id, day_of_week, start_time, end_time, room_number) VALUES ('9d070230-7da2-4101-9b0c-66b112d73f5d', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', '9a5913dd-4485-420e-80a9-7ebaa12a550c', 'ad73351c-bf89-4702-b749-df50fb5eba9a', 'FRIDAY', '11:00:00', '12:30:00', 'Tech Lab B');
INSERT INTO public.timetable (timetable_id, college_id, course_id, faculty_id, day_of_week, start_time, end_time, room_number) VALUES ('5d560459-18ef-4f43-8bbe-5668d45e7855', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'ce1e25f8-aa32-4583-9e7e-25f94a894ca2', '616d5366-a221-4453-9443-fdc767fb95fb', 'MONDAY', '14:00:00', '15:30:00', 'Lecture Hall A-101');
INSERT INTO public.timetable (timetable_id, college_id, course_id, faculty_id, day_of_week, start_time, end_time, room_number) VALUES ('e310c628-a74a-4114-bde6-ceb35d5b17e3', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'f93531b6-6d9f-4f59-bcb3-ae57d8efc2ff', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'MONDAY', '09:00:00', '10:30:00', 'Lecture Hall A-101');
INSERT INTO public.timetable (timetable_id, college_id, course_id, faculty_id, day_of_week, start_time, end_time, room_number) VALUES ('b495b3dc-2148-4038-9c0b-f8176aabc655', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '0af8e7ab-4c82-4a1f-bbde-6742fff408a5', '2250c28f-e303-4468-9a97-1f156bd367a2', 'TUESDAY', '11:00:00', '12:30:00', 'Lab 203');
INSERT INTO public.timetable (timetable_id, college_id, course_id, faculty_id, day_of_week, start_time, end_time, room_number) VALUES ('c630abd2-3de8-41f4-86cb-9c3c32a84d73', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '766f6d65-d163-4121-81b5-1167e84d8176', '2c59b27d-49b6-4b00-b43b-663cfb61cfe3', 'WEDNESDAY', '14:00:00', '15:30:00', 'Room 304');
INSERT INTO public.timetable (timetable_id, college_id, course_id, faculty_id, day_of_week, start_time, end_time, room_number) VALUES ('c441adbe-ebc0-49eb-b6e4-a09bad3ad72e', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '02fbcbc6-d3a1-48eb-9f4f-dddeb49c0eb1', 'cb636a9c-a484-42a0-a0c9-d494ae5b816f', 'THURSDAY', '09:00:00', '10:30:00', 'Auditorium 1');
INSERT INTO public.timetable (timetable_id, college_id, course_id, faculty_id, day_of_week, start_time, end_time, room_number) VALUES ('d4e3e77d-75c5-4d60-905b-2acb226cd4d1', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '3dc4c150-7432-4cc4-897e-5aecfdaa4825', '5cb1dbf1-af43-4276-9cd1-5f8a676a2503', 'FRIDAY', '11:00:00', '12:30:00', 'Tech Lab B');
INSERT INTO public.timetable (timetable_id, college_id, course_id, faculty_id, day_of_week, start_time, end_time, room_number) VALUES ('92dc083b-3e26-4a82-861c-8b094abe97b9', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', '63444ba5-7d8a-47fd-b7a6-e07b44433311', '535ee669-c190-4ff6-bd43-2d93d325feb3', 'MONDAY', '14:00:00', '15:30:00', 'Lecture Hall A-101');


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: edunexa_admin
--

INSERT INTO public.users (user_id, college_id, email, password_hash, role, is_active, created_at, updated_at) VALUES ('4cfe136a-1566-4f2e-91f9-1515dccaa298', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'admin@apex.edunexa.edu', '$2b$12$e8Y5t1hWz7M1r3B7.X7YuuN5U5zM2i0kM5fB4kXpWn/6z5YV3aW8m', 'ADMIN', true, '2026-10-01 14:07:55.417181+00', '2026-10-01 14:07:55.417183+00');
INSERT INTO public.users (user_id, college_id, email, password_hash, role, is_active, created_at, updated_at) VALUES ('4e6fa60d-5767-4ea7-8204-8007becd2746', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'admin@horizon.edunexa.edu', '$2b$12$e8Y5t1hWz7M1r3B7.X7YuuN5U5zM2i0kM5fB4kXpWn/6z5YV3aW8m', 'ADMIN', true, '2026-10-01 14:07:55.420116+00', '2026-10-01 14:07:55.420119+00');
INSERT INTO public.users (user_id, college_id, email, password_hash, role, is_active, created_at, updated_at) VALUES ('008bbe33-c477-468b-97ba-076f6a0074a3', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'rajesh.nambiar@apex.edunexa.edu', '$2b$12$e8Y5t1hWz7M1r3B7.X7YuuN5U5zM2i0kM5fB4kXpWn/6z5YV3aW8m', 'FACULTY', true, '2026-10-01 14:07:55.427953+00', '2026-10-01 14:07:55.427955+00');
INSERT INTO public.users (user_id, college_id, email, password_hash, role, is_active, created_at, updated_at) VALUES ('70fa4209-d390-4366-a09f-93fd36406080', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'sunita.raman@apex.edunexa.edu', '$2b$12$e8Y5t1hWz7M1r3B7.X7YuuN5U5zM2i0kM5fB4kXpWn/6z5YV3aW8m', 'FACULTY', true, '2026-10-01 14:07:55.429205+00', '2026-10-01 14:07:55.429206+00');
INSERT INTO public.users (user_id, college_id, email, password_hash, role, is_active, created_at, updated_at) VALUES ('1e347a19-aa04-45ab-bb93-54243c4749eb', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'amit.deshmukh@apex.edunexa.edu', '$2b$12$e8Y5t1hWz7M1r3B7.X7YuuN5U5zM2i0kM5fB4kXpWn/6z5YV3aW8m', 'FACULTY', true, '2026-10-01 14:07:55.432188+00', '2026-10-01 14:07:55.432189+00');
INSERT INTO public.users (user_id, college_id, email, password_hash, role, is_active, created_at, updated_at) VALUES ('016be7c9-9f12-49ed-ae85-456cb332171c', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'kavita.menon@apex.edunexa.edu', '$2b$12$e8Y5t1hWz7M1r3B7.X7YuuN5U5zM2i0kM5fB4kXpWn/6z5YV3aW8m', 'FACULTY', true, '2026-10-01 14:07:55.434033+00', '2026-10-01 14:07:55.434035+00');
INSERT INTO public.users (user_id, college_id, email, password_hash, role, is_active, created_at, updated_at) VALUES ('7fe0df9b-f846-4842-b449-f637a34bed37', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'ramesh.pawar@apex.edunexa.edu', '$2b$12$e8Y5t1hWz7M1r3B7.X7YuuN5U5zM2i0kM5fB4kXpWn/6z5YV3aW8m', 'FACULTY', true, '2026-10-01 14:07:55.435677+00', '2026-10-01 14:07:55.435678+00');
INSERT INTO public.users (user_id, college_id, email, password_hash, role, is_active, created_at, updated_at) VALUES ('ede481cf-34f8-4415-aa15-d8966ea70019', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'alistair.crawford@horizon.edunexa.edu', '$2b$12$e8Y5t1hWz7M1r3B7.X7YuuN5U5zM2i0kM5fB4kXpWn/6z5YV3aW8m', 'FACULTY', true, '2026-10-01 14:07:55.437114+00', '2026-10-01 14:07:55.437115+00');
INSERT INTO public.users (user_id, college_id, email, password_hash, role, is_active, created_at, updated_at) VALUES ('083ada4c-8c3f-4f11-bf06-ef2f38be7710', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'sarah.jenkins@horizon.edunexa.edu', '$2b$12$e8Y5t1hWz7M1r3B7.X7YuuN5U5zM2i0kM5fB4kXpWn/6z5YV3aW8m', 'FACULTY', true, '2026-10-01 14:07:55.438577+00', '2026-10-01 14:07:55.438579+00');
INSERT INTO public.users (user_id, college_id, email, password_hash, role, is_active, created_at, updated_at) VALUES ('063f1291-8bc0-4854-86e9-c70da56cdff3', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'marcus.vaughn@horizon.edunexa.edu', '$2b$12$e8Y5t1hWz7M1r3B7.X7YuuN5U5zM2i0kM5fB4kXpWn/6z5YV3aW8m', 'FACULTY', true, '2026-10-01 14:07:55.440029+00', '2026-10-01 14:07:55.440031+00');
INSERT INTO public.users (user_id, college_id, email, password_hash, role, is_active, created_at, updated_at) VALUES ('19002895-0aa1-4b8c-bf5f-335f4df424ff', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'elena.rostova@horizon.edunexa.edu', '$2b$12$e8Y5t1hWz7M1r3B7.X7YuuN5U5zM2i0kM5fB4kXpWn/6z5YV3aW8m', 'FACULTY', true, '2026-10-01 14:07:55.442103+00', '2026-10-01 14:07:55.442105+00');
INSERT INTO public.users (user_id, college_id, email, password_hash, role, is_active, created_at, updated_at) VALUES ('26e41dd3-f32d-4598-bc36-29b6c3dd647c', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'david.kim@horizon.edunexa.edu', '$2b$12$e8Y5t1hWz7M1r3B7.X7YuuN5U5zM2i0kM5fB4kXpWn/6z5YV3aW8m', 'FACULTY', true, '2026-10-01 14:07:55.443704+00', '2026-10-01 14:07:55.443706+00');
INSERT INTO public.users (user_id, college_id, email, password_hash, role, is_active, created_at, updated_at) VALUES ('48a5d816-6975-4d4b-8578-755eb8115b63', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'aarav.reddy1@apex.edunexa.edu', '$2b$12$e8Y5t1hWz7M1r3B7.X7YuuN5U5zM2i0kM5fB4kXpWn/6z5YV3aW8m', 'STUDENT', true, '2026-10-01 14:07:55.445806+00', '2026-10-01 14:07:55.445808+00');
INSERT INTO public.users (user_id, college_id, email, password_hash, role, is_active, created_at, updated_at) VALUES ('ca1fbb42-c8aa-430f-9c82-c13d6824639f', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'aditi.gupta2@apex.edunexa.edu', '$2b$12$e8Y5t1hWz7M1r3B7.X7YuuN5U5zM2i0kM5fB4kXpWn/6z5YV3aW8m', 'STUDENT', true, '2026-10-01 14:07:55.446721+00', '2026-10-01 14:07:55.446722+00');
INSERT INTO public.users (user_id, college_id, email, password_hash, role, is_active, created_at, updated_at) VALUES ('245f59ed-2975-433d-9231-fb8561811f25', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'rohan.mehta3@apex.edunexa.edu', '$2b$12$e8Y5t1hWz7M1r3B7.X7YuuN5U5zM2i0kM5fB4kXpWn/6z5YV3aW8m', 'STUDENT', true, '2026-10-01 14:07:55.450015+00', '2026-10-01 14:07:55.450017+00');
INSERT INTO public.users (user_id, college_id, email, password_hash, role, is_active, created_at, updated_at) VALUES ('652c9469-6b8d-4be1-bdb6-46f8b00d8683', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'priya.iyer4@apex.edunexa.edu', '$2b$12$e8Y5t1hWz7M1r3B7.X7YuuN5U5zM2i0kM5fB4kXpWn/6z5YV3aW8m', 'STUDENT', true, '2026-10-01 14:07:55.451506+00', '2026-10-01 14:07:55.451507+00');
INSERT INTO public.users (user_id, college_id, email, password_hash, role, is_active, created_at, updated_at) VALUES ('00b7fa1f-8c61-4269-ba9c-c250f08f3d08', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'ananya.nair5@apex.edunexa.edu', '$2b$12$e8Y5t1hWz7M1r3B7.X7YuuN5U5zM2i0kM5fB4kXpWn/6z5YV3aW8m', 'STUDENT', true, '2026-10-01 14:07:55.452896+00', '2026-10-01 14:07:55.452898+00');
INSERT INTO public.users (user_id, college_id, email, password_hash, role, is_active, created_at, updated_at) VALUES ('00050f49-2744-4aae-8dca-4aba6b4da94f', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'vikram.singh6@apex.edunexa.edu', '$2b$12$e8Y5t1hWz7M1r3B7.X7YuuN5U5zM2i0kM5fB4kXpWn/6z5YV3aW8m', 'STUDENT', true, '2026-10-01 14:07:55.454204+00', '2026-10-01 14:07:55.454206+00');
INSERT INTO public.users (user_id, college_id, email, password_hash, role, is_active, created_at, updated_at) VALUES ('790dfbca-d1d8-40a7-9baa-272f518a45c1', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'neha.chauhan7@apex.edunexa.edu', '$2b$12$e8Y5t1hWz7M1r3B7.X7YuuN5U5zM2i0kM5fB4kXpWn/6z5YV3aW8m', 'STUDENT', true, '2026-10-01 14:07:55.455537+00', '2026-10-01 14:07:55.455538+00');
INSERT INTO public.users (user_id, college_id, email, password_hash, role, is_active, created_at, updated_at) VALUES ('7dd37663-ac81-4322-90e6-7c21df325edb', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'rahul.deshmukh8@apex.edunexa.edu', '$2b$12$e8Y5t1hWz7M1r3B7.X7YuuN5U5zM2i0kM5fB4kXpWn/6z5YV3aW8m', 'STUDENT', true, '2026-10-01 14:07:55.457648+00', '2026-10-01 14:07:55.45765+00');
INSERT INTO public.users (user_id, college_id, email, password_hash, role, is_active, created_at, updated_at) VALUES ('2d983437-8361-46c4-9df3-ec6efb8bad49', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'sneha.kulkarni9@apex.edunexa.edu', '$2b$12$e8Y5t1hWz7M1r3B7.X7YuuN5U5zM2i0kM5fB4kXpWn/6z5YV3aW8m', 'STUDENT', true, '2026-10-01 14:07:55.459769+00', '2026-10-01 14:07:55.459771+00');
INSERT INTO public.users (user_id, college_id, email, password_hash, role, is_active, created_at, updated_at) VALUES ('13f4d2dd-ed25-4ca9-ae76-d392264fc173', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'karan.bhat10@apex.edunexa.edu', '$2b$12$e8Y5t1hWz7M1r3B7.X7YuuN5U5zM2i0kM5fB4kXpWn/6z5YV3aW8m', 'STUDENT', true, '2026-10-01 14:07:55.461205+00', '2026-10-01 14:07:55.461206+00');
INSERT INTO public.users (user_id, college_id, email, password_hash, role, is_active, created_at, updated_at) VALUES ('8e83d186-8097-4115-b39f-f670924c6284', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'pooja.rao11@apex.edunexa.edu', '$2b$12$e8Y5t1hWz7M1r3B7.X7YuuN5U5zM2i0kM5fB4kXpWn/6z5YV3aW8m', 'STUDENT', true, '2026-10-01 14:07:55.462546+00', '2026-10-01 14:07:55.462548+00');
INSERT INTO public.users (user_id, college_id, email, password_hash, role, is_active, created_at, updated_at) VALUES ('fec465ec-252d-4a11-8c66-f0beab419d22', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'arjun.joshi12@apex.edunexa.edu', '$2b$12$e8Y5t1hWz7M1r3B7.X7YuuN5U5zM2i0kM5fB4kXpWn/6z5YV3aW8m', 'STUDENT', true, '2026-10-01 14:07:55.463842+00', '2026-10-01 14:07:55.463843+00');
INSERT INTO public.users (user_id, college_id, email, password_hash, role, is_active, created_at, updated_at) VALUES ('2f32dcc6-00c3-49da-b597-5928de59d82d', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'kavya.kapoor13@apex.edunexa.edu', '$2b$12$e8Y5t1hWz7M1r3B7.X7YuuN5U5zM2i0kM5fB4kXpWn/6z5YV3aW8m', 'STUDENT', true, '2026-10-01 14:07:55.465268+00', '2026-10-01 14:07:55.46527+00');
INSERT INTO public.users (user_id, college_id, email, password_hash, role, is_active, created_at, updated_at) VALUES ('ce3df62f-11fd-421b-9af3-d00bd14bfa31', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'siddharth.malhotra14@apex.edunexa.edu', '$2b$12$e8Y5t1hWz7M1r3B7.X7YuuN5U5zM2i0kM5fB4kXpWn/6z5YV3aW8m', 'STUDENT', true, '2026-10-01 14:07:55.466665+00', '2026-10-01 14:07:55.466667+00');
INSERT INTO public.users (user_id, college_id, email, password_hash, role, is_active, created_at, updated_at) VALUES ('afbd20db-63a5-4a8d-a699-962a30f77b97', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'divya.saxena15@apex.edunexa.edu', '$2b$12$e8Y5t1hWz7M1r3B7.X7YuuN5U5zM2i0kM5fB4kXpWn/6z5YV3aW8m', 'STUDENT', true, '2026-10-01 14:07:55.467966+00', '2026-10-01 14:07:55.467967+00');
INSERT INTO public.users (user_id, college_id, email, password_hash, role, is_active, created_at, updated_at) VALUES ('6bf6db62-dc37-4df6-829e-46530867abcc', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'varun.choudhury16@apex.edunexa.edu', '$2b$12$e8Y5t1hWz7M1r3B7.X7YuuN5U5zM2i0kM5fB4kXpWn/6z5YV3aW8m', 'STUDENT', true, '2026-10-01 14:07:55.469237+00', '2026-10-01 14:07:55.469239+00');
INSERT INTO public.users (user_id, college_id, email, password_hash, role, is_active, created_at, updated_at) VALUES ('d14a4d30-cf54-4e6c-a905-5b4d727eea51', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'meera.menon17@apex.edunexa.edu', '$2b$12$e8Y5t1hWz7M1r3B7.X7YuuN5U5zM2i0kM5fB4kXpWn/6z5YV3aW8m', 'STUDENT', true, '2026-10-01 14:07:55.47049+00', '2026-10-01 14:07:55.470491+00');
INSERT INTO public.users (user_id, college_id, email, password_hash, role, is_active, created_at, updated_at) VALUES ('6a3a7065-0183-4537-85bb-00a9eb17614e', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'aditya.banerjee18@apex.edunexa.edu', '$2b$12$e8Y5t1hWz7M1r3B7.X7YuuN5U5zM2i0kM5fB4kXpWn/6z5YV3aW8m', 'STUDENT', true, '2026-10-01 14:07:55.471828+00', '2026-10-01 14:07:55.471829+00');
INSERT INTO public.users (user_id, college_id, email, password_hash, role, is_active, created_at, updated_at) VALUES ('a9736f18-9c3c-421f-aafd-d7239d1564d1', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'rhea.chatterjee19@apex.edunexa.edu', '$2b$12$e8Y5t1hWz7M1r3B7.X7YuuN5U5zM2i0kM5fB4kXpWn/6z5YV3aW8m', 'STUDENT', true, '2026-10-01 14:07:55.47309+00', '2026-10-01 14:07:55.473092+00');
INSERT INTO public.users (user_id, college_id, email, password_hash, role, is_active, created_at, updated_at) VALUES ('9996c81b-98a8-409e-b760-302b4fb63976', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'manish.mishra20@apex.edunexa.edu', '$2b$12$e8Y5t1hWz7M1r3B7.X7YuuN5U5zM2i0kM5fB4kXpWn/6z5YV3aW8m', 'STUDENT', true, '2026-10-01 14:07:55.475021+00', '2026-10-01 14:07:55.475023+00');
INSERT INTO public.users (user_id, college_id, email, password_hash, role, is_active, created_at, updated_at) VALUES ('f2596b62-e777-4632-a36c-69680da30757', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'tanvi.pandey21@apex.edunexa.edu', '$2b$12$e8Y5t1hWz7M1r3B7.X7YuuN5U5zM2i0kM5fB4kXpWn/6z5YV3aW8m', 'STUDENT', true, '2026-10-01 14:07:55.476661+00', '2026-10-01 14:07:55.476663+00');
INSERT INTO public.users (user_id, college_id, email, password_hash, role, is_active, created_at, updated_at) VALUES ('fef2b46e-0f5b-4088-b27f-c36240ac6696', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'gaurav.sharma22@apex.edunexa.edu', '$2b$12$e8Y5t1hWz7M1r3B7.X7YuuN5U5zM2i0kM5fB4kXpWn/6z5YV3aW8m', 'STUDENT', true, '2026-10-01 14:07:55.478182+00', '2026-10-01 14:07:55.478184+00');
INSERT INTO public.users (user_id, college_id, email, password_hash, role, is_active, created_at, updated_at) VALUES ('7af689d9-6d41-49de-94d7-742774940c41', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'isha.verma23@apex.edunexa.edu', '$2b$12$e8Y5t1hWz7M1r3B7.X7YuuN5U5zM2i0kM5fB4kXpWn/6z5YV3aW8m', 'STUDENT', true, '2026-10-01 14:07:55.479782+00', '2026-10-01 14:07:55.479784+00');
INSERT INTO public.users (user_id, college_id, email, password_hash, role, is_active, created_at, updated_at) VALUES ('0a496d74-62c0-4754-b231-61e09ecaa1a2', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'nikhil.patel24@apex.edunexa.edu', '$2b$12$e8Y5t1hWz7M1r3B7.X7YuuN5U5zM2i0kM5fB4kXpWn/6z5YV3aW8m', 'STUDENT', true, '2026-10-01 14:07:55.481217+00', '2026-10-01 14:07:55.481219+00');
INSERT INTO public.users (user_id, college_id, email, password_hash, role, is_active, created_at, updated_at) VALUES ('aab51903-2680-4610-a2a7-5d43d6919908', '4b26ec2e-2e91-4ee0-a508-9fa138857b96', 'swati.reddy25@apex.edunexa.edu', '$2b$12$e8Y5t1hWz7M1r3B7.X7YuuN5U5zM2i0kM5fB4kXpWn/6z5YV3aW8m', 'STUDENT', true, '2026-10-01 14:07:55.482651+00', '2026-10-01 14:07:55.482653+00');
INSERT INTO public.users (user_id, college_id, email, password_hash, role, is_active, created_at, updated_at) VALUES ('74480686-d83b-4355-b004-932e6ac77b61', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'harsh.gupta1@horizon.edunexa.edu', '$2b$12$e8Y5t1hWz7M1r3B7.X7YuuN5U5zM2i0kM5fB4kXpWn/6z5YV3aW8m', 'STUDENT', true, '2026-10-01 14:07:55.484141+00', '2026-10-01 14:07:55.484143+00');
INSERT INTO public.users (user_id, college_id, email, password_hash, role, is_active, created_at, updated_at) VALUES ('abbae22d-1c6a-46bb-b828-deb25de409d0', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'simran.mehta2@horizon.edunexa.edu', '$2b$12$e8Y5t1hWz7M1r3B7.X7YuuN5U5zM2i0kM5fB4kXpWn/6z5YV3aW8m', 'STUDENT', true, '2026-10-01 14:07:55.485551+00', '2026-10-01 14:07:55.485553+00');
INSERT INTO public.users (user_id, college_id, email, password_hash, role, is_active, created_at, updated_at) VALUES ('3857e0f0-42e1-42de-993a-acfef7a99938', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'akash.iyer3@horizon.edunexa.edu', '$2b$12$e8Y5t1hWz7M1r3B7.X7YuuN5U5zM2i0kM5fB4kXpWn/6z5YV3aW8m', 'STUDENT', true, '2026-10-01 14:07:55.486928+00', '2026-10-01 14:07:55.48693+00');
INSERT INTO public.users (user_id, college_id, email, password_hash, role, is_active, created_at, updated_at) VALUES ('4570c249-e6de-421a-bfef-c2cfd2c09509', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'ritu.nair4@horizon.edunexa.edu', '$2b$12$e8Y5t1hWz7M1r3B7.X7YuuN5U5zM2i0kM5fB4kXpWn/6z5YV3aW8m', 'STUDENT', true, '2026-10-01 14:07:55.488435+00', '2026-10-01 14:07:55.488437+00');
INSERT INTO public.users (user_id, college_id, email, password_hash, role, is_active, created_at, updated_at) VALUES ('61e49ce0-a85e-42f6-9faf-3a19ed3b3c3d', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'dev.singh5@horizon.edunexa.edu', '$2b$12$e8Y5t1hWz7M1r3B7.X7YuuN5U5zM2i0kM5fB4kXpWn/6z5YV3aW8m', 'STUDENT', true, '2026-10-01 14:07:55.489947+00', '2026-10-01 14:07:55.489949+00');
INSERT INTO public.users (user_id, college_id, email, password_hash, role, is_active, created_at, updated_at) VALUES ('011504eb-042a-4591-9575-415986f8f3ce', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'payal.chauhan6@horizon.edunexa.edu', '$2b$12$e8Y5t1hWz7M1r3B7.X7YuuN5U5zM2i0kM5fB4kXpWn/6z5YV3aW8m', 'STUDENT', true, '2026-10-01 14:07:55.492019+00', '2026-10-01 14:07:55.492021+00');
INSERT INTO public.users (user_id, college_id, email, password_hash, role, is_active, created_at, updated_at) VALUES ('936628b4-8d8d-46ab-94ab-abd34fc0f2e5', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'amit.deshmukh7@horizon.edunexa.edu', '$2b$12$e8Y5t1hWz7M1r3B7.X7YuuN5U5zM2i0kM5fB4kXpWn/6z5YV3aW8m', 'STUDENT', true, '2026-10-01 14:07:55.493778+00', '2026-10-01 14:07:55.49378+00');
INSERT INTO public.users (user_id, college_id, email, password_hash, role, is_active, created_at, updated_at) VALUES ('44ea36f2-2a50-4771-bbf0-cedf4fe8f87b', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'shruti.kulkarni8@horizon.edunexa.edu', '$2b$12$e8Y5t1hWz7M1r3B7.X7YuuN5U5zM2i0kM5fB4kXpWn/6z5YV3aW8m', 'STUDENT', true, '2026-10-01 14:07:55.495311+00', '2026-10-01 14:07:55.495312+00');
INSERT INTO public.users (user_id, college_id, email, password_hash, role, is_active, created_at, updated_at) VALUES ('891077ae-99c5-492d-86cc-b373f28b5b84', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'suresh.bhat9@horizon.edunexa.edu', '$2b$12$e8Y5t1hWz7M1r3B7.X7YuuN5U5zM2i0kM5fB4kXpWn/6z5YV3aW8m', 'STUDENT', true, '2026-10-01 14:07:55.49665+00', '2026-10-01 14:07:55.496652+00');
INSERT INTO public.users (user_id, college_id, email, password_hash, role, is_active, created_at, updated_at) VALUES ('6cdea7a7-6ef9-41ff-b599-2ce5b99029e2', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'shweta.rao10@horizon.edunexa.edu', '$2b$12$e8Y5t1hWz7M1r3B7.X7YuuN5U5zM2i0kM5fB4kXpWn/6z5YV3aW8m', 'STUDENT', true, '2026-10-01 14:07:55.498912+00', '2026-10-01 14:07:55.498914+00');
INSERT INTO public.users (user_id, college_id, email, password_hash, role, is_active, created_at, updated_at) VALUES ('42ec3fe3-81a7-4db0-8a89-5e4ab6588a2c', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'raj.joshi11@horizon.edunexa.edu', '$2b$12$e8Y5t1hWz7M1r3B7.X7YuuN5U5zM2i0kM5fB4kXpWn/6z5YV3aW8m', 'STUDENT', true, '2026-10-01 14:07:55.500346+00', '2026-10-01 14:07:55.500348+00');
INSERT INTO public.users (user_id, college_id, email, password_hash, role, is_active, created_at, updated_at) VALUES ('e95e4c84-e06e-4b03-9e96-a5d011c70c8b', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'komal.kapoor12@horizon.edunexa.edu', '$2b$12$e8Y5t1hWz7M1r3B7.X7YuuN5U5zM2i0kM5fB4kXpWn/6z5YV3aW8m', 'STUDENT', true, '2026-10-01 14:07:55.501659+00', '2026-10-01 14:07:55.50166+00');
INSERT INTO public.users (user_id, college_id, email, password_hash, role, is_active, created_at, updated_at) VALUES ('bb0c0242-9787-4965-ac88-912799dce370', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'deepak.malhotra13@horizon.edunexa.edu', '$2b$12$e8Y5t1hWz7M1r3B7.X7YuuN5U5zM2i0kM5fB4kXpWn/6z5YV3aW8m', 'STUDENT', true, '2026-10-01 14:07:55.502966+00', '2026-10-01 14:07:55.502968+00');
INSERT INTO public.users (user_id, college_id, email, password_hash, role, is_active, created_at, updated_at) VALUES ('833ea7b2-8652-4a06-8a6e-c8082b182618', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'sunita.saxena14@horizon.edunexa.edu', '$2b$12$e8Y5t1hWz7M1r3B7.X7YuuN5U5zM2i0kM5fB4kXpWn/6z5YV3aW8m', 'STUDENT', true, '2026-10-01 14:07:55.504214+00', '2026-10-01 14:07:55.504215+00');
INSERT INTO public.users (user_id, college_id, email, password_hash, role, is_active, created_at, updated_at) VALUES ('74684551-e1bc-4bec-b9d9-ab4ac2176d5f', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'vishal.choudhury15@horizon.edunexa.edu', '$2b$12$e8Y5t1hWz7M1r3B7.X7YuuN5U5zM2i0kM5fB4kXpWn/6z5YV3aW8m', 'STUDENT', true, '2026-10-01 14:07:55.505425+00', '2026-10-01 14:07:55.505426+00');
INSERT INTO public.users (user_id, college_id, email, password_hash, role, is_active, created_at, updated_at) VALUES ('66df01b0-9b3d-4f48-93c0-5d6d96740937', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'tara.menon16@horizon.edunexa.edu', '$2b$12$e8Y5t1hWz7M1r3B7.X7YuuN5U5zM2i0kM5fB4kXpWn/6z5YV3aW8m', 'STUDENT', true, '2026-10-01 14:07:55.506745+00', '2026-10-01 14:07:55.506747+00');
INSERT INTO public.users (user_id, college_id, email, password_hash, role, is_active, created_at, updated_at) VALUES ('eb94d76b-3a38-4855-bea0-cb51fc8fa7fd', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'mayank.banerjee17@horizon.edunexa.edu', '$2b$12$e8Y5t1hWz7M1r3B7.X7YuuN5U5zM2i0kM5fB4kXpWn/6z5YV3aW8m', 'STUDENT', true, '2026-10-01 14:07:55.508497+00', '2026-10-01 14:07:55.508499+00');
INSERT INTO public.users (user_id, college_id, email, password_hash, role, is_active, created_at, updated_at) VALUES ('af8b45d7-4552-4d50-b811-0ffc134b8eea', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'pallavi.chatterjee18@horizon.edunexa.edu', '$2b$12$e8Y5t1hWz7M1r3B7.X7YuuN5U5zM2i0kM5fB4kXpWn/6z5YV3aW8m', 'STUDENT', true, '2026-10-01 14:07:55.510089+00', '2026-10-01 14:07:55.510091+00');
INSERT INTO public.users (user_id, college_id, email, password_hash, role, is_active, created_at, updated_at) VALUES ('80c3e0f1-0733-48a4-b3ac-85716aab845c', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'sameer.mishra19@horizon.edunexa.edu', '$2b$12$e8Y5t1hWz7M1r3B7.X7YuuN5U5zM2i0kM5fB4kXpWn/6z5YV3aW8m', 'STUDENT', true, '2026-10-01 14:07:55.511493+00', '2026-10-01 14:07:55.511494+00');
INSERT INTO public.users (user_id, college_id, email, password_hash, role, is_active, created_at, updated_at) VALUES ('5c652a50-36de-433f-92e5-6e48b7c1823e', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'geeta.pandey20@horizon.edunexa.edu', '$2b$12$e8Y5t1hWz7M1r3B7.X7YuuN5U5zM2i0kM5fB4kXpWn/6z5YV3aW8m', 'STUDENT', true, '2026-10-01 14:07:55.512852+00', '2026-10-01 14:07:55.512853+00');
INSERT INTO public.users (user_id, college_id, email, password_hash, role, is_active, created_at, updated_at) VALUES ('618fa3d8-2770-4ef1-b447-4720832345e5', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'abhishek.sharma21@horizon.edunexa.edu', '$2b$12$e8Y5t1hWz7M1r3B7.X7YuuN5U5zM2i0kM5fB4kXpWn/6z5YV3aW8m', 'STUDENT', true, '2026-10-01 14:07:55.514113+00', '2026-10-01 14:07:55.514115+00');
INSERT INTO public.users (user_id, college_id, email, password_hash, role, is_active, created_at, updated_at) VALUES ('34cfe50c-1299-4467-9f1d-f42b0029881b', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'kritika.verma22@horizon.edunexa.edu', '$2b$12$e8Y5t1hWz7M1r3B7.X7YuuN5U5zM2i0kM5fB4kXpWn/6z5YV3aW8m', 'STUDENT', true, '2026-10-01 14:07:55.51554+00', '2026-10-01 14:07:55.515541+00');
INSERT INTO public.users (user_id, college_id, email, password_hash, role, is_active, created_at, updated_at) VALUES ('0b094a09-db56-4a7b-b238-c7a6be0530c5', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'alok.patel23@horizon.edunexa.edu', '$2b$12$e8Y5t1hWz7M1r3B7.X7YuuN5U5zM2i0kM5fB4kXpWn/6z5YV3aW8m', 'STUDENT', true, '2026-10-01 14:07:55.51683+00', '2026-10-01 14:07:55.516831+00');
INSERT INTO public.users (user_id, college_id, email, password_hash, role, is_active, created_at, updated_at) VALUES ('c87c7a3e-be10-4bf6-bdf7-4d6b132fb21a', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'bhavna.reddy24@horizon.edunexa.edu', '$2b$12$e8Y5t1hWz7M1r3B7.X7YuuN5U5zM2i0kM5fB4kXpWn/6z5YV3aW8m', 'STUDENT', true, '2026-10-01 14:07:55.518074+00', '2026-10-01 14:07:55.518076+00');
INSERT INTO public.users (user_id, college_id, email, password_hash, role, is_active, created_at, updated_at) VALUES ('1366dfbf-94db-46b6-8ecc-7a11456dc1a5', 'f141cc3c-8b84-435e-95b0-ae4eb01a284b', 'kunal.gupta25@horizon.edunexa.edu', '$2b$12$e8Y5t1hWz7M1r3B7.X7YuuN5U5zM2i0kM5fB4kXpWn/6z5YV3aW8m', 'STUDENT', true, '2026-10-01 14:07:55.519268+00', '2026-10-01 14:07:55.519269+00');


--
-- Name: academic_calendar academic_calendar_pkey; Type: CONSTRAINT; Schema: public; Owner: edunexa_admin
--

ALTER TABLE ONLY public.academic_calendar
    ADD CONSTRAINT academic_calendar_pkey PRIMARY KEY (event_id);


--
-- Name: admins admins_pkey; Type: CONSTRAINT; Schema: public; Owner: edunexa_admin
--

ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_pkey PRIMARY KEY (admin_id);


--
-- Name: admins admins_user_id_key; Type: CONSTRAINT; Schema: public; Owner: edunexa_admin
--

ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_user_id_key UNIQUE (user_id);


--
-- Name: announcements announcements_pkey; Type: CONSTRAINT; Schema: public; Owner: edunexa_admin
--

ALTER TABLE ONLY public.announcements
    ADD CONSTRAINT announcements_pkey PRIMARY KEY (announcement_id);


--
-- Name: attendance attendance_pkey; Type: CONSTRAINT; Schema: public; Owner: edunexa_admin
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_pkey PRIMARY KEY (attendance_id);


--
-- Name: colleges colleges_code_key; Type: CONSTRAINT; Schema: public; Owner: edunexa_admin
--

ALTER TABLE ONLY public.colleges
    ADD CONSTRAINT colleges_code_key UNIQUE (code);


--
-- Name: colleges colleges_domain_key; Type: CONSTRAINT; Schema: public; Owner: edunexa_admin
--

ALTER TABLE ONLY public.colleges
    ADD CONSTRAINT colleges_domain_key UNIQUE (domain);


--
-- Name: colleges colleges_pkey; Type: CONSTRAINT; Schema: public; Owner: edunexa_admin
--

ALTER TABLE ONLY public.colleges
    ADD CONSTRAINT colleges_pkey PRIMARY KEY (college_id);


--
-- Name: course_enrollments course_enrollments_pkey; Type: CONSTRAINT; Schema: public; Owner: edunexa_admin
--

ALTER TABLE ONLY public.course_enrollments
    ADD CONSTRAINT course_enrollments_pkey PRIMARY KEY (enrollment_id);


--
-- Name: course_materials course_materials_pkey; Type: CONSTRAINT; Schema: public; Owner: edunexa_admin
--

ALTER TABLE ONLY public.course_materials
    ADD CONSTRAINT course_materials_pkey PRIMARY KEY (material_id);


--
-- Name: courses courses_pkey; Type: CONSTRAINT; Schema: public; Owner: edunexa_admin
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_pkey PRIMARY KEY (course_id);


--
-- Name: faculty faculty_pkey; Type: CONSTRAINT; Schema: public; Owner: edunexa_admin
--

ALTER TABLE ONLY public.faculty
    ADD CONSTRAINT faculty_pkey PRIMARY KEY (faculty_id);


--
-- Name: faculty faculty_user_id_key; Type: CONSTRAINT; Schema: public; Owner: edunexa_admin
--

ALTER TABLE ONLY public.faculty
    ADD CONSTRAINT faculty_user_id_key UNIQUE (user_id);


--
-- Name: grades grades_pkey; Type: CONSTRAINT; Schema: public; Owner: edunexa_admin
--

ALTER TABLE ONLY public.grades
    ADD CONSTRAINT grades_pkey PRIMARY KEY (grade_id);


--
-- Name: students students_pkey; Type: CONSTRAINT; Schema: public; Owner: edunexa_admin
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_pkey PRIMARY KEY (student_id);


--
-- Name: students students_user_id_key; Type: CONSTRAINT; Schema: public; Owner: edunexa_admin
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_user_id_key UNIQUE (user_id);


--
-- Name: timetable timetable_pkey; Type: CONSTRAINT; Schema: public; Owner: edunexa_admin
--

ALTER TABLE ONLY public.timetable
    ADD CONSTRAINT timetable_pkey PRIMARY KEY (timetable_id);


--
-- Name: courses uq_course_college_code; Type: CONSTRAINT; Schema: public; Owner: edunexa_admin
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT uq_course_college_code UNIQUE (college_id, course_code);


--
-- Name: course_enrollments uq_enrollment_unique; Type: CONSTRAINT; Schema: public; Owner: edunexa_admin
--

ALTER TABLE ONLY public.course_enrollments
    ADD CONSTRAINT uq_enrollment_unique UNIQUE (college_id, course_id, student_id);


--
-- Name: faculty uq_faculty_college_code; Type: CONSTRAINT; Schema: public; Owner: edunexa_admin
--

ALTER TABLE ONLY public.faculty
    ADD CONSTRAINT uq_faculty_college_code UNIQUE (college_id, employee_code);


--
-- Name: students uq_student_college_roll; Type: CONSTRAINT; Schema: public; Owner: edunexa_admin
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT uq_student_college_roll UNIQUE (college_id, roll_number);


--
-- Name: users uq_user_college_email; Type: CONSTRAINT; Schema: public; Owner: edunexa_admin
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT uq_user_college_email UNIQUE (college_id, email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: edunexa_admin
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: idx_announcements_college_date; Type: INDEX; Schema: public; Owner: edunexa_admin
--

CREATE INDEX idx_announcements_college_date ON public.announcements USING btree (college_id, created_at);


--
-- Name: idx_attendance_course_date; Type: INDEX; Schema: public; Owner: edunexa_admin
--

CREATE INDEX idx_attendance_course_date ON public.attendance USING btree (college_id, course_id, date_recorded);


--
-- Name: idx_attendance_student_date; Type: INDEX; Schema: public; Owner: edunexa_admin
--

CREATE INDEX idx_attendance_student_date ON public.attendance USING btree (college_id, student_id, date_recorded);


--
-- Name: idx_calendar_dates; Type: INDEX; Schema: public; Owner: edunexa_admin
--

CREATE INDEX idx_calendar_dates ON public.academic_calendar USING btree (college_id, start_date, end_date);


--
-- Name: idx_grades_student_course; Type: INDEX; Schema: public; Owner: edunexa_admin
--

CREATE INDEX idx_grades_student_course ON public.grades USING btree (college_id, student_id, course_id);


--
-- Name: idx_materials_course; Type: INDEX; Schema: public; Owner: edunexa_admin
--

CREATE INDEX idx_materials_course ON public.course_materials USING btree (college_id, course_id);


--
-- Name: idx_timetable_course_day; Type: INDEX; Schema: public; Owner: edunexa_admin
--

CREATE INDEX idx_timetable_course_day ON public.timetable USING btree (college_id, course_id, day_of_week);


--
-- Name: idx_timetable_faculty_day; Type: INDEX; Schema: public; Owner: edunexa_admin
--

CREATE INDEX idx_timetable_faculty_day ON public.timetable USING btree (college_id, faculty_id, day_of_week);


--
-- Name: academic_calendar academic_calendar_college_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: edunexa_admin
--

ALTER TABLE ONLY public.academic_calendar
    ADD CONSTRAINT academic_calendar_college_id_fkey FOREIGN KEY (college_id) REFERENCES public.colleges(college_id) ON DELETE CASCADE;


--
-- Name: admins admins_college_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: edunexa_admin
--

ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_college_id_fkey FOREIGN KEY (college_id) REFERENCES public.colleges(college_id) ON DELETE CASCADE;


--
-- Name: admins admins_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: edunexa_admin
--

ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: announcements announcements_author_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: edunexa_admin
--

ALTER TABLE ONLY public.announcements
    ADD CONSTRAINT announcements_author_id_fkey FOREIGN KEY (author_id) REFERENCES public.users(user_id) ON DELETE SET NULL;


--
-- Name: announcements announcements_college_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: edunexa_admin
--

ALTER TABLE ONLY public.announcements
    ADD CONSTRAINT announcements_college_id_fkey FOREIGN KEY (college_id) REFERENCES public.colleges(college_id) ON DELETE CASCADE;


--
-- Name: attendance attendance_college_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: edunexa_admin
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_college_id_fkey FOREIGN KEY (college_id) REFERENCES public.colleges(college_id) ON DELETE CASCADE;


--
-- Name: attendance attendance_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: edunexa_admin
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_course_id_fkey FOREIGN KEY (course_id) REFERENCES public.courses(course_id) ON DELETE CASCADE;


--
-- Name: attendance attendance_faculty_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: edunexa_admin
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_faculty_id_fkey FOREIGN KEY (faculty_id) REFERENCES public.faculty(faculty_id) ON DELETE SET NULL;


--
-- Name: attendance attendance_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: edunexa_admin
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(student_id) ON DELETE CASCADE;


--
-- Name: course_enrollments course_enrollments_college_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: edunexa_admin
--

ALTER TABLE ONLY public.course_enrollments
    ADD CONSTRAINT course_enrollments_college_id_fkey FOREIGN KEY (college_id) REFERENCES public.colleges(college_id) ON DELETE CASCADE;


--
-- Name: course_enrollments course_enrollments_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: edunexa_admin
--

ALTER TABLE ONLY public.course_enrollments
    ADD CONSTRAINT course_enrollments_course_id_fkey FOREIGN KEY (course_id) REFERENCES public.courses(course_id) ON DELETE CASCADE;


--
-- Name: course_enrollments course_enrollments_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: edunexa_admin
--

ALTER TABLE ONLY public.course_enrollments
    ADD CONSTRAINT course_enrollments_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(student_id) ON DELETE CASCADE;


--
-- Name: course_materials course_materials_college_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: edunexa_admin
--

ALTER TABLE ONLY public.course_materials
    ADD CONSTRAINT course_materials_college_id_fkey FOREIGN KEY (college_id) REFERENCES public.colleges(college_id) ON DELETE CASCADE;


--
-- Name: course_materials course_materials_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: edunexa_admin
--

ALTER TABLE ONLY public.course_materials
    ADD CONSTRAINT course_materials_course_id_fkey FOREIGN KEY (course_id) REFERENCES public.courses(course_id) ON DELETE CASCADE;


--
-- Name: course_materials course_materials_faculty_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: edunexa_admin
--

ALTER TABLE ONLY public.course_materials
    ADD CONSTRAINT course_materials_faculty_id_fkey FOREIGN KEY (faculty_id) REFERENCES public.faculty(faculty_id) ON DELETE CASCADE;


--
-- Name: courses courses_college_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: edunexa_admin
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_college_id_fkey FOREIGN KEY (college_id) REFERENCES public.colleges(college_id) ON DELETE CASCADE;


--
-- Name: faculty faculty_college_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: edunexa_admin
--

ALTER TABLE ONLY public.faculty
    ADD CONSTRAINT faculty_college_id_fkey FOREIGN KEY (college_id) REFERENCES public.colleges(college_id) ON DELETE CASCADE;


--
-- Name: faculty faculty_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: edunexa_admin
--

ALTER TABLE ONLY public.faculty
    ADD CONSTRAINT faculty_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: grades grades_college_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: edunexa_admin
--

ALTER TABLE ONLY public.grades
    ADD CONSTRAINT grades_college_id_fkey FOREIGN KEY (college_id) REFERENCES public.colleges(college_id) ON DELETE CASCADE;


--
-- Name: grades grades_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: edunexa_admin
--

ALTER TABLE ONLY public.grades
    ADD CONSTRAINT grades_course_id_fkey FOREIGN KEY (course_id) REFERENCES public.courses(course_id) ON DELETE CASCADE;


--
-- Name: grades grades_faculty_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: edunexa_admin
--

ALTER TABLE ONLY public.grades
    ADD CONSTRAINT grades_faculty_id_fkey FOREIGN KEY (faculty_id) REFERENCES public.faculty(faculty_id) ON DELETE SET NULL;


--
-- Name: grades grades_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: edunexa_admin
--

ALTER TABLE ONLY public.grades
    ADD CONSTRAINT grades_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(student_id) ON DELETE CASCADE;


--
-- Name: students students_college_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: edunexa_admin
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_college_id_fkey FOREIGN KEY (college_id) REFERENCES public.colleges(college_id) ON DELETE CASCADE;


--
-- Name: students students_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: edunexa_admin
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: timetable timetable_college_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: edunexa_admin
--

ALTER TABLE ONLY public.timetable
    ADD CONSTRAINT timetable_college_id_fkey FOREIGN KEY (college_id) REFERENCES public.colleges(college_id) ON DELETE CASCADE;


--
-- Name: timetable timetable_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: edunexa_admin
--

ALTER TABLE ONLY public.timetable
    ADD CONSTRAINT timetable_course_id_fkey FOREIGN KEY (course_id) REFERENCES public.courses(course_id) ON DELETE CASCADE;


--
-- Name: timetable timetable_faculty_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: edunexa_admin
--

ALTER TABLE ONLY public.timetable
    ADD CONSTRAINT timetable_faculty_id_fkey FOREIGN KEY (faculty_id) REFERENCES public.faculty(faculty_id) ON DELETE CASCADE;


--
-- Name: users users_college_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: edunexa_admin
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_college_id_fkey FOREIGN KEY (college_id) REFERENCES public.colleges(college_id) ON DELETE CASCADE;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: edunexa_admin
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;


--
-- PostgreSQL database dump complete
--

\unrestrict sPOBuvfXN3U8U35HCgB04AxwabRTjgvYZNuaz0SKKc3taO4E3Uh7Drf6VbBM6Wi

