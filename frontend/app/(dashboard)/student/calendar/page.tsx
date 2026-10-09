"use client";

import React from "react";
import { useStudent } from "@/hooks/useStudent";
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { CalendarDays, Bell } from "lucide-react";
import { formatDateTime } from "@/lib/utils";
import { NoticeCard } from "@/components/shared/NoticeCard";

export default function StudentCalendarPage() {
  const { calendar, announcements } = useStudent();

  const getTypeBadge = (eventType: string) => {
    switch (eventType) {
      case "EXAM":
        return <Badge variant="destructive">EXAMINATION</Badge>;
      case "HOLIDAY":
        return <Badge variant="success">CAMPUS RECESS</Badge>;
      default:
        return <Badge variant="default">CAMPUS EVENT</Badge>;
    }
  };

  return (
    <div className="space-y-6">
      <div>
        <h2 className="text-2xl font-bold tracking-tight text-slate-900">
          Academic Calendar & Campus Advisories
        </h2>
        <p className="text-xs sm:text-sm text-slate-500 mt-1">
          Requirements STD-05 & STD-06: Official examination milestones and student announcements.
        </p>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Calendar Events */}
        <div className="lg:col-span-2 space-y-4">
          <h3 className="text-sm font-semibold uppercase tracking-wider text-slate-500">
            Upcoming Institutional Schedule
          </h3>
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
            {calendar.map((evt) => (
              <Card key={evt.event_id} className="hover:border-blue-300 transition-colors">
                <CardHeader className="pb-3">
                  <div className="flex items-start justify-between gap-2">
                    <CardTitle className="text-sm font-bold">
                      {evt.event_title}
                    </CardTitle>
                    {getTypeBadge(evt.event_type)}
                  </div>
                </CardHeader>
                <CardContent className="space-y-3">
                  <p className="text-xs text-slate-600 leading-relaxed">
                    {evt.description}
                  </p>
                  <div className="flex items-center gap-2 pt-2 border-t border-slate-100 text-xs font-semibold text-blue-700">
                    <CalendarDays className="h-4 w-4" />
                    <span>
                      {formatDateTime(evt.start_date)}
                      {evt.end_date !== evt.start_date && ` – ${formatDateTime(evt.end_date)}`}
                    </span>
                  </div>
                </CardContent>
              </Card>
            ))}
          </div>
        </div>

        {/* Announcements Feed */}
        <div className="space-y-4">
          <h3 className="text-sm font-semibold uppercase tracking-wider text-slate-500">
            Student Advisories Feed
          </h3>
          <div className="space-y-3">
            {announcements.map((item) => (
              <NoticeCard
                key={item.announcement_id}
                title={item.title}
                content={item.content}
                targetRole={item.target_role}
                createdAt={item.created_at}
              />
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}
