"use client";

import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { adminApi } from "@/lib/api";
import { queryKeys } from "@/lib/queryKeys";
import {
  AttendanceSummaryItem,
  AttendanceTrendItem,
  FacultyActivityItem,
  AnnouncementItem,
  CalendarEventItem,
} from "@/lib/mockData";

export function useAdmin(collegeId?: string) {
  const queryClient = useQueryClient();
  const activeCollegeId =
    collegeId ||
    (typeof window !== "undefined"
      ? localStorage.getItem("edunexa_tenant_id") || "c-apex-01"
      : "c-apex-01");

  // ADM-01: Attendance Summary
  const attendanceSummaryQuery = useQuery<AttendanceSummaryItem[]>({
    queryKey: queryKeys.admin.attendanceSummary(activeCollegeId),
    queryFn: () => adminApi.getAttendanceSummary(activeCollegeId),
  });

  // ADM-01: Attendance Trends
  const attendanceTrendsQuery = useQuery<AttendanceTrendItem[]>({
    queryKey: queryKeys.admin.attendanceTrends(activeCollegeId),
    queryFn: () => adminApi.getAttendanceTrends(activeCollegeId),
  });

  // ADM-03: Faculty Activity
  const facultyActivityQuery = useQuery<FacultyActivityItem[]>({
    queryKey: queryKeys.admin.facultyActivity(activeCollegeId),
    queryFn: () => adminApi.getFacultyActivity(activeCollegeId),
  });

  // ADM-02: Announcements
  const announcementsQuery = useQuery<AnnouncementItem[]>({
    queryKey: queryKeys.admin.announcements(activeCollegeId),
    queryFn: () => adminApi.getAnnouncements(activeCollegeId),
  });

  // ENT-09: Academic Calendar
  const calendarQuery = useQuery<CalendarEventItem[]>({
    queryKey: queryKeys.admin.calendar(activeCollegeId),
    queryFn: () => adminApi.getCalendar(activeCollegeId),
  });

  // Mutations
  const createAnnouncementMutation = useMutation({
    mutationFn: (payload: { title: string; content: string; target_role: string }) =>
      adminApi.createAnnouncement(payload),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: queryKeys.admin.announcements(activeCollegeId) });
      queryClient.invalidateQueries({ queryKey: queryKeys.faculty.announcements(activeCollegeId) });
      queryClient.invalidateQueries({ queryKey: queryKeys.student.announcements(activeCollegeId) });
    },
  });

  const deleteAnnouncementMutation = useMutation({
    mutationFn: (id: string) => adminApi.deleteAnnouncement(id),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: queryKeys.admin.announcements(activeCollegeId) });
    },
  });

  const createCalendarMutation = useMutation({
    mutationFn: (payload: {
      event_title: string;
      event_type: string;
      start_date: string;
      end_date: string;
      description: string;
    }) => adminApi.createCalendarEvent(payload),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: queryKeys.admin.calendar(activeCollegeId) });
      queryClient.invalidateQueries({ queryKey: queryKeys.student.calendar(activeCollegeId) });
    },
  });

  return {
    attendanceSummary: attendanceSummaryQuery.data || [],
    isLoadingSummary: attendanceSummaryQuery.isLoading,
    attendanceTrends: attendanceTrendsQuery.data || [],
    isLoadingTrends: attendanceTrendsQuery.isLoading,
    facultyActivity: facultyActivityQuery.data || [],
    isLoadingFaculty: facultyActivityQuery.isLoading,
    announcements: announcementsQuery.data || [],
    isLoadingAnnouncements: announcementsQuery.isLoading,
    calendarEvents: calendarQuery.data || [],
    isLoadingCalendar: calendarQuery.isLoading,
    createAnnouncement: createAnnouncementMutation.mutateAsync,
    isCreatingAnnouncement: createAnnouncementMutation.isPending,
    deleteAnnouncement: deleteAnnouncementMutation.mutateAsync,
    createCalendarEvent: createCalendarMutation.mutateAsync,
  };
}
