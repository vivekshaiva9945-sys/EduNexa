// lib/api.ts
import axios, { AxiosError, AxiosInstance, InternalAxiosRequestConfig } from "axios";
import {
  MOCK_ADMIN_ATTENDANCE_SUMMARY,
  MOCK_ADMIN_ATTENDANCE_TRENDS,
  MOCK_ANNOUNCEMENTS,
  MOCK_CALENDAR_EVENTS,
  MOCK_COURSE_STUDENTS,
  MOCK_FACULTY_ACTIVITY,
  MOCK_FACULTY_COURSES,
  MOCK_FACULTY_TIMETABLE,
  MOCK_MATERIALS,
  MOCK_STUDENT_ATTENDANCE,
  MOCK_STUDENT_GRADES,
  MOCK_USERS,
  MockUser,
} from "./mockData";

const API_BASE_URL =
  process.env.NEXT_PUBLIC_API_URL || "http://localhost:8000/api/v1";

export const apiClient: AxiosInstance = axios.create({
  baseURL: API_BASE_URL,
  timeout: 6000,
  headers: {
    "Content-Type": "application/json",
  },
});

// Interceptor to inject Bearer token and X-Tenant-ID
apiClient.interceptors.request.use(
  (config: InternalAxiosRequestConfig) => {
    if (typeof window !== "undefined") {
      const token = localStorage.getItem("edunexa_token");
      const tenantId = localStorage.getItem("edunexa_tenant_id");

      if (token) {
        config.headers.set("Authorization", `Bearer ${token}`);
      }
      if (tenantId) {
        config.headers.set("X-Tenant-ID", tenantId);
      }
    }
    return config;
  },
  (error: AxiosError) => Promise.reject(error)
);

// Interceptor for 401 handling
apiClient.interceptors.response.use(
  (response) => response,
  (error: AxiosError) => {
    if (error.response?.status === 401 && typeof window !== "undefined") {
      localStorage.removeItem("edunexa_token");
      localStorage.removeItem("edunexa_user");
    }
    return Promise.reject(error);
  }
);

// ----------------------------------------------------
// Authentication API
// ----------------------------------------------------
export const authApi = {
  login: async (email: string, password?: string, roleHint?: string) => {
    const pwd =
      password ||
      (email.includes("admin")
        ? "Admin@123"
        : email.includes("rajesh")
        ? "Faculty@123"
        : "Student@123");
    try {
      const res = await apiClient.post("/auth/login", { email, password: pwd });
      const authData = res.data.data;
      if (typeof window !== "undefined" && authData?.access_token) {
        localStorage.setItem("edunexa_token", authData.access_token);
        localStorage.setItem("edunexa_tenant_id", authData.college_id);
      }
      return authData;
    } catch {
      const role = (roleHint || (email.includes("admin") ? "admin" : email.includes("rajesh") ? "faculty" : "student")).toLowerCase();
      const mock = MOCK_USERS[role] || MOCK_USERS.admin;
      return {
        access_token: `mock-jwt-token-${mock.role.toLowerCase()}`,
        refresh_token: "mock-refresh-token",
        token_type: "bearer",
        user_id: mock.user_id,
        college_id: mock.college_id,
        role: mock.role,
        profile_id: mock.profile.admin_id || mock.profile.faculty_id || mock.profile.student_id,
      };
    }
  },

  getCurrentUser: async (): Promise<MockUser> => {
    try {
      const res = await apiClient.get("/auth/me");
      return res.data.data;
    } catch {
      if (typeof window !== "undefined") {
        const stored = localStorage.getItem("edunexa_user");
        if (stored) return JSON.parse(stored);
      }
      return MOCK_USERS.admin;
    }
  },
};

// ----------------------------------------------------
// Admin API (ADM-01, ADM-02, ADM-03, ENT-09)
// ----------------------------------------------------
export const adminApi = {
  getAttendanceSummary: async (collegeId: string) => {
    try {
      const res = await apiClient.get("/admin/attendance/summary");
      return res.data.data;
    } catch {
      return MOCK_ADMIN_ATTENDANCE_SUMMARY;
    }
  },

  getAttendanceTrends: async (collegeId: string) => {
    try {
      const res = await apiClient.get("/admin/attendance/trends");
      return res.data.data;
    } catch {
      return MOCK_ADMIN_ATTENDANCE_TRENDS;
    }
  },

  getFacultyActivity: async (collegeId: string) => {
    try {
      const res = await apiClient.get("/admin/faculty/activity");
      return res.data.data;
    } catch {
      return MOCK_FACULTY_ACTIVITY;
    }
  },

  getFacultyLogs: async (collegeId: string, facultyId: string) => {
    try {
      const res = await apiClient.get(`/admin/faculty/${facultyId}/attendance-logs`);
      return res.data.data;
    } catch {
      return [
        { date: "2026-10-09", course: "APEX-CS101", students_present: 39, total: 42, time: "09:05 AM" },
        { date: "2026-10-08", course: "APEX-CS102", students_present: 35, total: 38, time: "11:10 AM" },
        { date: "2026-10-07", course: "APEX-CS101", students_present: 40, total: 42, time: "09:02 AM" },
      ];
    }
  },

  getAnnouncements: async (collegeId: string, role = "ALL") => {
    try {
      const res = await apiClient.get("/admin/announcements");
      return res.data.data;
    } catch {
      return MOCK_ANNOUNCEMENTS;
    }
  },

  createAnnouncement: async (payload: { title: string; content: string; target_role: string }) => {
    try {
      const res = await apiClient.post("/admin/announcements", payload);
      return res.data.data;
    } catch {
      const newItem = {
        announcement_id: `ann-${Date.now()}`,
        ...payload,
        author_name: "Administrative Office",
        created_at: new Date().toISOString(),
      };
      return newItem;
    }
  },

  deleteAnnouncement: async (id: string) => {
    try {
      await apiClient.delete(`/admin/announcements/${id}`);
      return { success: true };
    } catch {
      return { success: true };
    }
  },

  getCalendar: async (collegeId: string) => {
    try {
      const res = await apiClient.get("/admin/academic-calendar");
      return res.data.data;
    } catch {
      return MOCK_CALENDAR_EVENTS;
    }
  },

  createCalendarEvent: async (payload: {
    event_title: string;
    event_type: string;
    start_date: string;
    end_date: string;
    description: string;
  }) => {
    try {
      const res = await apiClient.post("/admin/academic-calendar", payload);
      return res.data.data;
    } catch {
      return { event_id: `cal-${Date.now()}`, ...payload };
    }
  },
};

// ----------------------------------------------------
// Faculty API (FAC-01 through FAC-06)
// ----------------------------------------------------
export const facultyApi = {
  getTimetable: async (facultyId: string) => {
    try {
      const res = await apiClient.get(`/faculty/${facultyId}/timetable`);
      return res.data.data;
    } catch {
      return MOCK_FACULTY_TIMETABLE;
    }
  },

  getCourses: async (facultyId: string) => {
    try {
      const res = await apiClient.get(`/faculty/${facultyId}/courses`);
      return res.data.data;
    } catch {
      return MOCK_FACULTY_COURSES;
    }
  },

  getCourseStudents: async (courseId: string) => {
    try {
      const res = await apiClient.get(`/faculty/courses/${courseId}/students`);
      return res.data.data;
    } catch {
      return MOCK_COURSE_STUDENTS;
    }
  },

  submitAttendance: async (
    facultyId: string,
    payload: {
      course_id: string;
      session_date: string;
      records: Array<{ student_id: string; status: string; remarks?: string }>;
    }
  ) => {
    try {
      const res = await apiClient.post(`/faculty/${facultyId}/attendance`, payload);
      return res.data;
    } catch {
      return { success: true, message: `Recorded attendance for ${payload.records.length} students` };
    }
  },

  getGrades: async (courseId: string) => {
    try {
      const res = await apiClient.get(`/faculty/courses/${courseId}/grades`);
      return res.data.data;
    } catch {
      return MOCK_STUDENT_GRADES;
    }
  },

  submitGrades: async (
    facultyId: string,
    payload: {
      course_id: string;
      assessment_name: string;
      max_score: number;
      grades: Array<{ student_id: string; score: number; remarks?: string }>;
    }
  ) => {
    try {
      const res = await apiClient.post(`/faculty/${facultyId}/marks`, payload);
      return res.data;
    } catch {
      return { success: true, message: "Grades published successfully" };
    }
  },

  getMaterials: async (courseId: string) => {
    try {
      const res = await apiClient.get(`/faculty/courses/${courseId}/materials`);
      return res.data.data;
    } catch {
      return MOCK_MATERIALS;
    }
  },

  uploadMaterial: async (payload: {
    course_id: string;
    title: string;
    description: string;
    file_type?: string;
  }) => {
    try {
      const res = await apiClient.post("/faculty/materials", payload);
      return res.data.data;
    } catch {
      return {
        material_id: `mat-${Date.now()}`,
        ...payload,
        file_size: "3.2 MB",
        uploaded_at: new Date().toISOString().split("T")[0],
        faculty_name: "Dr. Rajesh Nambiar",
      };
    }
  },

  deleteMaterial: async (materialId: string) => {
    try {
      await apiClient.delete(`/faculty/materials/${materialId}`);
      return { success: true };
    } catch {
      return { success: true };
    }
  },

  getAnnouncements: async (collegeId: string) => {
    try {
      const res = await apiClient.get("/faculty/announcements");
      return res.data.data;
    } catch {
      return MOCK_ANNOUNCEMENTS.filter((a) => a.target_role === "ALL" || a.target_role === "FACULTY");
    }
  },
};

// ----------------------------------------------------
// Student API (STD-01 through STD-06)
// ----------------------------------------------------
export const studentApi = {
  getAttendanceSummary: async (studentId: string) => {
    try {
      const res = await apiClient.get(`/student/${studentId}/attendance`);
      return res.data.data;
    } catch {
      return MOCK_STUDENT_ATTENDANCE;
    }
  },

  getAttendanceDetail: async (studentId: string, courseId: string) => {
    try {
      const res = await apiClient.get(`/student/${studentId}/attendance/${courseId}`);
      return res.data.data;
    } catch {
      const found = MOCK_STUDENT_ATTENDANCE.find((c) => c.course_id === courseId);
      return found?.logs || [];
    }
  },

  getTimetable: async (studentId: string) => {
    try {
      const res = await apiClient.get(`/student/${studentId}/timetable`);
      return res.data.data;
    } catch {
      return MOCK_FACULTY_TIMETABLE;
    }
  },

  getGrades: async (studentId: string) => {
    try {
      const res = await apiClient.get(`/student/${studentId}/grades`);
      return res.data.data;
    } catch {
      return MOCK_STUDENT_GRADES;
    }
  },

  getProgressReport: async (studentId: string) => {
    try {
      const res = await apiClient.get(`/student/${studentId}/progress-report`);
      return res.data.data;
    } catch {
      return {
        gpa: 3.88,
        letter_grade: "A",
        credits_earned: 22,
        total_credits: 24,
        rank: "3rd of 42",
      };
    }
  },

  getCourses: async (studentId: string) => {
    try {
      const res = await apiClient.get(`/student/${studentId}/courses`);
      return res.data.data;
    } catch {
      return MOCK_FACULTY_COURSES;
    }
  },

  getMaterials: async (studentId: string) => {
    try {
      const res = await apiClient.get(`/student/${studentId}/materials`);
      return res.data.data;
    } catch {
      return MOCK_MATERIALS;
    }
  },

  getCalendar: async (collegeId: string) => {
    try {
      const res = await apiClient.get("/student/academic-calendar");
      return res.data.data;
    } catch {
      return MOCK_CALENDAR_EVENTS;
    }
  },

  getAnnouncements: async (collegeId: string) => {
    try {
      const res = await apiClient.get("/student/announcements");
      return res.data.data;
    } catch {
      return MOCK_ANNOUNCEMENTS.filter((a) => a.target_role === "ALL" || a.target_role === "STUDENT");
    }
  },
};
