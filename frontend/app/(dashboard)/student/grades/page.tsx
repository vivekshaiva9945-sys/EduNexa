"use client";

import React from "react";
import { useStudent } from "@/hooks/useStudent";
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { Award, CheckCircle2, TrendingUp } from "lucide-react";

export default function StudentGradesPage() {
  const { grades, progressReport } = useStudent();

  return (
    <div className="space-y-6">
      <div>
        <h2 className="text-2xl font-bold tracking-tight text-slate-900">
          Academic Grades & Progress Report
        </h2>
        <p className="text-xs sm:text-sm text-slate-500 mt-1">
          Requirement STD-03: Continuous assessment marks, semester GPA, and evaluation transcripts.
        </p>
      </div>

      {/* GPA Banner */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        <Card className="bg-gradient-to-br from-blue-900 to-indigo-950 text-white">
          <CardContent className="p-5 space-y-1">
            <span className="text-xs text-blue-300 uppercase tracking-wider font-semibold">
              Current Semester GPA
            </span>
            <div className="flex items-baseline gap-2">
              <span className="text-3xl font-black">
                {progressReport.gpa || 3.88}
              </span>
              <span className="text-xs text-blue-200">/ 4.00</span>
            </div>
            <p className="text-[11px] text-blue-300">
              Grade Status: &apos;{progressReport.letter_grade || "A"}&apos; (Distinction)
            </p>
          </CardContent>
        </Card>

        <Card>
          <CardContent className="p-5 space-y-1">
            <span className="text-xs text-slate-500 uppercase tracking-wider font-semibold">
              Credits Completed
            </span>
            <div className="flex items-baseline gap-2">
              <span className="text-3xl font-black text-slate-900">
                {progressReport.credits_earned || 22}
              </span>
              <span className="text-xs text-slate-500">
                / {progressReport.total_credits || 24} Credits
              </span>
            </div>
            <p className="text-[11px] text-emerald-600 font-medium">
              100% Core Requirements Fulfilled
            </p>
          </CardContent>
        </Card>

        <Card>
          <CardContent className="p-5 space-y-1">
            <span className="text-xs text-slate-500 uppercase tracking-wider font-semibold">
              Academic Standing
            </span>
            <div className="flex items-baseline gap-2">
              <span className="text-3xl font-black text-slate-900">Top 5%</span>
            </div>
            <p className="text-[11px] text-slate-500">
              Rank #3 in Computer Science Cohort
            </p>
          </CardContent>
        </Card>
      </div>

      {/* Itemized Grade Book Table */}
      <Card>
        <CardHeader className="pb-3">
          <CardTitle>Assessment Score Ledger</CardTitle>
          <p className="text-xs text-slate-500">
            Official continuous assessment marks submitted by course instructors
          </p>
        </CardHeader>
        <CardContent>
          <div className="overflow-x-auto rounded-lg border border-slate-100">
            <Table>
              <TableHeader className="bg-slate-50/70">
                <TableRow>
                  <TableHead>Course</TableHead>
                  <TableHead>Assessment Title</TableHead>
                  <TableHead>Score</TableHead>
                  <TableHead>Percentage</TableHead>
                  <TableHead>Grade</TableHead>
                  <TableHead>Instructor Remarks</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {grades.map((item) => (
                  <TableRow key={item.grade_id}>
                    <TableCell>
                      <span className="font-mono text-xs font-bold text-blue-700 block">
                        {item.course_code}
                      </span>
                      <span className="text-xs text-slate-600">
                        {item.course_name}
                      </span>
                    </TableCell>
                    <TableCell className="font-semibold text-xs text-slate-900">
                      {item.assessment_name}
                    </TableCell>
                    <TableCell className="font-bold text-xs text-slate-800">
                      {item.score} / {item.max_score}
                    </TableCell>
                    <TableCell>
                      <span className="text-xs font-bold text-emerald-600">
                        {item.percentage}%
                      </span>
                    </TableCell>
                    <TableCell>
                      <Badge variant="default" className="text-xs">
                        {item.grade}
                      </Badge>
                    </TableCell>
                    <TableCell className="text-xs text-slate-600 italic">
                      &quot;{item.faculty_remarks}&quot;
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
