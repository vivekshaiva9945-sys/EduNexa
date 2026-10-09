"use client";

import React, { useState, useEffect } from "react";
import { useFaculty } from "@/hooks/useFaculty";
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { CheckCircle2, Award, Check } from "lucide-react";

export default function FacultyGradesPage() {
  const { courses, getCourseStudents, submitGrades, isSubmittingGrades } =
    useFaculty();

  const [selectedCourse, setSelectedCourse] = useState("crs-cs101");
  const [assessmentName, setAssessmentName] = useState("Midterm Examination 2024");
  const [maxScore, setMaxScore] = useState(100);
  const [students, setStudents] = useState<any[]>([]);
  const [scores, setScores] = useState<Record<string, { score: number; remarks: string }>>({});
  const [successMessage, setSuccessMessage] = useState<string | null>(null);

  useEffect(() => {
    async function load() {
      const roster = await getCourseStudents(selectedCourse);
      setStudents(roster);
      const initial: Record<string, any> = {};
      roster.forEach((s: any, idx: number) => {
        initial[s.student_id] = {
          score: 85 + (idx % 12),
          remarks: "Good conceptual execution",
        };
      });
      setScores(initial);
      setSuccessMessage(null);
    }
    load();
  }, [selectedCourse]);

  const handleScoreChange = (studentId: string, val: number) => {
    setScores((prev) => ({
      ...prev,
      [studentId]: {
        score: Math.min(Math.max(val, 0), maxScore),
        remarks: prev[studentId]?.remarks || "",
      },
    }));
  };

  const handleRemarksChange = (studentId: string, val: string) => {
    setScores((prev) => ({
      ...prev,
      [studentId]: {
        score: prev[studentId]?.score || 0,
        remarks: val,
      },
    }));
  };

  const classAvg = students.length
    ? (
        Object.values(scores).reduce((acc, curr) => acc + (curr.score || 0), 0) /
        students.length
      ).toFixed(1)
    : "0";

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    const payloadGrades = Object.entries(scores).map(([student_id, item]) => ({
      student_id,
      score: item.score,
      remarks: item.remarks,
    }));

    await submitGrades({
      course_id: selectedCourse,
      assessment_name: assessmentName,
      max_score: maxScore,
      grades: payloadGrades,
    });

    setSuccessMessage(
      `Assessment '${assessmentName}' published for ${payloadGrades.length} students. Class average: ${classAvg}/${maxScore}.`
    );
  };

  return (
    <div className="space-y-6">
      <div>
        <h2 className="text-2xl font-bold tracking-tight text-slate-900">
          Assessment Marks & Grade Entry
        </h2>
        <p className="text-xs sm:text-sm text-slate-500 mt-1">
          Requirement FAC-04: Upload grades, examination marks, and instructor feedback remarks.
        </p>
      </div>

      {successMessage && (
        <div className="flex items-center gap-3 p-4 rounded-xl border border-emerald-200 bg-emerald-50 text-emerald-800 text-sm animate-in fade-in duration-200">
          <CheckCircle2 className="h-5 w-5 text-emerald-600 shrink-0" />
          <span>{successMessage}</span>
        </div>
      )}

      {/* Assessment Setup */}
      <Card>
        <CardHeader className="pb-3">
          <CardTitle>Assessment Parameters</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
            <div className="space-y-1.5">
              <label className="text-xs font-semibold text-slate-700">
                Target Course
              </label>
              <select
                value={selectedCourse}
                onChange={(e) => setSelectedCourse(e.target.value)}
                className="flex h-9 w-full rounded-lg border border-slate-200 bg-white px-3 py-1 text-sm text-slate-900 focus:outline-none focus:ring-2 focus:ring-blue-500"
              >
                {courses.map((c) => (
                  <option key={c.course_id} value={c.course_id}>
                    {c.course_code} — {c.course_name}
                  </option>
                ))}
              </select>
            </div>

            <div className="space-y-1.5">
              <label className="text-xs font-semibold text-slate-700">
                Assessment Name
              </label>
              <Input
                value={assessmentName}
                onChange={(e) => setAssessmentName(e.target.value)}
                placeholder="e.g. Midterm Examination 2024"
              />
            </div>

            <div className="space-y-1.5">
              <label className="text-xs font-semibold text-slate-700">
                Maximum Score
              </label>
              <Input
                type="number"
                value={maxScore}
                onChange={(e) => setMaxScore(Number(e.target.value) || 100)}
              />
            </div>
          </div>
        </CardContent>
      </Card>

      {/* Grade Entry Table */}
      <Card>
        <CardHeader className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3 pb-3">
          <div>
            <CardTitle>Student Score Registry</CardTitle>
            <p className="text-xs text-slate-500">
              {students.length} Students Enrolled • Class Average:{" "}
              <strong className="text-blue-600">{classAvg}</strong> / {maxScore}
            </p>
          </div>
          <Badge variant="outline" className="text-xs bg-blue-50 text-blue-700">
            <Award className="mr-1 h-3.5 w-3.5" /> Max {maxScore} Pts
          </Badge>
        </CardHeader>
        <CardContent>
          <div className="overflow-x-auto rounded-lg border border-slate-100">
            <Table>
              <TableHeader className="bg-slate-50/70">
                <TableRow>
                  <TableHead>Roll Number</TableHead>
                  <TableHead>Student Name</TableHead>
                  <TableHead className="w-32">Score (/{maxScore})</TableHead>
                  <TableHead>Percentage</TableHead>
                  <TableHead>Feedback Remarks</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {students.map((student) => {
                  const score = scores[student.student_id]?.score ?? 0;
                  const remarks = scores[student.student_id]?.remarks ?? "";
                  const pct = ((score / maxScore) * 100).toFixed(1);

                  return (
                    <TableRow key={student.student_id}>
                      <TableCell className="font-mono text-xs font-semibold text-blue-600">
                        {student.roll_number}
                      </TableCell>
                      <TableCell className="font-medium text-slate-900">
                        {student.first_name} {student.last_name}
                      </TableCell>
                      <TableCell>
                        <Input
                          type="number"
                          value={score}
                          onChange={(e) =>
                            handleScoreChange(student.student_id, Number(e.target.value))
                          }
                          className="h-8 text-xs font-semibold text-center"
                          max={maxScore}
                          min={0}
                        />
                      </TableCell>
                      <TableCell>
                        <Badge
                          variant={Number(pct) >= 75 ? "success" : "warning"}
                        >
                          {pct}%
                        </Badge>
                      </TableCell>
                      <TableCell>
                        <Input
                          value={remarks}
                          onChange={(e) =>
                            handleRemarksChange(student.student_id, e.target.value)
                          }
                          placeholder="Feedback or comments..."
                          className="h-8 text-xs max-w-sm"
                        />
                      </TableCell>
                    </TableRow>
                  );
                })}
              </TableBody>
            </Table>
          </div>

          <div className="mt-5 flex justify-end">
            <Button
              onClick={handleSubmit}
              disabled={isSubmittingGrades}
              className="bg-blue-600 hover:bg-blue-700 text-white px-6 font-semibold"
            >
              <Check className="mr-2 h-4 w-4" />
              {isSubmittingGrades ? "Publishing..." : "Publish Assessment Grades"}
            </Button>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
