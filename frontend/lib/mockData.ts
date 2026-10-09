// lib/mockData.ts

export interface MockUser {
  user_id: string;
  college_id: string;
  college_name: string;
  college_domain: string;
  email: string;
  role: "ADMIN" | "FACULTY" | "STUDENT";
  is_active: boolean;
  profile: {
    admin_id?: string;
    faculty_id?: string;
    student_id?: string;
    first_name: string;
    last_name: string;
    department?: string;
    designation?: string;
    roll_number?: string;
    semester?: string;
    enrollment_year?: string;
    phone?: string;
  };
}

export interface AttendanceSummaryItem {
  course_id: string;
  course_code: string;
  course_name: string;
  department: string;
  total_enrolled: number;
  total_sessions: number;
  present_percentage: number;
  status: string;
}

export interface AttendanceTrendItem {
  day: string;
  cs: number;
  it: number;
  ec: number;
  me: number;
}

export interface FacultyActivityItem {
  faculty_id: string;
  name: string;
  department: string;
  designation: string;
  courses_count: number;
  sessions_conducted: number;
  materials_uploaded: number;
  last_active: string;
}

export interface AnnouncementItem {
  announcement_id: string;
  title: string;
  content: string;
  target_role: string;
  author_name?: string;
  created_at: string;
}

export interface CalendarEventItem {
  event_id: string;
  event_title: string;
  event_type: string;
  start_date: string;
  end_date: string;
  description: string;
}

export interface TimetableSlotItem {
  id: string;
  day: string;
  start_time: string;
  end_time: string;
  course_code: string;
  course_name: string;
  room_number: string;
  section: string;
}

export interface CourseItem {
  course_id: string;
  course_code: string;
  course_name: string;
  department: string;
  credits: number;
  semester: string;
  enrolled_count: number;
}

export interface StudentRosterItem {
  student_id: string;
  roll_number: string;
  first_name: string;
  last_name: string;
  email: string;
  attendance_rate: number;
  status: string;
}

export interface MaterialItem {
  material_id: string;
  course_id: string;
  course_code: string;
  title: string;
  description: string;
  file_type: string;
  file_size: string;
  uploaded_at: string;
  faculty_name: string;
}

export interface SessionLogItem {
  date: string;
  status: string;
  remarks: string;
}

export interface StudentAttendanceItem {
  course_id: string;
  course_code: string;
  course_name: string;
  faculty_name: string;
  conducted: number;
  attended: number;
  percentage: number;
  status: string;
  logs: SessionLogItem[];
}

export interface StudentGradeItem {
  grade_id: string;
  course_code: string;
  course_name: string;
  assessment_name: string;
  score: number;
  max_score: number;
  percentage: number;
  grade: string;
  faculty_remarks: string;
}

export interface ProgressReportItem {
  gpa: number;
  letter_grade: string;
  credits_earned: number;
  total_credits: number;
  rank?: string;
}

export const MOCK_USERS: Record<string, MockUser> = {
  admin: {
    user_id: "u-admin-apex-01",
    college_id: "c-apex-01",
    college_name: "Apex Institute of Technology",
    college_domain: "apex.edunexa.edu",
    email: "admin@apex.edunexa.edu",
    role: "ADMIN",
    is_active: true,
    profile: {
      admin_id: "adm-001",
      first_name: "Robert",
      last_name: "Vance",
      phone: "+1-555-0101",
    },
  },
  faculty: {
    user_id: "u-faculty-apex-01",
    college_id: "c-apex-01",
    college_name: "Apex Institute of Technology",
    college_domain: "apex.edunexa.edu",
    email: "rajesh.nambiar@apex.edunexa.edu",
    role: "FACULTY",
    is_active: true,
    profile: {
      faculty_id: "fac-001",
      first_name: "Dr. Rajesh",
      last_name: "Nambiar",
      department: "Computer Science",
      designation: "Professor",
    },
  },
  student: {
    user_id: "u-student-apex-01",
    college_id: "c-apex-01",
    college_name: "Apex Institute of Technology",
    college_domain: "apex.edunexa.edu",
    email: "aarav.sharma1@apex.edunexa.edu",
    role: "STUDENT",
    is_active: true,
    profile: {
      student_id: "std-001",
      first_name: "Aarav",
      last_name: "Sharma",
      roll_number: "APEX-2024-101",
      semester: "Sem 3",
      enrollment_year: "2024",
    },
  },
};

export const MOCK_ADMIN_ATTENDANCE_SUMMARY = [
  {
    course_id: "crs-cs101",
    course_code: "APEX-CS101",
    course_name: "Data Structures & Algorithms",
    department: "Computer Science",
    total_enrolled: 42,
    total_sessions: 28,
    present_percentage: 88.5,
    status: "HEALTHY",
  },
  {
    course_id: "crs-cs102",
    course_code: "APEX-CS102",
    course_name: "Database Management Systems",
    department: "Computer Science",
    total_enrolled: 38,
    total_sessions: 24,
    present_percentage: 84.2,
    status: "HEALTHY",
  },
  {
    course_id: "crs-it201",
    course_code: "APEX-IT201",
    course_name: "Web Application Development",
    department: "Information Technology",
    total_enrolled: 35,
    total_sessions: 26,
    present_percentage: 91.0,
    status: "HEALTHY",
  },
  {
    course_id: "crs-ec201",
    course_code: "APEX-EC201",
    course_name: "Digital Signal Processing",
    department: "Electronics & Comm",
    total_enrolled: 30,
    total_sessions: 22,
    present_percentage: 71.8,
    status: "ATTENTION_REQUIRED",
  },
  {
    course_id: "crs-me301",
    course_code: "APEX-ME301",
    course_name: "Thermodynamics & Heat Transfer",
    department: "Mechanical Eng",
    total_enrolled: 29,
    total_sessions: 20,
    present_percentage: 78.4,
    status: "HEALTHY",
  },
];

export const MOCK_ADMIN_ATTENDANCE_TRENDS = [
  { day: "Mon", cs: 89, it: 92, ec: 74, me: 79 },
  { day: "Tue", cs: 87, it: 90, ec: 71, me: 81 },
  { day: "Wed", cs: 91, it: 94, ec: 76, me: 75 },
  { day: "Thu", cs: 85, it: 88, ec: 70, me: 77 },
  { day: "Fri", cs: 88, it: 91, ec: 68, me: 80 },
  { day: "Sat", cs: 82, it: 86, ec: 65, me: 74 },
];

export const MOCK_FACULTY_ACTIVITY = [
  {
    faculty_id: "fac-001",
    name: "Dr. Rajesh Nambiar",
    department: "Computer Science",
    designation: "Professor",
    courses_count: 3,
    sessions_conducted: 52,
    materials_uploaded: 8,
    last_active: "Today, 10:30 AM",
  },
  {
    faculty_id: "fac-002",
    name: "Dr. Sunita Raman",
    department: "Computer Science",
    designation: "Associate Professor",
    courses_count: 2,
    sessions_conducted: 44,
    materials_uploaded: 6,
    last_active: "Today, 09:15 AM",
  },
  {
    faculty_id: "fac-003",
    name: "Prof. Amit Deshmukh",
    department: "Information Technology",
    designation: "Assistant Professor",
    courses_count: 3,
    sessions_conducted: 48,
    materials_uploaded: 11,
    last_active: "Yesterday, 04:45 PM",
  },
  {
    faculty_id: "fac-004",
    name: "Dr. Kavita Menon",
    department: "Electronics & Comm",
    designation: "Associate Professor",
    courses_count: 2,
    sessions_conducted: 38,
    materials_uploaded: 5,
    last_active: "Today, 11:00 AM",
  },
];

export const MOCK_ANNOUNCEMENTS = [
  {
    announcement_id: "ann-001",
    title: "Welcome to Academic Session 2024-2025",
    content:
      "Welcome back students and faculty members. Please review your lecture timetables on the portal and verify enrolled course modules.",
    target_role: "ALL",
    author_name: "Administrative Office",
    created_at: "2026-10-01T08:00:00Z",
  },
  {
    announcement_id: "ann-002",
    title: "Midterm Assessment Submission Window",
    content:
      "All faculty members are requested to complete grade submissions before the upcoming deadline. Roster moderation is open.",
    target_role: "FACULTY",
    author_name: "Dean of Academics",
    created_at: "2026-10-04T10:30:00Z",
  },
  {
    announcement_id: "ann-003",
    title: "Annual Technical Symposium & Hackathon Call for Papers",
    content:
      "Submissions are now open for the campus hackathon and paper presentations. Cash prizes and industry internship vouchers await.",
    target_role: "STUDENT",
    author_name: "Technical Committee",
    created_at: "2026-10-06T14:15:00Z",
  },
];

export const MOCK_CALENDAR_EVENTS = [
  {
    event_id: "cal-001",
    event_title: "Mid-Semester Examinations",
    event_type: "EXAM",
    start_date: "2026-10-24",
    end_date: "2026-10-31",
    description: "Theory and lab examinations for all departments across semesters.",
  },
  {
    event_id: "cal-002",
    event_title: "Annual Technical Symposium & Hackathon",
    event_type: "EVENT",
    start_date: "2026-11-14",
    end_date: "2026-11-16",
    description: "Inter-college technical competition, AI showcase, and startup pitch day.",
  },
  {
    event_id: "cal-003",
    event_title: "National Holiday - Institutional Recess",
    event_type: "HOLIDAY",
    start_date: "2026-11-01",
    end_date: "2026-11-01",
    description: "College closed for all academic and administrative activities.",
  },
];

export const MOCK_FACULTY_TIMETABLE = [
  {
    id: "slot-1",
    day: "Monday",
    start_time: "09:00",
    end_time: "10:00",
    course_code: "APEX-CS101",
    course_name: "Data Structures & Algorithms",
    room_number: "Lecture Hall 301",
    section: "Section A",
  },
  {
    id: "slot-2",
    day: "Monday",
    start_time: "11:00",
    end_time: "12:30",
    course_code: "APEX-CS102",
    course_name: "Database Systems Lab",
    room_number: "Lab Complex 2",
    section: "Section B",
  },
  {
    id: "slot-3",
    day: "Tuesday",
    start_time: "10:00",
    end_time: "11:00",
    course_code: "APEX-CS101",
    course_name: "Data Structures & Algorithms",
    room_number: "Lecture Hall 301",
    section: "Section A",
  },
  {
    id: "slot-4",
    day: "Wednesday",
    start_time: "14:00",
    end_time: "15:30",
    course_code: "APEX-CS102",
    course_name: "Database Systems",
    room_number: "Seminar Hall B",
    section: "Section B",
  },
  {
    id: "slot-5",
    day: "Thursday",
    start_time: "09:00",
    end_time: "10:30",
    course_code: "APEX-CS101",
    course_name: "Algorithm Design Tutorial",
    room_number: "Room 105",
    section: "Section A",
  },
  {
    id: "slot-6",
    day: "Friday",
    start_time: "11:00",
    end_time: "12:00",
    course_code: "APEX-CS102",
    course_name: "Advanced SQL & Relational Algebra",
    room_number: "Lecture Hall 301",
    section: "Section B",
  },
];

export const MOCK_FACULTY_COURSES = [
  {
    course_id: "crs-cs101",
    course_code: "APEX-CS101",
    course_name: "Data Structures & Algorithms",
    department: "Computer Science",
    credits: 4,
    semester: "Sem 3",
    enrolled_count: 42,
  },
  {
    course_id: "crs-cs102",
    course_code: "APEX-CS102",
    course_name: "Database Management Systems",
    department: "Computer Science",
    credits: 4,
    semester: "Sem 3",
    enrolled_count: 38,
  },
];

export const MOCK_COURSE_STUDENTS = [
  {
    student_id: "std-001",
    roll_number: "APEX-2024-101",
    first_name: "Aarav",
    last_name: "Sharma",
    email: "aarav.sharma1@apex.edunexa.edu",
    attendance_rate: 92.5,
    status: "PRESENT",
  },
  {
    student_id: "std-002",
    roll_number: "APEX-2024-102",
    first_name: "Diya",
    last_name: "Patel",
    email: "diya.patel2@apex.edunexa.edu",
    attendance_rate: 85.0,
    status: "PRESENT",
  },
  {
    student_id: "std-003",
    roll_number: "APEX-2024-103",
    first_name: "Rohan",
    last_name: "Verma",
    email: "rohan.verma3@apex.edunexa.edu",
    attendance_rate: 68.0,
    status: "ABSENT",
  },
  {
    student_id: "std-004",
    roll_number: "APEX-2024-104",
    first_name: "Ananya",
    last_name: "Iyer",
    email: "ananya.iyer4@apex.edunexa.edu",
    attendance_rate: 96.0,
    status: "PRESENT",
  },
  {
    student_id: "std-005",
    roll_number: "APEX-2024-105",
    first_name: "Vikram",
    last_name: "Reddy",
    email: "vikram.reddy5@apex.edunexa.edu",
    attendance_rate: 74.0,
    status: "LATE",
  },
];

export const MOCK_MATERIALS = [
  {
    material_id: "mat-001",
    course_id: "crs-cs101",
    course_code: "APEX-CS101",
    title: "Module 1: Asymptotic Analysis and Tree Structures",
    description: "Comprehensive notes covering Big-O analysis, AVL Trees, and Red-Black balancing.",
    file_type: "PDF",
    file_size: "3.4 MB",
    uploaded_at: "2026-10-02",
    faculty_name: "Dr. Rajesh Nambiar",
  },
  {
    material_id: "mat-002",
    course_id: "crs-cs101",
    course_code: "APEX-CS101",
    title: "Module 2: Graph Theory Algorithms & Dynamic Programming",
    description: "Dijkstra, Bellman-Ford, DAG shortest paths, and DP memoization patterns with code.",
    file_type: "PDF",
    file_size: "4.8 MB",
    uploaded_at: "2026-10-05",
    faculty_name: "Dr. Rajesh Nambiar",
  },
  {
    material_id: "mat-003",
    course_id: "crs-cs102",
    course_code: "APEX-CS102",
    title: "Module 1: Relational Algebra & Normalization Cheatsheet",
    description: "Detailed examples from 1NF to BCNF, lossless join decomposition proofs.",
    file_type: "PDF",
    file_size: "2.1 MB",
    uploaded_at: "2026-10-03",
    faculty_name: "Dr. Rajesh Nambiar",
  },
];

export const MOCK_STUDENT_ATTENDANCE = [
  {
    course_id: "crs-cs101",
    course_code: "APEX-CS101",
    course_name: "Data Structures & Algorithms",
    faculty_name: "Dr. Rajesh Nambiar",
    conducted: 28,
    attended: 26,
    percentage: 92.8,
    status: "ON_TRACK",
    logs: [
      { date: "2026-10-08", status: "PRESENT", remarks: "Active participation in B-Tree dissection" },
      { date: "2026-10-06", status: "PRESENT", remarks: "On time" },
      { date: "2026-10-04", status: "LATE", remarks: "Arrived 10 mins late due to bus transit" },
      { date: "2026-10-01", status: "PRESENT", remarks: "On time" },
      { date: "2026-09-28", status: "ABSENT", remarks: "Medical appointment" },
    ],
  },
  {
    course_id: "crs-cs102",
    course_code: "APEX-CS102",
    course_name: "Database Management Systems",
    faculty_name: "Dr. Rajesh Nambiar",
    conducted: 24,
    attended: 21,
    percentage: 87.5,
    status: "ON_TRACK",
    logs: [
      { date: "2026-10-07", status: "PRESENT", remarks: "Completed lab query exercises" },
      { date: "2026-10-05", status: "PRESENT", remarks: "On time" },
      { date: "2026-10-03", status: "PRESENT", remarks: "On time" },
      { date: "2026-09-29", status: "ABSENT", remarks: "Unexcused" },
    ],
  },
  {
    course_id: "crs-it201",
    course_code: "APEX-IT201",
    course_name: "Web Application Development",
    faculty_name: "Prof. Amit Deshmukh",
    conducted: 26,
    attended: 24,
    percentage: 92.3,
    status: "ON_TRACK",
    logs: [
      { date: "2026-10-08", status: "PRESENT", remarks: "Presented React Query caching demo" },
      { date: "2026-10-04", status: "PRESENT", remarks: "On time" },
    ],
  },
  {
    course_id: "crs-ec201",
    course_code: "APEX-EC201",
    course_name: "Digital Signal Processing",
    faculty_name: "Dr. Kavita Menon",
    conducted: 22,
    attended: 16,
    percentage: 72.7,
    status: "SHORTAGE_ALERT",
    logs: [
      { date: "2026-10-07", status: "ABSENT", remarks: "Missed FFT transform lab" },
      { date: "2026-10-02", status: "PRESENT", remarks: "On time" },
      { date: "2026-09-27", status: "ABSENT", remarks: "Illness" },
    ],
  },
];

export const MOCK_STUDENT_GRADES = [
  {
    grade_id: "grd-001",
    course_code: "APEX-CS101",
    course_name: "Data Structures & Algorithms",
    assessment_name: "Midterm Examination",
    score: 94,
    max_score: 100,
    percentage: 94.0,
    grade: "A+",
    faculty_remarks: "Exceptional efficiency in tree balancing proofs.",
  },
  {
    grade_id: "grd-002",
    course_code: "APEX-CS101",
    course_name: "Data Structures & Algorithms",
    assessment_name: "Assignment 1 (Graph DP)",
    score: 88,
    max_score: 100,
    percentage: 88.0,
    grade: "A",
    faculty_remarks: "Clean code and optimal complexity.",
  },
  {
    grade_id: "grd-003",
    course_code: "APEX-CS102",
    course_name: "Database Management Systems",
    assessment_name: "Midterm Examination",
    score: 86,
    max_score: 100,
    percentage: 86.0,
    grade: "A",
    faculty_remarks: "Solid understanding of relational algebra.",
  },
  {
    grade_id: "grd-004",
    course_code: "APEX-IT201",
    course_name: "Web Application Development",
    assessment_name: "Midterm Project Presentation",
    score: 95,
    max_score: 100,
    percentage: 95.0,
    grade: "A+",
    faculty_remarks: "Outstanding UX and component architecture.",
  },
];
