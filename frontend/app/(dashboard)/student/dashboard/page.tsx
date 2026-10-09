"use client";

import React from "react";
import { useStudent } from "@/hooks/useStudent";
import { MetricCard } from "@/components/shared/MetricCard";
import { NoticeCard } from "@/components/shared/NoticeCard";
import { DecryptedText } from "@/components/animations/DecryptedText";
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Progress } from "@/components/ui/progress";
import Link from "next/link";
import {
  GraduationCap,
  ClipboardCheck,
  Clock,
  BookOpen,
  ArrowRight,
  AlertTriangle,
  CheckCircle2,
  Calendar,
} from "lucide-react";

export default function StudentDashboardPage() {
  const { attendance, timetable, announcements, progressReport } = useStudent();

  const totalConducted = attendance.reduce((acc, c) => acc + c.conducted, 0);
  const totalAttended = attendance.reduce((acc, c) => acc + c.attended, 0);
  const overallPercentage = totalConducted
    ? ((totalAttended / totalConducted) * 100).toFixed(1)
    : "88.4";

  const nextClass = timetable[0];

  return (
    <div className="space-y-6">
      {/* Welcome Banner */}
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 rounded-2xl bg-gradient-to-r from-slate-900 via-blue-950 to-slate-900 p-6 text-white shadow-sm border border-slate-800">
        <div className="space-y-1">
          <h2 className="text-xl sm:text-2xl font-bold tracking-tight">
            <DecryptedText text="Welcome back, Aarav Sharma" speed={30} />
          </h2>
          <p className="text-xs sm:text-sm text-slate-300">
            Roll Number: APEX-2024-101 • Semester 3 • Computer Science & Eng.
          </p>
        </div>
        <Link href="/student/attendance">
          <Button size="sm" className="bg-blue-600 hover:bg-blue-700 text-white text-xs">
            <ClipboardCheck className="mr-1.5 h-3.5 w-3.5" /> Check Records
          </Button>
        </Link>
      </div>

      {/* KPI Cards Grid */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        {/* Attendance Gauge Card */}
        <MetricCard
          title="Overall Attendance"
          value={`${overallPercentage}%`}
          trend={{
            value: Number(overallPercentage) >= 75 ? "Safe (>75%)" : "Shortage Warning",
            isPositive: Number(overallPercentage) >= 75,
          }}
          icon={<ClipboardCheck className="h-5 w-5" />}
          description={`${totalAttended} of ${totalConducted} Lectures Attended`}
        />

        {/* GPA Display Card */}
        <MetricCard
          title="Cumulative GPA"
          value={progressReport.gpa ? `${progressReport.gpa} / 4.0` : "3.88 / 4.0"}
          trend={{ value: "Rank #3", isPositive: true }}
          icon={<GraduationCap className="h-5 w-5" />}
          description={`Grade '${progressReport.letter_grade || "A"}' (${progressReport.credits_earned || 22} Credits Earned)`}
        />

        {/* Next Lecture Card */}
        <MetricCard
          title="Next Lecture"
          value={nextClass ? nextClass.start_time : "09:00 AM"}
          trend={{ value: "Upcoming", isNeutral: true }}
          icon={<Clock className="h-5 w-5" />}
          description={nextClass ? `${nextClass.course_name} (${nextClass.room_number})` : "Lecture Hall 301"}
        />

        {/* Enrolled Courses */}
        <MetricCard
          title="Enrolled Courses"
          value={attendance.length || "4"}
          trend={{ value: "16 Credits", isNeutral: true }}
          icon={<BookOpen className="h-5 w-5" />}
          description="Fall Semester 2024"
        />
      </div>

      {/* Attendance & Subject Breakdown */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <div className="lg:col-span-2 space-y-4">
          <Card>
            <CardHeader className="flex flex-row items-center justify-between pb-3">
              <div>
                <CardTitle>Subject Attendance Health</CardTitle>
                <p className="text-xs text-slate-500 mt-0.5">
                  Track course attendance against institutional 75% requirement
                </p>
              </div>
              <Link href="/student/attendance">
                <Button variant="ghost" size="sm" className="text-xs text-blue-600 hover:text-blue-700">
                  Full Breakdown <ArrowRight className="ml-1 h-3.5 w-3.5" />
                </Button>
              </Link>
            </CardHeader>
            <CardContent className="space-y-4">
              {attendance.map((sub) => {
                const isShortage = sub.percentage < 75;
                return (
                  <div
                    key={sub.course_id}
                    className="p-3.5 rounded-xl border border-slate-100 bg-white hover:border-blue-200 transition-colors space-y-2 shadow-xs"
                  >
                    <div className="flex items-center justify-between">
                      <div>
                        <div className="flex items-center gap-2">
                          <span className="font-mono text-xs font-bold text-blue-700">
                            {sub.course_code}
                          </span>
                          <span className="text-xs font-semibold text-slate-800">
                            {sub.course_name}
                          </span>
                        </div>
                        <p className="text-[11px] text-slate-400 mt-0.5">
                          Taught by {sub.faculty_name}
                        </p>
                      </div>
                      <div className="text-right">
                        <span
                          className={`text-sm font-extrabold ${
                            isShortage ? "text-rose-600" : "text-emerald-600"
                          }`}
                        >
                          {sub.percentage}%
                        </span>
                        <p className="text-[10px] text-slate-400">
                          {sub.attended}/{sub.conducted} classes
                        </p>
                      </div>
                    </div>

                    <Progress
                      value={sub.percentage}
                      indicatorColor={isShortage ? "bg-rose-500" : "bg-emerald-500"}
                      className="h-2"
                    />

                    {isShortage && (
                      <div className="flex items-center gap-1.5 text-[11px] text-rose-600 font-medium pt-1">
                        <AlertTriangle className="h-3 w-3" />
                        <span>Shortage Alert: Must attend next 3 lectures to meet 75% criteria</span>
                      </div>
                    )}
                  </div>
                );
              })}
            </CardContent>
          </Card>
        </div>

        {/* Notices */}
        <div className="space-y-4">
          <Card>
            <CardHeader className="pb-3">
              <CardTitle>Campus Notice Board</CardTitle>
              <p className="text-xs text-slate-500 mt-0.5">
                Announcements from faculty & administration
              </p>
            </CardHeader>
            <CardContent className="space-y-3">
              {announcements.slice(0, 3).map((item) => (
                <NoticeCard
                  key={item.announcement_id}
                  title={item.title}
                  content={item.content}
                  targetRole={item.target_role}
                  createdAt={item.created_at}
                />
              ))}
            </CardContent>
          </Card>
        </div>
      </div>
    </div>
  );
}
