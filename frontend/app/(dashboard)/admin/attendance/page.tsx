"use client";

import React from "react";
import { useAdmin } from "@/hooks/useAdmin";
import { DataTable, Column } from "@/components/shared/DataTable";
import { Tabs, TabsList, TabsTrigger, TabsContent } from "@/components/ui/tabs";
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import {
  ResponsiveContainer,
  AreaChart,
  Area,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  Legend,
} from "recharts";

export default function AdminAttendancePage() {
  const { attendanceSummary, attendanceTrends } = useAdmin();

  const columns: Column<any>[] = [
    {
      header: "Course Code",
      accessorKey: "course_code",
      cell: (item) => (
        <span className="font-mono font-semibold text-xs text-blue-600">
          {item.course_code}
        </span>
      ),
    },
    {
      header: "Course Name",
      accessorKey: "course_name",
      cell: (item) => (
        <div>
          <span className="font-medium text-slate-900 block">{item.course_name}</span>
          <span className="text-xs text-slate-500">{item.department}</span>
        </div>
      ),
    },
    {
      header: "Enrolled",
      accessorKey: "total_enrolled",
      cell: (item) => (
        <span className="text-xs font-medium text-slate-700">
          {item.total_enrolled} students
        </span>
      ),
    },
    {
      header: "Total Sessions",
      accessorKey: "total_sessions",
      cell: (item) => (
        <span className="text-xs text-slate-600">{item.total_sessions} classes</span>
      ),
    },
    {
      header: "Attendance Rate",
      accessorKey: "present_percentage",
      cell: (item) => (
        <div className="flex items-center gap-2">
          <span
            className={`font-bold text-xs ${
              item.present_percentage >= 75 ? "text-emerald-600" : "text-rose-600"
            }`}
          >
            {item.present_percentage}%
          </span>
          <div className="w-16 h-1.5 bg-slate-100 rounded-full overflow-hidden">
            <div
              className={`h-full ${
                item.present_percentage >= 75 ? "bg-emerald-500" : "bg-rose-500"
              }`}
              style={{ width: `${item.present_percentage}%` }}
            />
          </div>
        </div>
      ),
    },
    {
      header: "Status",
      cell: (item) => (
        <Badge
          variant={item.present_percentage >= 75 ? "success" : "destructive"}
        >
          {item.present_percentage >= 75 ? "HEALTHY" : "CRITICAL SHORTAGE"}
        </Badge>
      ),
    },
  ];

  return (
    <div className="space-y-6">
      <div>
        <h2 className="text-2xl font-bold tracking-tight text-slate-900">
          College-Wide Attendance Analytics
        </h2>
        <p className="text-xs sm:text-sm text-slate-500 mt-1">
          Requirement ADM-01: Aggregated student attendance percentages & cross-department trends.
        </p>
      </div>

      <Tabs defaultValue="summary">
        <TabsList>
          <TabsTrigger value="summary">Summary Table</TabsTrigger>
          <TabsTrigger value="trends">Trend Analytics</TabsTrigger>
        </TabsList>

        <TabsContent value="summary" className="mt-4">
          <DataTable
            data={attendanceSummary}
            columns={columns}
            searchFilterKey="course_name"
            searchPlaceholder="Filter by course name..."
          />
        </TabsContent>

        <TabsContent value="trends" className="mt-4">
          <Card>
            <CardHeader>
              <CardTitle>Daily Attendance Fluctuations by Department</CardTitle>
              <p className="text-xs text-slate-500">
                Weekly attendance compliance curves across engineering streams (%)
              </p>
            </CardHeader>
            <CardContent>
              <div className="h-80 w-full pt-4">
                <ResponsiveContainer width="100%" height="100%">
                  <AreaChart data={attendanceTrends}>
                    <defs>
                      <linearGradient id="colorCs" x1="0" y1="0" x2="0" y2="1">
                        <stop offset="5%" stopColor="#2563EB" stopOpacity={0.8} />
                        <stop offset="95%" stopColor="#2563EB" stopOpacity={0} />
                      </linearGradient>
                      <linearGradient id="colorIt" x1="0" y1="0" x2="0" y2="1">
                        <stop offset="5%" stopColor="#10B981" stopOpacity={0.8} />
                        <stop offset="95%" stopColor="#10B981" stopOpacity={0} />
                      </linearGradient>
                      <linearGradient id="colorEc" x1="0" y1="0" x2="0" y2="1">
                        <stop offset="5%" stopColor="#F59E0B" stopOpacity={0.8} />
                        <stop offset="95%" stopColor="#F59E0B" stopOpacity={0} />
                      </linearGradient>
                    </defs>
                    <CartesianGrid strokeDasharray="3 3" stroke="#e2e8f0" />
                    <XAxis dataKey="day" stroke="#64748b" textAnchor="end" />
                    <YAxis domain={[50, 100]} stroke="#64748b" />
                    <Tooltip />
                    <Legend />
                    <Area
                      type="monotone"
                      dataKey="cs"
                      name="Computer Science"
                      stroke="#2563EB"
                      fillOpacity={1}
                      fill="url(#colorCs)"
                    />
                    <Area
                      type="monotone"
                      dataKey="it"
                      name="Information Tech"
                      stroke="#10B981"
                      fillOpacity={1}
                      fill="url(#colorIt)"
                    />
                    <Area
                      type="monotone"
                      dataKey="ec"
                      name="Electronics & Comm"
                      stroke="#F59E0B"
                      fillOpacity={1}
                      fill="url(#colorEc)"
                    />
                  </AreaChart>
                </ResponsiveContainer>
              </div>
            </CardContent>
          </Card>
        </TabsContent>
      </Tabs>
    </div>
  );
}
