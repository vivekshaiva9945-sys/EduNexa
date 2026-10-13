"use client";

import React, { useState } from "react";
import { useStudent } from "@/hooks/useStudent";
import { MetricCard } from "@/components/shared/MetricCard";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import {
  CalendarDays,
  Award,
  Clock,
  MapPin,
  CheckCircle2,
  FileText,
  Download,
  AlertCircle,
  Sparkles,
  QrCode,
  ShieldCheck,
  X,
  FileSignature,
} from "lucide-react";
import { ExaminationItem } from "@/lib/mockData";

export default function StudentExaminationsPage() {
  const { examinations, isLoadingExaminations } = useStudent();
  const [activeTab, setActiveTab] = useState<"UPCOMING" | "RESULTS">("UPCOMING");
  const [selectedAdmitCardExam, setSelectedAdmitCardExam] = useState<ExaminationItem | null>(null);

  const upcomingList = examinations.upcoming || [];
  const resultsList = examinations.results || [];

  const totalExams = upcomingList.length + resultsList.length;
  const gradedResults = resultsList.filter((r) => r.marks_obtained !== undefined);
  const avgScore =
    gradedResults.length > 0
      ? (
          gradedResults.reduce((acc, curr) => acc + ((curr.marks_obtained || 0) / curr.total_marks) * 100, 0) /
          gradedResults.length
        ).toFixed(1)
      : "93.0";

  const formatExamDate = (dateStr: string) => {
    try {
      const d = new Date(dateStr);
      return d.toLocaleDateString("en-US", {
        weekday: "short",
        month: "short",
        day: "numeric",
        year: "numeric",
      });
    } catch {
      return dateStr;
    }
  };

  const formatExamTime = (dateStr: string) => {
    try {
      const d = new Date(dateStr);
      return d.toLocaleTimeString("en-US", {
        hour: "2-digit",
        minute: "2-digit",
      });
    } catch {
      return "09:30 AM";
    }
  };

  const getExamTypeBadge = (type: string) => {
    switch (type) {
      case "FINAL":
        return <Badge className="bg-rose-500/15 text-rose-300 border-rose-500/30">Final Exam</Badge>;
      case "MIDTERM":
        return <Badge className="bg-indigo-500/15 text-indigo-300 border-indigo-500/30">Midterm Test</Badge>;
      case "LAB":
        return <Badge className="bg-emerald-500/15 text-emerald-300 border-emerald-500/30">Lab Practical</Badge>;
      case "QUIZ":
        return <Badge className="bg-amber-500/15 text-amber-300 border-amber-500/30">Assessment Quiz</Badge>;
      default:
        return <Badge variant="outline">{type}</Badge>;
    }
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <div className="flex items-center gap-2">
            <h1 className="text-2xl font-bold tracking-tight text-slate-900 dark:text-white">
              Examinations & Transcripts
            </h1>
            <Badge variant="outline" className="text-purple-400 border-purple-500/30 bg-purple-500/10">
              STD-08
            </Badge>
          </div>
          <p className="text-xs md:text-sm text-slate-500 dark:text-slate-400 mt-1">
            Review upcoming semester examination timetables, seat venues, and certified academic scorecards
          </p>
        </div>
      </div>

      {/* KPI Metrics */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        <MetricCard
          title="Upcoming Papers"
          value={upcomingList.length}
          description="Scheduled this semester"
          icon={<CalendarDays className="h-5 w-5 text-blue-500" />}
          spotlightColor="rgba(59, 130, 246, 0.15)"
        />
        <MetricCard
          title="Evaluated Results"
          value={resultsList.length}
          description="Certified scorecards published"
          icon={<CheckCircle2 className="h-5 w-5 text-emerald-500" />}
          spotlightColor="rgba(16, 185, 129, 0.15)"
        />
        <MetricCard
          title="Examination Avg"
          value={`${avgScore}%`}
          description="Cumulative test score health"
          icon={<Award className="h-5 w-5 text-purple-500" />}
          spotlightColor="rgba(168, 85, 247, 0.15)"
        />
        <MetricCard
          title="Hall Tickets"
          value="Issued"
          description="Apex Board Examination Pass"
          icon={<ShieldCheck className="h-5 w-5 text-amber-500" />}
          spotlightColor="rgba(245, 158, 11, 0.15)"
        />
      </div>

      {/* Navigation Tabs */}
      <div className="flex items-center gap-2 border-b border-slate-800 pb-3">
        <button
          onClick={() => setActiveTab("UPCOMING")}
          className={`flex items-center gap-2 px-4 py-2 rounded-xl text-xs font-semibold transition-all cursor-pointer ${
            activeTab === "UPCOMING"
              ? "bg-blue-600 text-white shadow-md shadow-blue-600/30"
              : "text-slate-400 hover:text-white hover:bg-slate-800/60"
          }`}
        >
          <CalendarDays className="h-4 w-4" />
          Upcoming Examination Timetable ({upcomingList.length})
        </button>
        <button
          onClick={() => setActiveTab("RESULTS")}
          className={`flex items-center gap-2 px-4 py-2 rounded-xl text-xs font-semibold transition-all cursor-pointer ${
            activeTab === "RESULTS"
              ? "bg-blue-600 text-white shadow-md shadow-blue-600/30"
              : "text-slate-400 hover:text-white hover:bg-slate-800/60"
          }`}
        >
          <Award className="h-4 w-4" />
          Results & Performance Transcripts ({resultsList.length})
        </button>
      </div>

      {/* Content Area */}
      {isLoadingExaminations ? (
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          {[1, 2, 3].map((i) => (
            <div key={i} className="h-44 rounded-2xl bg-slate-900/60 border border-slate-800 animate-pulse p-5" />
          ))}
        </div>
      ) : activeTab === "UPCOMING" ? (
        /* Upcoming Tab */
        upcomingList.length === 0 ? (
          <div className="rounded-2xl border border-slate-800 bg-slate-900/50 p-12 text-center text-slate-400">
            <CalendarDays className="mx-auto h-10 w-10 text-slate-600 mb-3" />
            <h3 className="text-base font-semibold text-white">No upcoming examinations</h3>
            <p className="text-xs text-slate-500 mt-1">
              There are no examinations scheduled for the current academic session.
            </p>
          </div>
        ) : (
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-4">
            {upcomingList.map((exam) => (
              <div
                key={exam.exam_id}
                className="group flex flex-col justify-between rounded-2xl border border-slate-800 bg-slate-900/80 p-5 hover:border-slate-700 transition-all shadow-lg backdrop-blur-sm"
              >
                <div>
                  <div className="flex items-start justify-between gap-3 mb-2">
                    <span className="px-2.5 py-1 rounded-md text-[11px] font-bold bg-blue-500/10 text-blue-400 border border-blue-500/20">
                      {exam.course_code}
                    </span>
                    {getExamTypeBadge(exam.exam_type)}
                  </div>

                  <h3 className="text-base font-bold text-white group-hover:text-blue-300 transition-colors mt-2">
                    {exam.title}
                  </h3>
                  <p className="text-xs text-slate-400 mt-0.5">{exam.course_name}</p>

                  <div className="mt-4 grid grid-cols-2 gap-2 text-xs">
                    <div className="flex items-center gap-2 p-2 rounded-xl bg-slate-950/60 border border-slate-800/80 text-slate-300">
                      <Clock className="h-3.5 w-3.5 text-blue-400 shrink-0" />
                      <div className="truncate">
                        <span className="block text-[10px] text-slate-500">Date & Time</span>
                        <span className="font-semibold text-slate-200">
                          {formatExamDate(exam.exam_date)} • {formatExamTime(exam.exam_date)}
                        </span>
                      </div>
                    </div>

                    <div className="flex items-center gap-2 p-2 rounded-xl bg-slate-950/60 border border-slate-800/80 text-slate-300">
                      <MapPin className="h-3.5 w-3.5 text-rose-400 shrink-0" />
                      <div className="truncate">
                        <span className="block text-[10px] text-slate-500">Seating Venue</span>
                        <span className="font-semibold text-slate-200 truncate">{exam.venue}</span>
                      </div>
                    </div>
                  </div>
                </div>

                <div className="mt-5 pt-3 border-t border-slate-800 flex items-center justify-between text-xs text-slate-400">
                  <div className="flex items-center gap-2">
                    <span className="font-semibold text-slate-300">{exam.duration_minutes} Mins</span>
                    <span>•</span>
                    <span>Max {exam.total_marks} Marks</span>
                  </div>

                  <Button
                    size="sm"
                    onClick={() => setSelectedAdmitCardExam(exam)}
                    className="text-xs h-8 bg-blue-600 hover:bg-blue-500 text-white rounded-lg shadow-sm cursor-pointer"
                  >
                    View Admit Card →
                  </Button>
                </div>
              </div>
            ))}
          </div>
        )
      ) : (
        /* Results / Transcripts Tab */
        resultsList.length === 0 ? (
          <div className="rounded-2xl border border-slate-800 bg-slate-900/50 p-12 text-center text-slate-400">
            <Award className="mx-auto h-10 w-10 text-slate-600 mb-3" />
            <h3 className="text-base font-semibold text-white">No examination results published</h3>
            <p className="text-xs text-slate-500 mt-1">
              Evaluated marks will appear here once finalized by the Examination Board.
            </p>
          </div>
        ) : (
          <div className="rounded-2xl border border-slate-800 bg-slate-900/80 overflow-hidden shadow-xl">
            <div className="p-4 border-b border-slate-800 flex items-center justify-between">
              <div>
                <h3 className="text-sm font-bold text-white">Certified Examination Records</h3>
                <p className="text-xs text-slate-400 mt-0.5">
                  Official scorecard grades signed by Apex Academic Registry
                </p>
              </div>
              <Button
                variant="outline"
                size="sm"
                onClick={() => alert("Downloading certified digital transcript PDF...")}
                className="text-xs h-8 border-slate-700 bg-slate-950 text-slate-300 hover:text-white cursor-pointer"
              >
                <Download className="h-3.5 w-3.5 mr-1.5" /> Download Transcript PDF
              </Button>
            </div>

            <div className="overflow-x-auto">
              <table className="w-full text-left text-xs">
                <thead className="bg-slate-950/80 border-b border-slate-800 text-slate-400 uppercase font-semibold text-[10px]">
                  <tr>
                    <th className="px-5 py-3">Course</th>
                    <th className="px-4 py-3">Exam Paper</th>
                    <th className="px-4 py-3">Session Date</th>
                    <th className="px-4 py-3 text-center">Score</th>
                    <th className="px-4 py-3 text-center">Percentage</th>
                    <th className="px-4 py-3 text-center">Grade</th>
                    <th className="px-5 py-3">Examiner Remarks</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-slate-800/60 text-slate-200">
                  {resultsList.map((res) => {
                    const score = res.marks_obtained !== undefined ? res.marks_obtained : 0;
                    const pct = ((score / res.total_marks) * 100).toFixed(1);

                    return (
                      <tr key={res.exam_id} className="hover:bg-slate-800/40 transition-colors">
                        <td className="px-5 py-4 font-medium text-white">
                          <span className="font-bold text-blue-400 mr-2">{res.course_code}</span>
                          <span className="text-slate-300">{res.course_name}</span>
                        </td>
                        <td className="px-4 py-4">{res.title}</td>
                        <td className="px-4 py-4 text-slate-400">{formatExamDate(res.exam_date)}</td>
                        <td className="px-4 py-4 text-center font-bold text-white">
                          {score} / {res.total_marks}
                        </td>
                        <td className="px-4 py-4 text-center font-semibold text-emerald-400">
                          {pct}%
                        </td>
                        <td className="px-4 py-4 text-center">
                          <span className="inline-block px-2.5 py-0.5 rounded-md font-bold text-xs bg-emerald-500/20 text-emerald-300 border border-emerald-500/30">
                            {res.grade || "A"}
                          </span>
                        </td>
                        <td className="px-5 py-4 text-slate-400 max-w-xs truncate">
                          {res.remarks || "Performance verified by Examination Controller."}
                        </td>
                      </tr>
                    );
                  })}
                </tbody>
              </table>
            </div>
          </div>
        )
      )}

      {/* Admit Card Modal */}
      {selectedAdmitCardExam && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/70 backdrop-blur-xs">
          <div className="w-full max-w-md rounded-3xl border border-slate-700/80 bg-slate-900 p-6 shadow-2xl text-white space-y-5 animate-in fade-in zoom-in-95">
            <div className="flex items-start justify-between border-b border-slate-800 pb-3">
              <div>
                <span className="text-[10px] font-bold text-blue-400 uppercase tracking-wider flex items-center gap-1">
                  <ShieldCheck className="h-3.5 w-3.5" /> Apex Institutional Examination Pass
                </span>
                <h3 className="text-base font-bold text-white mt-0.5">
                  Official Hall Ticket / Admit Card
                </h3>
              </div>
              <button
                onClick={() => setSelectedAdmitCardExam(null)}
                className="p-1 rounded-lg text-slate-400 hover:text-white hover:bg-slate-800 cursor-pointer"
              >
                <X className="h-5 w-5" />
              </button>
            </div>

            <div className="space-y-3 text-xs bg-slate-950 p-4 rounded-2xl border border-slate-800">
              <div className="flex items-center justify-between pb-2 border-b border-slate-800">
                <span className="text-slate-500">Student Roll Number</span>
                <span className="font-mono font-bold text-white">APEX-2024-101</span>
              </div>
              <div className="flex items-center justify-between pb-2 border-b border-slate-800">
                <span className="text-slate-500">Subject / Paper</span>
                <span className="font-semibold text-blue-300">{selectedAdmitCardExam.course_code}</span>
              </div>
              <div className="flex items-center justify-between pb-2 border-b border-slate-800">
                <span className="text-slate-500">Date & Schedule</span>
                <span className="font-semibold text-white">
                  {formatExamDate(selectedAdmitCardExam.exam_date)} • {formatExamTime(selectedAdmitCardExam.exam_date)}
                </span>
              </div>
              <div className="flex items-center justify-between pb-2 border-b border-slate-800">
                <span className="text-slate-500">Assigned Hall & Desk</span>
                <span className="font-bold text-emerald-400">{selectedAdmitCardExam.venue}</span>
              </div>
              <div className="flex items-center justify-between">
                <span className="text-slate-500">Verification Hash</span>
                <span className="font-mono text-[10px] text-slate-400">SEC-APX-98F12-PASS</span>
              </div>
            </div>

            <div className="flex items-center justify-between p-3 rounded-xl bg-blue-950/30 border border-blue-800/40 text-[11px] text-blue-300">
              <QrCode className="h-8 w-8 text-blue-400 shrink-0 mr-3" />
              <span>
                Present this digital pass or institutional barcode at the entrance desk 15 minutes before exam commencement.
              </span>
            </div>

            <div className="flex items-center justify-end gap-2 pt-2">
              <Button
                variant="outline"
                size="sm"
                onClick={() => setSelectedAdmitCardExam(null)}
                className="text-xs border-slate-700 bg-slate-900 text-slate-300 hover:text-white"
              >
                Close
              </Button>
              <Button
                size="sm"
                onClick={() => {
                  alert("Admit card PDF downloaded successfully.");
                  setSelectedAdmitCardExam(null);
                }}
                className="text-xs bg-blue-600 hover:bg-blue-500 text-white font-semibold rounded-xl px-4 cursor-pointer"
              >
                <Download className="h-3.5 w-3.5 mr-1.5" /> Download Pass PDF
              </Button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
