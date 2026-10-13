"use client";

import React, { useState } from "react";
import { useStudent } from "@/hooks/useStudent";
import { MetricCard } from "@/components/shared/MetricCard";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Input } from "@/components/ui/input";
import {
  FileText,
  CheckCircle2,
  Clock,
  AlertTriangle,
  Upload,
  Search,
  ExternalLink,
  BookOpen,
  Calendar,
  Award,
  Sparkles,
  ChevronRight,
  X,
  FileCheck,
} from "lucide-react";
import { AssignmentItem } from "@/lib/mockData";

export default function StudentAssignmentsPage() {
  const {
    assignments,
    isLoadingAssignments,
    submitAssignment,
    isSubmittingAssignment,
  } = useStudent();

  const [activeTab, setActiveTab] = useState<"ALL" | "PENDING" | "SUBMITTED" | "GRADED" | "OVERDUE">("ALL");
  const [searchQuery, setSearchQuery] = useState("");
  const [selectedAssignment, setSelectedAssignment] = useState<AssignmentItem | null>(null);
  const [submissionContent, setSubmissionContent] = useState("");
  const [submissionFileUrl, setSubmissionFileUrl] = useState("");
  const [submitSuccess, setSubmitSuccess] = useState<string | null>(null);

  // Filter calculations
  const totalCount = assignments.length;
  const submittedCount = assignments.filter((a) => a.status === "SUBMITTED" || a.status === "GRADED").length;
  const gradedCount = assignments.filter((a) => a.status === "GRADED").length;
  const pendingCount = assignments.filter((a) => a.status === "PENDING" || a.status === "LATE").length;

  const gradedItems = assignments.filter((a) => a.status === "GRADED" && a.marks_obtained !== undefined);
  const avgGradedScore =
    gradedItems.length > 0
      ? (gradedItems.reduce((acc, curr) => acc + (curr.marks_obtained || 0), 0) / gradedItems.length).toFixed(1)
      : "94.5";

  const filteredAssignments = assignments.filter((item) => {
    // Tab filter
    if (activeTab === "PENDING" && item.status !== "PENDING") return false;
    if (activeTab === "SUBMITTED" && item.status !== "SUBMITTED") return false;
    if (activeTab === "GRADED" && item.status !== "GRADED") return false;
    if (activeTab === "OVERDUE" && item.status !== "LATE") return false;

    // Search filter
    if (searchQuery.trim()) {
      const q = searchQuery.toLowerCase();
      const matchTitle = item.title.toLowerCase().includes(q);
      const matchCourse = item.course_code.toLowerCase().includes(q) || item.course_name.toLowerCase().includes(q);
      return matchTitle || matchCourse;
    }
    return true;
  });

  const handleOpenSubmit = (assignment: AssignmentItem) => {
    setSelectedAssignment(assignment);
    setSubmissionContent(assignment.content || "");
    setSubmissionFileUrl(assignment.file_url || "");
    setSubmitSuccess(null);
  };

  const handleSubmitForm = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!selectedAssignment) return;

    try {
      await submitAssignment({
        assignmentId: selectedAssignment.assignment_id,
        payload: {
          content: submissionContent,
          file_url: submissionFileUrl || "https://github.com/apex-student/deliverables/tree/main",
        },
      });
      setSubmitSuccess(`Assignment "${selectedAssignment.title}" submitted successfully!`);
      setTimeout(() => {
        setSelectedAssignment(null);
        setSubmitSuccess(null);
      }, 1500);
    } catch (err: any) {
      console.error("Submission failed:", err);
    }
  };

  const getStatusBadge = (item: AssignmentItem) => {
    switch (item.status) {
      case "GRADED":
        return (
          <Badge className="bg-emerald-500/15 text-emerald-400 border border-emerald-500/30 font-semibold px-2.5 py-0.5">
            <CheckCircle2 className="w-3 h-3 mr-1" /> Graded ({item.marks_obtained} / {item.total_marks})
          </Badge>
        );
      case "SUBMITTED":
        return (
          <Badge className="bg-blue-500/15 text-blue-400 border border-blue-500/30 font-semibold px-2.5 py-0.5">
            <FileCheck className="w-3 h-3 mr-1" /> Submitted
          </Badge>
        );
      case "LATE":
        return (
          <Badge className="bg-rose-500/15 text-rose-400 border border-rose-500/30 font-semibold px-2.5 py-0.5">
            <AlertTriangle className="w-3 h-3 mr-1" /> Overdue
          </Badge>
        );
      default:
        return (
          <Badge className="bg-amber-500/15 text-amber-400 border border-amber-500/30 font-semibold px-2.5 py-0.5">
            <Clock className="w-3 h-3 mr-1" /> Pending
          </Badge>
        );
    }
  };

  const formatDueDate = (dateStr: string) => {
    try {
      const d = new Date(dateStr);
      return d.toLocaleDateString("en-US", {
        month: "short",
        day: "numeric",
        year: "numeric",
        hour: "2-digit",
        minute: "2-digit",
      });
    } catch {
      return dateStr;
    }
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <div className="flex items-center gap-2">
            <h1 className="text-2xl font-bold tracking-tight text-slate-900 dark:text-white">
              Coursework & Assignments
            </h1>
            <Badge variant="outline" className="text-blue-500 border-blue-500/30 bg-blue-500/10">
              STD-07
            </Badge>
          </div>
          <p className="text-xs md:text-sm text-slate-500 dark:text-slate-400 mt-1">
            Track deadlines, submit lab deliverables, and review faculty evaluations
          </p>
        </div>
      </div>

      {/* KPI Metrics */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        <MetricCard
          title="Total Assigned"
          value={totalCount}
          description="Enrolled coursework modules"
          icon={<BookOpen className="h-5 w-5" />}
          spotlightColor="rgba(59, 130, 246, 0.15)"
        />
        <MetricCard
          title="Submitted"
          value={submittedCount}
          description="Deliverables turned in"
          icon={<CheckCircle2 className="h-5 w-5 text-emerald-500" />}
          spotlightColor="rgba(16, 185, 129, 0.15)"
        />
        <MetricCard
          title="Pending Action"
          value={pendingCount}
          description="Awaiting submission"
          icon={<Clock className="h-5 w-5 text-amber-500" />}
          spotlightColor="rgba(245, 158, 11, 0.15)"
        />
        <MetricCard
          title="Evaluated Avg"
          value={`${avgGradedScore}%`}
          description="Average graded score"
          icon={<Award className="h-5 w-5 text-purple-500" />}
          spotlightColor="rgba(168, 85, 247, 0.15)"
        />
      </div>

      {/* Controls: Filter Tabs & Search */}
      <div className="flex flex-col sm:flex-row items-stretch sm:items-center justify-between gap-3 bg-slate-900/60 p-2 rounded-2xl border border-slate-800">
        <div className="flex items-center gap-1 overflow-x-auto pb-1 sm:pb-0">
          {(["ALL", "PENDING", "SUBMITTED", "GRADED", "OVERDUE"] as const).map((tab) => (
            <button
              key={tab}
              onClick={() => setActiveTab(tab)}
              className={`px-3 py-1.5 rounded-xl text-xs font-semibold transition-all cursor-pointer whitespace-nowrap ${
                activeTab === tab
                  ? "bg-blue-600 text-white shadow-md shadow-blue-600/30"
                  : "text-slate-400 hover:text-white hover:bg-slate-800/60"
              }`}
            >
              {tab === "ALL" && `All (${totalCount})`}
              {tab === "PENDING" && `Pending (${pendingCount})`}
              {tab === "SUBMITTED" && `Submitted (${submittedCount - gradedCount})`}
              {tab === "GRADED" && `Graded (${gradedCount})`}
              {tab === "OVERDUE" && `Overdue`}
            </button>
          ))}
        </div>

        <div className="relative sm:w-64">
          <Search className="absolute left-3 top-2.5 h-4 w-4 text-slate-400" />
          <Input
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            placeholder="Search assignments or courses..."
            className="pl-9 h-9 text-xs bg-slate-950/80 border-slate-700/80 rounded-xl text-white placeholder:text-slate-500"
          />
        </div>
      </div>

      {/* Loading Skeleton */}
      {isLoadingAssignments ? (
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          {[1, 2, 3, 4].map((i) => (
            <div
              key={i}
              className="h-44 rounded-2xl bg-slate-900/60 border border-slate-800 animate-pulse p-5"
            />
          ))}
        </div>
      ) : filteredAssignments.length === 0 ? (
        <div className="rounded-2xl border border-slate-800 bg-slate-900/50 p-12 text-center text-slate-400">
          <FileText className="mx-auto h-10 w-10 text-slate-600 mb-3" />
          <h3 className="text-base font-semibold text-white">No assignments found</h3>
          <p className="text-xs text-slate-500 mt-1">
            No coursework records match the selected filter criteria.
          </p>
        </div>
      ) : (
        /* Assignments Grid */
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-4">
          {filteredAssignments.map((item) => (
            <div
              key={item.assignment_id}
              className="group relative flex flex-col justify-between rounded-2xl border border-slate-800 bg-slate-900/80 p-5 hover:border-slate-700 transition-all shadow-lg hover:shadow-indigo-950/20 backdrop-blur-sm"
            >
              <div>
                {/* Course & Status Header */}
                <div className="flex items-start justify-between gap-3 mb-2">
                  <div className="flex items-center gap-2">
                    <span className="px-2.5 py-1 rounded-md text-[11px] font-bold bg-blue-500/10 text-blue-400 border border-blue-500/20">
                      {item.course_code}
                    </span>
                    <span className="text-xs text-slate-400 truncate max-w-[200px]">
                      {item.course_name}
                    </span>
                  </div>
                  {getStatusBadge(item)}
                </div>

                {/* Title & Description */}
                <h3 className="text-base font-bold text-white group-hover:text-blue-300 transition-colors mt-2">
                  {item.title}
                </h3>
                {item.description && (
                  <p className="text-xs text-slate-400 mt-1.5 line-clamp-2 leading-relaxed">
                    {item.description}
                  </p>
                )}

                {/* Feedback / Evaluation Callout if Graded */}
                {item.feedback && (
                  <div className="mt-3 p-3 rounded-xl bg-purple-950/30 border border-purple-800/30 text-xs text-purple-200">
                    <span className="font-semibold text-purple-300">Instructor Evaluation: </span>
                    {item.feedback}
                  </div>
                )}
              </div>

              {/* Bottom Meta & Action Button */}
              <div className="mt-5 pt-3 border-t border-slate-800/80 flex items-center justify-between text-xs text-slate-400">
                <div className="flex items-center gap-3">
                  <div className="flex items-center gap-1.5 text-slate-400">
                    <Calendar className="h-3.5 w-3.5 text-slate-500" />
                    <span>Due: {formatDueDate(item.due_date)}</span>
                  </div>
                  <span className="text-slate-600">•</span>
                  <span className="font-semibold text-slate-300">
                    {item.total_marks} Marks
                  </span>
                </div>

                <Button
                  size="sm"
                  onClick={() => handleOpenSubmit(item)}
                  className={`text-xs h-8 rounded-lg cursor-pointer transition-all ${
                    item.status === "GRADED"
                      ? "bg-slate-800 hover:bg-slate-700 text-slate-200"
                      : item.status === "SUBMITTED"
                      ? "bg-blue-600/30 hover:bg-blue-600/50 text-blue-300 border border-blue-500/30"
                      : "bg-blue-600 hover:bg-blue-500 text-white shadow-sm"
                  }`}
                >
                  {item.status === "GRADED"
                    ? "View Submission"
                    : item.status === "SUBMITTED"
                    ? "Resubmit Work"
                    : "Submit Work →"}
                </Button>
              </div>
            </div>
          ))}
        </div>
      )}

      {/* Submission Modal Dialog */}
      {selectedAssignment && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/70 backdrop-blur-xs">
          <div className="w-full max-w-lg rounded-3xl border border-slate-700/80 bg-slate-900 p-6 md:p-7 shadow-2xl shadow-indigo-950/80 text-white space-y-5 animate-in fade-in zoom-in-95">
            <div className="flex items-start justify-between">
              <div>
                <span className="text-[11px] font-bold text-blue-400 uppercase tracking-wider">
                  {selectedAssignment.course_code} • Deliverable Submission
                </span>
                <h3 className="text-lg font-bold text-white mt-0.5">
                  {selectedAssignment.title}
                </h3>
              </div>
              <button
                onClick={() => setSelectedAssignment(null)}
                className="p-1 rounded-lg text-slate-400 hover:text-white hover:bg-slate-800 transition-colors cursor-pointer"
              >
                <X className="h-5 w-5" />
              </button>
            </div>

            {submitSuccess && (
              <div className="p-3 rounded-xl bg-emerald-500/20 border border-emerald-500/40 text-emerald-300 text-xs flex items-center gap-2">
                <CheckCircle2 className="h-4 w-4 shrink-0" />
                <span>{submitSuccess}</span>
              </div>
            )}

            <form onSubmit={handleSubmitForm} className="space-y-4">
              <div className="space-y-1.5">
                <label className="text-xs font-semibold text-slate-300">
                  Submission Notes / Code Summary
                </label>
                <textarea
                  rows={4}
                  required
                  value={submissionContent}
                  onChange={(e) => setSubmissionContent(e.target.value)}
                  placeholder="Provide an overview of your implementation, architecture decisions, or test results..."
                  className="w-full rounded-xl border border-slate-700 bg-slate-950 p-3 text-xs text-slate-100 placeholder:text-slate-600 focus:outline-none focus:ring-2 focus:ring-blue-500"
                />
              </div>

              <div className="space-y-1.5">
                <label className="text-xs font-semibold text-slate-300">
                  Repository URL / Deliverable File Link
                </label>
                <Input
                  value={submissionFileUrl}
                  onChange={(e) => setSubmissionFileUrl(e.target.value)}
                  placeholder="https://github.com/apex-student/project-deliverable"
                  className="h-10 rounded-xl border-slate-700 bg-slate-950 text-xs text-slate-100 placeholder:text-slate-600"
                />
                <span className="text-[10px] text-slate-500">
                  Attach your GitHub repository link, cloud drive link, or PDF artifact.
                </span>
              </div>

              <div className="flex items-center justify-end gap-2 pt-3 border-t border-slate-800">
                <Button
                  type="button"
                  variant="ghost"
                  onClick={() => setSelectedAssignment(null)}
                  className="text-xs text-slate-400 hover:text-white"
                >
                  Cancel
                </Button>
                <Button
                  type="submit"
                  disabled={isSubmittingAssignment || !submissionContent.trim()}
                  className="text-xs bg-blue-600 hover:bg-blue-500 text-white font-semibold rounded-xl px-5 h-10 shadow-md shadow-blue-600/30 cursor-pointer"
                >
                  {isSubmittingAssignment ? (
                    <span className="flex items-center gap-2">
                      <span className="h-3 w-3 animate-spin rounded-full border-2 border-white border-t-transparent" />
                      Submitting...
                    </span>
                  ) : (
                    "Confirm & Submit"
                  )}
                </Button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
}
