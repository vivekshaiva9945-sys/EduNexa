"use client";
 
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
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
  AssignmentItem,
  ExaminationsData,
  FeeLedgerData,
  MOCK_ASSIGNMENTS,
  MOCK_EXAMINATIONS,
  MOCK_FEE_LEDGER,
} from "@/lib/mockData";

export function useStudent(studentId?: string, collegeId?: string) {
  const queryClient = useQueryClient();
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

  // New Module 1: Assignments
  const assignmentsQuery = useQuery<AssignmentItem[]>({
    queryKey: queryKeys.student.assignments(activeStudentId),
    queryFn: () => studentApi.getAssignments(activeStudentId),
  });

  const submitAssignmentMutation = useMutation({
    mutationFn: ({ assignmentId, payload }: { assignmentId: string; payload: { content?: string; file_url?: string } }) =>
      studentApi.submitAssignment(assignmentId, payload, activeStudentId),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: queryKeys.student.assignments(activeStudentId) });
    },
  });

  // New Module 2: Examinations
  const examinationsQuery = useQuery<ExaminationsData>({
    queryKey: queryKeys.student.examinations(activeStudentId),
    queryFn: () => studentApi.getExaminations(activeStudentId),
  });

  // New Module 3: Fee Ledger
  const feeLedgerQuery = useQuery<FeeLedgerData>({
    queryKey: queryKeys.student.feeLedger(activeStudentId),
    queryFn: () => studentApi.getFeeLedger(activeStudentId),
  });

  const payFeeMutation = useMutation({
    mutationFn: ({ feeId, paymentMethod }: { feeId: string; paymentMethod?: string }) =>
      studentApi.payFeeInvoice(feeId, activeStudentId, paymentMethod),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: queryKeys.student.feeLedger(activeStudentId) });
    },
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

    // Module 1: Assignments
    assignments: assignmentsQuery.data || MOCK_ASSIGNMENTS,
    isLoadingAssignments: assignmentsQuery.isLoading,
    submitAssignment: submitAssignmentMutation.mutateAsync,
    isSubmittingAssignment: submitAssignmentMutation.isPending,

    // Module 2: Examinations
    examinations: examinationsQuery.data || MOCK_EXAMINATIONS,
    isLoadingExaminations: examinationsQuery.isLoading,

    // Module 3: Fee Ledger
    feeLedger: feeLedgerQuery.data || MOCK_FEE_LEDGER,
    isLoadingFeeLedger: feeLedgerQuery.isLoading,
    payFeeInvoice: payFeeMutation.mutateAsync,
    isPayingFee: payFeeMutation.isPending,
  };
}
