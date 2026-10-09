"use client";

import React from "react";
import { useAdmin } from "@/hooks/useAdmin";
import { MetricCard } from "@/components/shared/MetricCard";
import { NoticeCard } from "@/components/shared/NoticeCard";
import { DecryptedText } from "@/components/animations/DecryptedText";
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card";
import { Users, GraduationCap, CheckCircle2, Bell, ArrowRight } from "lucide-react";
import Link from "next/link";
import { Button } from "@/components/ui/button";

export default function AdminDashboardPage() {
  const { attendanceSummary, announcements } = useAdmin();

  const avgAttendance = attendanceSummary.length
    ? (
        attendanceSummary.reduce((acc, curr) => acc + curr.present_percentage, 0) /
        attendanceSummary.length
      ).toFixed(1)
    : "84.8";

  return (
    <div className="space-y-6">
      {/* Welcome Banner */}
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 rounded-2xl bg-gradient-to-r from-slate-900 via-slate-800 to-blue-950 p-6 text-white shadow-sm border border-slate-800">
        <div className="space-y-1">
          <h2 className="text-xl sm:text-2xl font-bold tracking-tight">
            <DecryptedText text="Welcome back, Administrator" speed={30} />
          </h2>
          <p className="text-xs sm:text-sm text-slate-300">
            Academic Session 2024–2025 • College-Wide Operational Overview
          </p>
        </div>
        <div className="flex items-center gap-2">
          <Link href="/admin/announcements">
            <Button size="sm" className="bg-blue-600 hover:bg-blue-700 text-white text-xs">
              <Bell className="mr-1.5 h-3.5 w-3.5" /> Broadcast Notice
            </Button>
          </Link>
        </div>
      </div>

      {/* KPI Cards Grid */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        <MetricCard
          title="Total Enrolled Students"
          value="1,248"
          trend={{ value: "+4.2% YoY", isPositive: true }}
          icon={<GraduationCap className="h-5 w-5" />}
          description="Across 6 Academic Departments"
        />
        <MetricCard
          title="Active Faculty Members"
          value="84"
          trend={{ value: "100% Active", isPositive: true }}
          icon={<Users className="h-5 w-5" />}
          description="Professors & Teaching Fellows"
        />
        <MetricCard
          title="College Attendance Rate"
          value={`${avgAttendance}%`}
          trend={{ value: "+1.8% vs last week", isPositive: true }}
          icon={<CheckCircle2 className="h-5 w-5" />}
          description="Institutional minimum: 75.0%"
        />
        <MetricCard
          title="Published Notices"
          value={announcements.length || "3"}
          trend={{ value: "Active", isNeutral: true }}
          icon={<Bell className="h-5 w-5" />}
          description="Current Global & Scoped Feed"
        />
      </div>

      {/* Content Grid */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Attendance Summary Overview */}
        <div className="lg:col-span-2 space-y-4">
          <Card>
            <CardHeader className="flex flex-row items-center justify-between pb-3">
              <div>
                <CardTitle>Department Attendance Overview</CardTitle>
                <p className="text-xs text-slate-500 mt-0.5">
                  Real-time aggregation from active lecture registers
                </p>
              </div>
              <Link href="/admin/attendance">
                <Button variant="ghost" size="sm" className="text-xs text-blue-600 hover:text-blue-700">
                  Full Analytics <ArrowRight className="ml-1 h-3.5 w-3.5" />
                </Button>
              </Link>
            </CardHeader>
            <CardContent>
              <div className="space-y-3">
                {attendanceSummary.slice(0, 4).map((item) => (
                  <div
                    key={item.course_id}
                    className="flex items-center justify-between p-3 rounded-lg border border-slate-100 bg-slate-50/50 hover:bg-slate-50 transition-colors"
                  >
                    <div>
                      <p className="text-sm font-semibold text-slate-900">
                        {item.course_name}
                      </p>
                      <p className="text-xs text-slate-500">
                        {item.course_code} • {item.department} ({item.total_enrolled} enrolled)
                      </p>
                    </div>
                    <div className="text-right">
                      <span
                        className={`text-sm font-bold ${
                          item.present_percentage >= 75
                            ? "text-emerald-600"
                            : "text-rose-600"
                        }`}
                      >
                        {item.present_percentage}%
                      </span>
                      <p className="text-[10px] text-slate-400">
                        {item.total_sessions} sessions
                      </p>
                    </div>
                  </div>
                ))}
              </div>
            </CardContent>
          </Card>
        </div>

        {/* Notices Feed */}
        <div className="space-y-4">
          <Card>
            <CardHeader className="pb-3">
              <CardTitle>Recent Campus Notices</CardTitle>
              <p className="text-xs text-slate-500 mt-0.5">
                Institutional notice board feed
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
