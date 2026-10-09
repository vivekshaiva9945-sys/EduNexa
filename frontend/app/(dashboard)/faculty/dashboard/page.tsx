"use client";

import React from "react";
import { useFaculty } from "@/hooks/useFaculty";
import { MetricCard } from "@/components/shared/MetricCard";
import { NoticeCard } from "@/components/shared/NoticeCard";
import { DecryptedText } from "@/components/animations/DecryptedText";
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import Link from "next/link";
import {
  BookOpen,
  CalendarCheck,
  ClipboardCheck,
  Clock,
  ArrowRight,
  MapPin,
} from "lucide-react";

export default function FacultyDashboardPage() {
  const { courses, timetable, announcements } = useFaculty();

  const todayClasses = timetable.filter(
    (slot) => slot.day === "Monday" || slot.day === "Tuesday"
  );

  return (
    <div className="space-y-6">
      {/* Welcome Banner */}
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 rounded-2xl bg-gradient-to-r from-slate-900 via-purple-950 to-slate-900 p-6 text-white shadow-sm border border-slate-800">
        <div className="space-y-1">
          <h2 className="text-xl sm:text-2xl font-bold tracking-tight">
            <DecryptedText text="Good morning, Dr. Rajesh Nambiar" speed={30} />
          </h2>
          <p className="text-xs sm:text-sm text-slate-300">
            Professor • Department of Computer Science • Apex Institute
          </p>
        </div>
        <Link href="/faculty/attendance">
          <Button size="sm" className="bg-blue-600 hover:bg-blue-700 text-white text-xs">
            <ClipboardCheck className="mr-1.5 h-3.5 w-3.5" /> Fast Register
          </Button>
        </Link>
      </div>

      {/* Metric Cards */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        <MetricCard
          title="Assigned Courses"
          value={courses.length || "2"}
          trend={{ value: "Active", isNeutral: true }}
          icon={<BookOpen className="h-5 w-5" />}
          description="Sem 3 CS Curriculum"
        />
        <MetricCard
          title="Weekly Lectures"
          value={timetable.length || "6"}
          trend={{ value: "Scheduled", isNeutral: true }}
          icon={<Clock className="h-5 w-5" />}
          description="Mon through Fri"
        />
        <MetricCard
          title="Total Students"
          value="80"
          trend={{ value: "Enrolled", isNeutral: true }}
          icon={<CalendarCheck className="h-5 w-5" />}
          description="Across 2 Course Sections"
        />
        <MetricCard
          title="Avg Class Attendance"
          value="86.4%"
          trend={{ value: "+2.1%", isPositive: true }}
          icon={<ClipboardCheck className="h-5 w-5" />}
          description="Past 30 days"
        />
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Today's Teaching Schedule */}
        <div className="lg:col-span-2 space-y-4">
          <Card>
            <CardHeader className="flex flex-row items-center justify-between pb-3">
              <div>
                <CardTitle>Today&apos;s Lecture Schedule</CardTitle>
                <p className="text-xs text-slate-500 mt-0.5">
                  Upcoming slots and attendance tracking shortcuts
                </p>
              </div>
              <Link href="/faculty/timetable">
                <Button variant="ghost" size="sm" className="text-xs text-blue-600 hover:text-blue-700">
                  Full Grid <ArrowRight className="ml-1 h-3.5 w-3.5" />
                </Button>
              </Link>
            </CardHeader>
            <CardContent>
              <div className="space-y-3">
                {todayClasses.map((item) => (
                  <div
                    key={item.id}
                    className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 p-4 rounded-xl border border-slate-100 bg-white hover:border-blue-200 transition-colors shadow-xs"
                  >
                    <div className="flex items-start gap-3">
                      <div className="flex h-10 w-10 shrink-0 items-center justify-center rounded-lg bg-blue-50 text-blue-700 font-bold text-xs">
                        {item.start_time}
                      </div>
                      <div>
                        <div className="flex items-center gap-2">
                          <h4 className="text-sm font-bold text-slate-900">
                            {item.course_name}
                          </h4>
                          <Badge variant="outline" className="text-[10px]">
                            {item.section}
                          </Badge>
                        </div>
                        <div className="flex items-center gap-3 text-xs text-slate-500 mt-1">
                          <span className="flex items-center gap-1 font-mono text-blue-600">
                            {item.course_code}
                          </span>
                          <span className="flex items-center gap-1">
                            <MapPin className="h-3 w-3 text-slate-400" />
                            {item.room_number}
                          </span>
                        </div>
                      </div>
                    </div>

                    <Link href={`/faculty/attendance?course=${item.course_code}`}>
                      <Button size="sm" className="bg-emerald-600 hover:bg-emerald-700 text-white text-xs whitespace-nowrap">
                        <ClipboardCheck className="mr-1 h-3.5 w-3.5" /> Mark Attendance
                      </Button>
                    </Link>
                  </div>
                ))}
              </div>
            </CardContent>
          </Card>
        </div>

        {/* Notices */}
        <div className="space-y-4">
          <Card>
            <CardHeader className="pb-3">
              <CardTitle>Institutional Announcements</CardTitle>
              <p className="text-xs text-slate-500 mt-0.5">
                Dean of Academics & Admin Updates
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
