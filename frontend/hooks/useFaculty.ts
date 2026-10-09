"use client";

import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { facultyApi } from "@/lib/api";
import { queryKeys } from "@/lib/queryKeys";
import {
  TimetableSlotItem,
  CourseItem,
  AnnouncementItem,
  StudentRosterItem,
} from "@/lib/mockData";

export function useFaculty(facultyId: string = "fac-001", collegeId: string = "c-apex-01") {
  const queryClient = useQueryClient();

  // FAC-02: Timetable
  const timetableQuery = useQuery<TimetableSlotItem[]>({
    queryKey: queryKeys.faculty.timetable(facultyId),
    queryFn: () => facultyApi.getTimetable(facultyId),
  });

  // FAC-02, FAC-03: Courses
  const coursesQuery = useQuery<CourseItem[]>({
    queryKey: queryKeys.faculty.courses(facultyId),
    queryFn: () => facultyApi.getCourses(facultyId),
  });

  // FAC-06: Announcements
  const announcementsQuery = useQuery<AnnouncementItem[]>({
    queryKey: queryKeys.faculty.announcements(collegeId),
    queryFn: () => facultyApi.getAnnouncements(collegeId),
  });

  const getCourseStudents = (courseId: string): Promise<StudentRosterItem[]> =>
    facultyApi.getCourseStudents(courseId);

  // FAC-01: Submit Attendance Mutation
  const submitAttendanceMutation = useMutation({
    mutationFn: (payload: {
      course_id: string;
      session_date: string;
      records: Array<{ student_id: string; status: string; remarks?: string }>;
    }) => facultyApi.submitAttendance(facultyId, payload),
    onSuccess: (_, variables) => {
      queryClient.invalidateQueries({
        queryKey: queryKeys.faculty.courseMetrics(variables.course_id),
      });
      queryClient.invalidateQueries({
        queryKey: queryKeys.admin.attendanceSummary(collegeId),
      });
    },
  });

  // FAC-04: Submit Grades Mutation
  const submitGradesMutation = useMutation({
    mutationFn: (payload: {
      course_id: string;
      assessment_name: string;
      max_score: number;
      grades: Array<{ student_id: string; score: number; remarks?: string }>;
    }) => facultyApi.submitGrades(facultyId, payload),
    onSuccess: (_, variables) => {
      queryClient.invalidateQueries({
        queryKey: queryKeys.faculty.grades(variables.course_id),
      });
    },
  });

  // FAC-05: Upload Material Mutation
  const uploadMaterialMutation = useMutation({
    mutationFn: (payload: {
      course_id: string;
      title: string;
      description: string;
      file_type?: string;
    }) => facultyApi.uploadMaterial(payload),
    onSuccess: (_, variables) => {
      queryClient.invalidateQueries({
        queryKey: queryKeys.faculty.materials(variables.course_id),
      });
    },
  });

  return {
    timetable: timetableQuery.data || [],
    isLoadingTimetable: timetableQuery.isLoading,
    courses: coursesQuery.data || [],
    isLoadingCourses: coursesQuery.isLoading,
    announcements: announcementsQuery.data || [],
    isLoadingAnnouncements: announcementsQuery.isLoading,
    getCourseStudents,
    submitAttendance: submitAttendanceMutation.mutateAsync,
    isSubmittingAttendance: submitAttendanceMutation.isPending,
    submitGrades: submitGradesMutation.mutateAsync,
    isSubmittingGrades: submitGradesMutation.isPending,
    uploadMaterial: uploadMaterialMutation.mutateAsync,
    isUploadingMaterial: uploadMaterialMutation.isPending,
  };
}
