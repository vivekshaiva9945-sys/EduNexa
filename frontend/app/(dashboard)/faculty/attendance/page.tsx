"use client";

import React, { useState, useEffect } from "react";
import { useFaculty } from "@/hooks/useFaculty";
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Input } from "@/components/ui/input";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { CheckCircle2, XCircle, Clock, Check, AlertCircle } from "lucide-react";

export default function FacultyAttendancePage() {
  const { courses, getCourseStudents, submitAttendance, isSubmittingAttendance } =
    useFaculty();

  const [selectedCourse, setSelectedCourse] = useState("crs-cs101");
  const [sessionDate, setSessionDate] = useState("2026-10-09");
  const [students, setStudents] = useState<any[]>([]);
  const [attendanceState, setAttendanceState] = useState<
    Record<string, { status: "PRESENT" | "ABSENT" | "LATE"; remarks: string }>
  >({});
  const [submittedMessage, setSubmittedMessage] = useState<string | null>(null);

  useEffect(() => {
    async function loadRoster() {
      const roster = await getCourseStudents(selectedCourse);
      setStudents(roster);
      const initial: Record<string, any> = {};
      roster.forEach((s: any) => {
        initial[s.student_id] = {
          status: s.status || "PRESENT",
          remarks: "",
        };
      });
      setAttendanceState(initial);
      setSubmittedMessage(null);
    }
    loadRoster();
  }, [selectedCourse]);

  const setAllStatus = (status: "PRESENT" | "ABSENT") => {
    setAttendanceState((prev) => {
      const next = { ...prev };
      students.forEach((s) => {
        next[s.student_id] = {
          status,
          remarks: next[s.student_id]?.remarks || "",
        };
      });
      return next;
    });
  };

  const setStudentStatus = (
    studentId: string,
    status: "PRESENT" | "ABSENT" | "LATE"
  ) => {
    setAttendanceState((prev) => ({
      ...prev,
      [studentId]: {
        status,
        remarks: prev[studentId]?.remarks || "",
      },
    }));
  };

  const handleRemarksChange = (studentId: string, remarks: string) => {
    setAttendanceState((prev) => ({
      ...prev,
      [studentId]: {
        status: prev[studentId]?.status || "PRESENT",
        remarks,
      },
    }));
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    const records = Object.entries(attendanceState).map(([student_id, val]) => ({
      student_id,
      status: val.status,
      remarks: val.remarks,
    }));

    await submitAttendance({
      course_id: selectedCourse,
      session_date: sessionDate,
      records,
    });

    const presentCount = records.filter((r) => r.status === "PRESENT").length;
    setSubmittedMessage(
      `Attendance successfully logged for ${records.length} students (${presentCount} Present, ${records.length - presentCount} Absent/Late).`
    );
  };

  return (
    <div className="space-y-6">
      <div>
        <h2 className="text-2xl font-bold tracking-tight text-slate-900">
          Daily Attendance Marking Station
        </h2>
        <p className="text-xs sm:text-sm text-slate-500 mt-1">
          Requirements FAC-01 & FAC-03: Record and moderate course attendance registers.
        </p>
      </div>

      {submittedMessage && (
        <div className="flex items-center gap-3 p-4 rounded-xl border border-emerald-200 bg-emerald-50 text-emerald-800 text-sm animate-in fade-in duration-200">
          <CheckCircle2 className="h-5 w-5 text-emerald-600 shrink-0" />
          <span>{submittedMessage}</span>
        </div>
      )}

      {/* Control Station */}
      <Card>
        <CardHeader className="pb-3">
          <CardTitle>Register Session Parameters</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div className="space-y-1.5">
              <label className="text-xs font-semibold text-slate-700">
                Course Section
              </label>
              <select
                value={selectedCourse}
                onChange={(e) => setSelectedCourse(e.target.value)}
                className="flex h-9 w-full rounded-lg border border-slate-200 bg-white px-3 py-1 text-sm text-slate-900 focus:outline-none focus:ring-2 focus:ring-blue-500"
              >
                {courses.map((c) => (
                  <option key={c.course_id} value={c.course_id}>
                    {c.course_code} — {c.course_name} ({c.semester})
                  </option>
                ))}
              </select>
            </div>

            <div className="space-y-1.5">
              <label className="text-xs font-semibold text-slate-700">
                Session Date
              </label>
              <Input
                type="date"
                value={sessionDate}
                onChange={(e) => setSessionDate(e.target.value)}
              />
            </div>
          </div>
        </CardContent>
      </Card>

      {/* Student Roster Table */}
      <Card>
        <CardHeader className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3 pb-3">
          <div>
            <CardTitle>Enrolled Student Roster</CardTitle>
            <p className="text-xs text-slate-500">
              Total {students.length} students enrolled in section
            </p>
          </div>
          <div className="flex items-center gap-2">
            <Button
              type="button"
              variant="outline"
              size="sm"
              onClick={() => setAllStatus("PRESENT")}
              className="text-xs text-emerald-700 border-emerald-200 hover:bg-emerald-50"
            >
              Mark All Present
            </Button>
            <Button
              type="button"
              variant="outline"
              size="sm"
              onClick={() => setAllStatus("ABSENT")}
              className="text-xs text-rose-700 border-rose-200 hover:bg-rose-50"
            >
              Mark All Absent
            </Button>
          </div>
        </CardHeader>
        <CardContent>
          <div className="overflow-x-auto rounded-lg border border-slate-100">
            <Table>
              <TableHeader className="bg-slate-50/70">
                <TableRow>
                  <TableHead>Roll Number</TableHead>
                  <TableHead>Student Name</TableHead>
                  <TableHead>Attendance Rate</TableHead>
                  <TableHead className="text-center">Status Toggle</TableHead>
                  <TableHead>Remarks</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {students.map((student) => {
                  const currentStatus =
                    attendanceState[student.student_id]?.status || "PRESENT";
                  const currentRemarks =
                    attendanceState[student.student_id]?.remarks || "";

                  return (
                    <TableRow key={student.student_id}>
                      <TableCell className="font-mono text-xs font-semibold text-blue-600">
                        {student.roll_number}
                      </TableCell>
                      <TableCell>
                        <span className="font-medium text-slate-900 block">
                          {student.first_name} {student.last_name}
                        </span>
                        <span className="text-[11px] text-slate-400">
                          {student.email}
                        </span>
                      </TableCell>
                      <TableCell>
                        <Badge
                          variant={
                            student.attendance_rate >= 75 ? "success" : "destructive"
                          }
                        >
                          {student.attendance_rate}%
                        </Badge>
                      </TableCell>
                      <TableCell>
                        <div className="flex items-center justify-center gap-1.5">
                          <button
                            type="button"
                            onClick={() =>
                              setStudentStatus(student.student_id, "PRESENT")
                            }
                            className={`px-2.5 py-1 rounded text-xs font-bold transition-all cursor-pointer ${
                              currentStatus === "PRESENT"
                                ? "bg-emerald-600 text-white shadow-xs"
                                : "bg-slate-100 text-slate-600 hover:bg-emerald-100"
                            }`}
                          >
                            P
                          </button>
                          <button
                            type="button"
                            onClick={() =>
                              setStudentStatus(student.student_id, "ABSENT")
                            }
                            className={`px-2.5 py-1 rounded text-xs font-bold transition-all cursor-pointer ${
                              currentStatus === "ABSENT"
                                ? "bg-rose-600 text-white shadow-xs"
                                : "bg-slate-100 text-slate-600 hover:bg-rose-100"
                            }`}
                          >
                            A
                          </button>
                          <button
                            type="button"
                            onClick={() =>
                              setStudentStatus(student.student_id, "LATE")
                            }
                            className={`px-2.5 py-1 rounded text-xs font-bold transition-all cursor-pointer ${
                              currentStatus === "LATE"
                                ? "bg-amber-500 text-white shadow-xs"
                                : "bg-slate-100 text-slate-600 hover:bg-amber-100"
                            }`}
                          >
                            L
                          </button>
                        </div>
                      </TableCell>
                      <TableCell>
                        <Input
                          placeholder="Optional remarks..."
                          value={currentRemarks}
                          onChange={(e) =>
                            handleRemarksChange(
                              student.student_id,
                              e.target.value
                            )
                          }
                          className="h-8 text-xs max-w-xs"
                        />
                      </TableCell>
                    </TableRow>
                  );
                })}
              </TableBody>
            </Table>
          </div>

          <div className="mt-5 flex justify-end">
            <Button
              onClick={handleSubmit}
              disabled={isSubmittingAttendance}
              className="bg-blue-600 hover:bg-blue-700 text-white px-6 font-semibold"
            >
              <Check className="mr-2 h-4 w-4" />
              {isSubmittingAttendance ? "Saving..." : "Submit Attendance"}
            </Button>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
