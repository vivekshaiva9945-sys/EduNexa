// lib/queryKeys.ts
export const queryKeys = {
  auth: {
    me: ["auth", "me"] as const,
  },
  admin: {
    attendanceSummary: (collegeId: string) =>
      ["admin", collegeId, "attendance", "summary"] as const,
    attendanceTrends: (collegeId: string) =>
      ["admin", collegeId, "attendance", "trends"] as const,
    facultyActivity: (collegeId: string) =>
      ["admin", collegeId, "faculty", "activity"] as const,
    facultyLogs: (collegeId: string, facultyId: string) =>
      ["admin", collegeId, "faculty", facultyId, "logs"] as const,
    announcements: (collegeId: string, role?: string) =>
      ["admin", collegeId, "announcements", role ?? "ALL"] as const,
    calendar: (collegeId: string) =>
      ["admin", collegeId, "calendar"] as const,
  },
  faculty: {
    timetable: (facultyId: string) =>
      ["faculty", facultyId, "timetable"] as const,
    courses: (facultyId: string) =>
      ["faculty", facultyId, "courses"] as const,
    courseStudents: (courseId: string) =>
      ["faculty", "courses", courseId, "students"] as const,
    courseMetrics: (courseId: string) =>
      ["faculty", "courses", courseId, "metrics"] as const,
    grades: (courseId: string) =>
      ["faculty", "courses", courseId, "grades"] as const,
    materials: (courseId: string) =>
      ["faculty", "courses", courseId, "materials"] as const,
    announcements: (collegeId: string) =>
      ["faculty", collegeId, "announcements"] as const,
  },
  student: {
    attendanceSummary: (studentId: string) =>
      ["student", studentId, "attendance", "summary"] as const,
    attendanceDetail: (studentId: string, courseId: string) =>
      ["student", studentId, "attendance", courseId] as const,
    timetable: (studentId: string) =>
      ["student", studentId, "timetable"] as const,
    grades: (studentId: string) =>
      ["student", studentId, "grades"] as const,
    progressReport: (studentId: string) =>
      ["student", studentId, "progressReport"] as const,
    courses: (studentId: string) =>
      ["student", studentId, "courses"] as const,
    materials: (studentId: string) =>
      ["student", studentId, "materials"] as const,
    calendar: (collegeId: string) =>
      ["student", collegeId, "calendar"] as const,
    announcements: (collegeId: string) =>
      ["student", collegeId, "announcements"] as const,
  },
};
