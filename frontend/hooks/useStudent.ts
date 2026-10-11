"use client";

import { useQuery } from "@tanstack/react-query";
import { studentApi } from "@/lib/api";
import { queryKeys } from "@/lib/queryKeys";
import {
  StudentAttendanceItem,
  TimetableSlotItem,
  StudentGradeItem,
  ProgressReportItem,
  MaterialItem,
  CalendarEventItem,
  AnnouncementItem,
} from "@/lib/mockData";

export function useStudent(studentId?: string, collegeId?: string) {
  const activeStudentId = studentId || "me";
  const activeCollegeId =
    collegeId ||
    (typeof window !== "undefined"
      ? localStorage.getItem("edunexa_tenant_id") || "c-apex-01"
      : "c-apex-01");

  const attendanceQuery = useQuery<StudentAttendanceItem[]>({
    queryKey: queryKeys.student.attendanceSummary(activeStudentId),
    queryFn: () => studentApi.getAttendanceSummary(activeStudentId),
  });

  const timetableQuery = useQuery<TimetableSlotItem[]>({
    queryKey: queryKeys.student.timetable(activeStudentId),
    queryFn: () => studentApi.getTimetable(activeStudentId),
  });

  const gradesQuery = useQuery<StudentGradeItem[]>({
    queryKey: queryKeys.student.grades(activeStudentId),
    queryFn: () => studentApi.getGrades(activeStudentId),
  });

  const progressReportQuery = useQuery<ProgressReportItem>({
    queryKey: queryKeys.student.progressReport(activeStudentId),
    queryFn: () => studentApi.getProgressReport(activeStudentId),
  });

  const materialsQuery = useQuery<MaterialItem[]>({
    queryKey: queryKeys.student.materials(activeStudentId),
    queryFn: () => studentApi.getMaterials(activeStudentId),
  });

  const calendarQuery = useQuery<CalendarEventItem[]>({
    queryKey: queryKeys.student.calendar(activeCollegeId),
    queryFn: () => studentApi.getCalendar(activeCollegeId),
  });

  const announcementsQuery = useQuery<AnnouncementItem[]>({
    queryKey: queryKeys.student.announcements(activeCollegeId),
    queryFn: () => studentApi.getAnnouncements(activeCollegeId),
  });

  return {
    attendance: attendanceQuery.data || [],
    isLoadingAttendance: attendanceQuery.isLoading,
    timetable: timetableQuery.data || [],
    isLoadingTimetable: timetableQuery.isLoading,
    grades: gradesQuery.data || [],
    isLoadingGrades: gradesQuery.isLoading,
    progressReport: progressReportQuery.data || { gpa: 3.88, letter_grade: "A", credits_earned: 22, total_credits: 24 },
    isLoadingProgress: progressReportQuery.isLoading,
    materials: materialsQuery.data || [],
    isLoadingMaterials: materialsQuery.isLoading,
    calendar: calendarQuery.data || [],
    isLoadingCalendar: calendarQuery.isLoading,
    announcements: announcementsQuery.data || [],
    isLoadingAnnouncements: announcementsQuery.isLoading,
  };
}
