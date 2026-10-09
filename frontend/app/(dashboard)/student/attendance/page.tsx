"use client";

import React, { useState } from "react";
import { useStudent } from "@/hooks/useStudent";
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Progress } from "@/components/ui/progress";
import { ChevronDown, ChevronUp, CheckCircle, XCircle, Clock } from "lucide-react";

export default function StudentAttendancePage() {
  const { attendance } = useStudent();
  const [expandedCourse, setExpandedCourse] = useState<string | null>("crs-cs101");

  const toggleExpand = (courseId: string) => {
    setExpandedCourse((prev) => (prev === courseId ? null : courseId));
  };

  const getStatusIcon = (status: string) => {
    switch (status) {
      case "PRESENT":
        return <CheckCircle className="h-4 w-4 text-emerald-500" />;
      case "ABSENT":
        return <XCircle className="h-4 w-4 text-rose-500" />;
      default:
        return <Clock className="h-4 w-4 text-amber-500" />;
    }
  };

  return (
    <div className="space-y-6">
      <div>
        <h2 className="text-2xl font-bold tracking-tight text-slate-900">
          Personal Attendance Tracker
        </h2>
        <p className="text-xs sm:text-sm text-slate-500 mt-1">
          Requirement STD-01: Track personal attendance logs and subject-wise compliance rates.
        </p>
      </div>

      <div className="space-y-4">
        {attendance.map((sub) => {
          const isExpanded = expandedCourse === sub.course_id;
          const isHealthy = sub.percentage >= 75;

          return (
            <Card key={sub.course_id} className="overflow-hidden">
              <div
                onClick={() => toggleExpand(sub.course_id)}
                className="flex flex-col sm:flex-row sm:items-center justify-between p-5 gap-4 cursor-pointer hover:bg-slate-50/50 transition-colors"
              >
                <div className="space-y-1">
                  <div className="flex items-center gap-2">
                    <span className="font-mono text-xs font-bold text-blue-700">
                      {sub.course_code}
                    </span>
                    <h3 className="text-base font-bold text-slate-900">
                      {sub.course_name}
                    </h3>
                  </div>
                  <p className="text-xs text-slate-500">
                    Faculty: {sub.faculty_name} • {sub.attended} Attended / {sub.conducted} Conducted
                  </p>
                </div>

                <div className="flex items-center gap-4">
                  <div className="text-right">
                    <span
                      className={`text-lg font-extrabold ${
                        isHealthy ? "text-emerald-600" : "text-rose-600"
                      }`}
                    >
                      {sub.percentage}%
                    </span>
                    <Badge
                      variant={isHealthy ? "success" : "destructive"}
                      className="ml-2 text-[10px]"
                    >
                      {isHealthy ? "ON TRACK" : "SHORTAGE"}
                    </Badge>
                  </div>
                  {isExpanded ? (
                    <ChevronUp className="h-5 w-5 text-slate-400" />
                  ) : (
                    <ChevronDown className="h-5 w-5 text-slate-400" />
                  )}
                </div>
              </div>

              {/* Progress Line */}
              <div className="px-5 pb-2">
                <Progress
                  value={sub.percentage}
                  indicatorColor={isHealthy ? "bg-emerald-500" : "bg-rose-500"}
                  className="h-1.5"
                />
              </div>

              {/* Detailed Session Logs (Accordion) */}
              {isExpanded && (
                <div className="border-t border-slate-100 bg-slate-50/50 p-5 space-y-3 animate-in fade-in-50 duration-200">
                  <h4 className="text-xs font-semibold uppercase tracking-wider text-slate-500">
                    Date-By-Date Session History
                  </h4>
                  <div className="divide-y divide-slate-100 rounded-lg border border-slate-200/60 bg-white">
                    {sub.logs.map((log: any, idx: number) => (
                      <div
                        key={idx}
                        className="flex items-center justify-between p-3 text-xs"
                      >
                        <div className="flex items-center gap-3">
                          {getStatusIcon(log.status)}
                          <div>
                            <span className="font-medium text-slate-800">
                              {log.date}
                            </span>
                            {log.remarks && (
                              <p className="text-[11px] text-slate-400">
                                {log.remarks}
                              </p>
                            )}
                          </div>
                        </div>

                        <Badge
                          variant={
                            log.status === "PRESENT"
                              ? "success"
                              : log.status === "ABSENT"
                              ? "destructive"
                              : "warning"
                          }
                          className="text-[10px]"
                        >
                          {log.status}
                        </Badge>
                      </div>
                    ))}
                  </div>
                </div>
              )}
            </Card>
          );
        })}
      </div>
    </div>
  );
}
