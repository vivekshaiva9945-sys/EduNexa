"use client";

import React, { useMemo } from "react";
import { useStudent } from "@/hooks/useStudent";
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Clock, MapPin, User, CalendarDays, BookOpen, Sparkles } from "lucide-react";

export default function StudentTimetablePage() {
  const { timetable } = useStudent();

  const days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
  const currentDayName = useMemo(() => {
    return new Intl.DateTimeFormat("en-US", { weekday: "long" }).format(new Date());
  }, []);

  const totalClasses = timetable.length;
  const uniqueCoursesCount = useMemo(() => {
    return new Set(timetable.map((s) => s.course_code)).size;
  }, [timetable]);

  return (
    <div className="space-y-6">
      {/* Header & Quick Summary */}
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <h2 className="text-2xl font-bold tracking-tight text-slate-900">
            Personal Lecture Timetable
          </h2>
          <p className="text-xs sm:text-sm text-slate-500 mt-1">
            Requirement STD-02: Daily class schedules, lecture halls, and designated instructors.
          </p>
        </div>

        <div className="flex items-center gap-3">
          <div className="flex items-center gap-2 px-3 py-1.5 rounded-lg border border-slate-200 bg-white shadow-xs text-xs text-slate-600 font-medium">
            <CalendarDays className="h-4 w-4 text-blue-600" />
            <span>{totalClasses} Weekly Lectures</span>
          </div>
          <div className="flex items-center gap-2 px-3 py-1.5 rounded-lg border border-slate-200 bg-white shadow-xs text-xs text-slate-600 font-medium">
            <BookOpen className="h-4 w-4 text-emerald-600" />
            <span>{uniqueCoursesCount} Enrolled Subjects</span>
          </div>
        </div>
      </div>

      {/* Grid of Days */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
        {days.map((day) => {
          const isToday = day.toLowerCase() === currentDayName.toLowerCase();
          const slots = timetable
            .filter((s) => s.day?.toLowerCase() === day.toLowerCase())
            .sort((a, b) => a.start_time.localeCompare(b.start_time));

          return (
            <Card
              key={day}
              className={`flex flex-col h-full transition-all duration-200 ${
                isToday
                  ? "border-blue-400/80 shadow-md ring-1 ring-blue-400/40"
                  : "hover:border-slate-300"
              }`}
            >
              <CardHeader
                className={`border-b py-3 px-4 ${
                  isToday
                    ? "bg-blue-50/70 border-blue-200/60"
                    : "bg-slate-50/70 border-slate-100"
                }`}
              >
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-2">
                    <CardTitle className="text-sm font-bold text-slate-800">
                      {day}
                    </CardTitle>
                    {isToday && (
                      <span className="flex items-center gap-1 text-[10px] font-semibold text-blue-700 bg-blue-100/80 px-2 py-0.5 rounded-full">
                        <Sparkles className="h-2.5 w-2.5 text-blue-600" /> Today
                      </span>
                    )}
                  </div>
                  <Badge variant="outline" className="text-[10px] font-medium">
                    {slots.length} {slots.length === 1 ? "Class" : "Classes"}
                  </Badge>
                </div>
              </CardHeader>
              <CardContent className="p-4 flex-1 space-y-3">
                {slots.length > 0 ? (
                  slots.map((slot) => (
                    <div
                      key={slot.id}
                      className="p-3 rounded-lg border border-blue-100 bg-blue-50/30 hover:bg-blue-50/60 transition-colors space-y-2"
                    >
                      <div className="flex items-center justify-between">
                        <span className="font-mono text-xs font-bold text-blue-700">
                          {slot.course_code}
                        </span>
                        <div className="flex items-center gap-1 text-[11px] text-slate-500 font-medium">
                          <Clock className="h-3 w-3 text-slate-400" />
                          <span>
                            {slot.start_time} – {slot.end_time}
                          </span>
                        </div>
                      </div>

                      <h4 className="text-xs font-bold text-slate-900 leading-snug">
                        {slot.course_name}
                      </h4>

                      <div className="flex items-center justify-between text-[11px] text-slate-500 pt-1.5 border-t border-blue-100/60">
                        <span className="flex items-center gap-1 font-medium">
                          <MapPin className="h-3 w-3 text-slate-400" />
                          {slot.room_number}
                        </span>
                        <span className="flex items-center gap-1 font-semibold text-slate-600">
                          <User className="h-3 w-3 text-slate-400" />
                          {slot.faculty_name || "Faculty Instructor"}
                        </span>
                      </div>
                    </div>
                  ))
                ) : (
                  <div className="flex h-24 items-center justify-center text-xs text-slate-400">
                    No scheduled lectures
                  </div>
                )}
              </CardContent>
            </Card>
          );
        })}
      </div>
    </div>
  );
}
