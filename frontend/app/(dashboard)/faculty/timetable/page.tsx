"use client";

import React from "react";
import { useFaculty } from "@/hooks/useFaculty";
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Clock, MapPin, Users } from "lucide-react";

export default function FacultyTimetablePage() {
  const { timetable } = useFaculty();

  const days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];

  return (
    <div className="space-y-6">
      <div>
        <h2 className="text-2xl font-bold tracking-tight text-slate-900">
          Faculty Teaching Timetable
        </h2>
        <p className="text-xs sm:text-sm text-slate-500 mt-1">
          Requirement FAC-02: Access personal weekly teaching schedule and lecture slots.
        </p>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
        {days.map((day) => {
          const slots = timetable.filter((s) => s.day === day);

          return (
            <Card key={day} className="flex flex-col h-full">
              <CardHeader className="bg-slate-50/70 border-b border-slate-100 py-3 px-4">
                <div className="flex items-center justify-between">
                  <CardTitle className="text-sm font-bold text-slate-800">
                    {day}
                  </CardTitle>
                  <Badge variant="outline" className="text-[10px]">
                    {slots.length} {slots.length === 1 ? "Class" : "Classes"}
                  </Badge>
                </div>
              </CardHeader>
              <CardContent className="p-4 flex-1 space-y-3">
                {slots.length > 0 ? (
                  slots.map((slot) => (
                    <div
                      key={slot.id}
                      className="p-3 rounded-lg border border-blue-100 bg-blue-50/40 hover:bg-blue-50/70 transition-colors space-y-2"
                    >
                      <div className="flex items-center justify-between">
                        <span className="font-mono text-xs font-bold text-blue-700">
                          {slot.course_code}
                        </span>
                        <div className="flex items-center gap-1 text-[11px] text-slate-500">
                          <Clock className="h-3 w-3 text-slate-400" />
                          <span>
                            {slot.start_time} – {slot.end_time}
                          </span>
                        </div>
                      </div>

                      <h4 className="text-xs font-semibold text-slate-900">
                        {slot.course_name}
                      </h4>

                      <div className="flex items-center justify-between text-[11px] text-slate-500 pt-1 border-t border-blue-100/60">
                        <span className="flex items-center gap-1">
                          <MapPin className="h-3 w-3 text-slate-400" />
                          {slot.room_number}
                        </span>
                        <Badge variant="secondary" className="text-[9px]">
                          {slot.section}
                        </Badge>
                      </div>
                    </div>
                  ))
                ) : (
                  <div className="flex h-28 items-center justify-center text-xs text-slate-400">
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
