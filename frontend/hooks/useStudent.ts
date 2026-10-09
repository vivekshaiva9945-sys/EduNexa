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

export function useStudent(studentId: string = "std-001", collegeId: string = "c-apex-01") {
  const attendanceQuery = useQuery<StudentAttendanceItem[]>({
    queryKey: queryKeys.student.attendanceSummary(studentId),
    queryFn: () => studentApi.getAttendanceSummary(studentId),
  });

  const timetableQuery = useQuery<TimetableSlotItem[]>({
    queryKey: queryKeys.student.timetable(studentId),
    queryFn: () => studentApi.getTimetable(studentId),
  });

  const gradesQuery = useQuery<StudentGradeItem[]>({
    queryKey: queryKeys.student.grades(studentId),
    queryFn: () => studentApi.getGrades(studentId),
  });

  const progressReportQuery = useQuery<ProgressReportItem>({
    queryKey: queryKeys.student.progressReport(studentId),
    queryFn: () => studentApi.getProgressReport(studentId),
  });

  const materialsQuery = useQuery<MaterialItem[]>({
    queryKey: queryKeys.student.materials(studentId),
    queryFn: () => studentApi.getMaterials(studentId),
  });

  const calendarQuery = useQuery<CalendarEventItem[]>({
    queryKey: queryKeys.student.calendar(collegeId),
    queryFn: () => studentApi.getCalendar(collegeId),
  });

  const announcementsQuery = useQuery<AnnouncementItem[]>({
    queryKey: queryKeys.student.announcements(collegeId),
    queryFn: () => studentApi.getAnnouncements(collegeId),
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
