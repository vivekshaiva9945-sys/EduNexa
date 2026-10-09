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

export function useAdmin(collegeId: string = "c-apex-01") {
  const queryClient = useQueryClient();

  // ADM-01: Attendance Summary
  const attendanceSummaryQuery = useQuery<AttendanceSummaryItem[]>({
    queryKey: queryKeys.admin.attendanceSummary(collegeId),
    queryFn: () => adminApi.getAttendanceSummary(collegeId),
  });

  // ADM-01: Attendance Trends
  const attendanceTrendsQuery = useQuery<AttendanceTrendItem[]>({
    queryKey: queryKeys.admin.attendanceTrends(collegeId),
    queryFn: () => adminApi.getAttendanceTrends(collegeId),
  });

  // ADM-03: Faculty Activity
  const facultyActivityQuery = useQuery<FacultyActivityItem[]>({
    queryKey: queryKeys.admin.facultyActivity(collegeId),
    queryFn: () => adminApi.getFacultyActivity(collegeId),
  });

  // ADM-02: Announcements
  const announcementsQuery = useQuery<AnnouncementItem[]>({
    queryKey: queryKeys.admin.announcements(collegeId),
    queryFn: () => adminApi.getAnnouncements(collegeId),
  });

  // ENT-09: Academic Calendar
  const calendarQuery = useQuery<CalendarEventItem[]>({
    queryKey: queryKeys.admin.calendar(collegeId),
    queryFn: () => adminApi.getCalendar(collegeId),
  });

  // Mutations
  const createAnnouncementMutation = useMutation({
    mutationFn: (payload: { title: string; content: string; target_role: string }) =>
      adminApi.createAnnouncement(payload),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: queryKeys.admin.announcements(collegeId) });
      queryClient.invalidateQueries({ queryKey: queryKeys.faculty.announcements(collegeId) });
      queryClient.invalidateQueries({ queryKey: queryKeys.student.announcements(collegeId) });
    },
  });

  const deleteAnnouncementMutation = useMutation({
    mutationFn: (id: string) => adminApi.deleteAnnouncement(id),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: queryKeys.admin.announcements(collegeId) });
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
      queryClient.invalidateQueries({ queryKey: queryKeys.admin.calendar(collegeId) });
      queryClient.invalidateQueries({ queryKey: queryKeys.student.calendar(collegeId) });
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
