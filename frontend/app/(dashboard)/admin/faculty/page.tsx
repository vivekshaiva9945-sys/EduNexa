"use client";

import React, { useState } from "react";
import { useAdmin } from "@/hooks/useAdmin";
import { SpotlightCard } from "@/components/animations/SpotlightCard";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import {
  Sheet,
  SheetHeader,
  SheetTitle,
  SheetDescription,
} from "@/components/ui/sheet";
import { Users, BookOpen, Clock, Activity, CalendarCheck } from "lucide-react";

export default function AdminFacultyPage() {
  const { facultyActivity } = useAdmin();
  const [selectedFaculty, setSelectedFaculty] = useState<any | null>(null);

  return (
    <div className="space-y-6">
      <div>
        <h2 className="text-2xl font-bold tracking-tight text-slate-900">
          Faculty Productivity & Academic Activity
        </h2>
        <p className="text-xs sm:text-sm text-slate-500 mt-1">
          Requirement ADM-03: View faculty attendance logging records and academic workload metrics.
        </p>
      </div>

      {/* Faculty Cards Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
        {facultyActivity.map((fac) => (
          <SpotlightCard key={fac.faculty_id} className="p-5 flex flex-col justify-between">
            <div className="space-y-3">
              <div className="flex items-start justify-between">
                <div>
                  <h3 className="font-bold text-base text-slate-900">
                    {fac.name}
                  </h3>
                  <p className="text-xs text-blue-600 font-medium">
                    {fac.designation}
                  </p>
                  <p className="text-xs text-slate-500">
                    Dept of {fac.department}
                  </p>
                </div>
                <div className="h-9 w-9 rounded-full bg-blue-100 flex items-center justify-center text-blue-700 font-bold text-xs">
                  {fac.name[0]}
                </div>
              </div>

              <div className="grid grid-cols-2 gap-2 pt-2 border-t border-slate-100">
                <div className="bg-slate-50 p-2.5 rounded-lg">
                  <div className="flex items-center gap-1.5 text-xs text-slate-500">
                    <BookOpen className="h-3.5 w-3.5 text-blue-500" />
                    <span>Courses</span>
                  </div>
                  <span className="text-base font-bold text-slate-800 mt-1 block">
                    {fac.courses_count}
                  </span>
                </div>
                <div className="bg-slate-50 p-2.5 rounded-lg">
                  <div className="flex items-center gap-1.5 text-xs text-slate-500">
                    <CalendarCheck className="h-3.5 w-3.5 text-emerald-500" />
                    <span>Sessions</span>
                  </div>
                  <span className="text-base font-bold text-slate-800 mt-1 block">
                    {fac.sessions_conducted}
                  </span>
                </div>
              </div>

              <div className="flex items-center justify-between text-xs text-slate-500 pt-1">
                <span>Materials Shared:</span>
                <span className="font-semibold text-slate-700">
                  {fac.materials_uploaded} files
                </span>
              </div>
            </div>

            <Button
              variant="outline"
              size="sm"
              className="w-full mt-4 text-xs"
              onClick={() => setSelectedFaculty(fac)}
            >
              <Activity className="mr-1.5 h-3.5 w-3.5 text-blue-600" /> View Session History
            </Button>
          </SpotlightCard>
        ))}
      </div>

      {/* Slide-Over Drawer for Attendance Logs */}
      <Sheet open={!!selectedFaculty} onOpenChange={() => setSelectedFaculty(null)}>
        {selectedFaculty && (
          <div className="space-y-6">
            <SheetHeader>
              <SheetTitle>{selectedFaculty.name}</SheetTitle>
              <SheetDescription>
                Chronological Lecture & Attendance Submission History
              </SheetDescription>
            </SheetHeader>

            <div className="space-y-4">
              <div className="rounded-lg bg-blue-50 p-3 text-xs text-blue-800">
                <p className="font-semibold">{selectedFaculty.department} Department</p>
                <p className="mt-0.5">{selectedFaculty.sessions_conducted} Total Teaching Sessions Conducted</p>
              </div>

              <div className="space-y-3">
                <h4 className="text-xs font-semibold uppercase tracking-wider text-slate-500">
                  Recent Lecture Logs:
                </h4>
                {[
                  { date: "Oct 9, 2026", course: "APEX-CS101", room: "Hall 301", present: 39, total: 42, time: "09:05 AM" },
                  { date: "Oct 8, 2026", course: "APEX-CS102", room: "Lab Complex 2", present: 35, total: 38, time: "11:10 AM" },
                  { date: "Oct 7, 2026", course: "APEX-CS101", room: "Hall 301", present: 40, total: 42, time: "09:02 AM" },
                  { date: "Oct 6, 2026", course: "APEX-CS101", room: "Hall 301", present: 38, total: 42, time: "09:00 AM" },
                ].map((log, i) => (
                  <div
                    key={i}
                    className="p-3 rounded-lg border border-slate-100 bg-white space-y-1 shadow-xs"
                  >
                    <div className="flex items-center justify-between text-xs font-semibold text-slate-800">
                      <span>{log.course} ({log.room})</span>
                      <Badge variant="success" className="text-[10px]">
                        {log.present}/{log.total} Present
                      </Badge>
                    </div>
                    <div className="flex items-center justify-between text-[11px] text-slate-400">
                      <span>{log.date}</span>
                      <span>Marked at {log.time}</span>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          </div>
        )}
      </Sheet>
    </div>
  );
}
