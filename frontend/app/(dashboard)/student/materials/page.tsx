"use client";

import React, { useState } from "react";
import { useStudent } from "@/hooks/useStudent";
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { FileText, Download, BookOpen, Search } from "lucide-react";
import { Input } from "@/components/ui/input";

export default function StudentMaterialsPage() {
  const { materials } = useStudent();
  const [search, setSearch] = useState("");

  const filtered = materials.filter(
    (m) =>
      m.title.toLowerCase().includes(search.toLowerCase()) ||
      m.course_code.toLowerCase().includes(search.toLowerCase())
  );

  return (
    <div className="space-y-6">
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <h2 className="text-2xl font-bold tracking-tight text-slate-900">
            Digital Course Materials & Study Resources
          </h2>
          <p className="text-xs sm:text-sm text-slate-500 mt-1">
            Requirement STD-04: Download lecture notes, slides, and syllabus packets.
          </p>
        </div>

        <div className="relative w-full sm:w-64">
          <Search className="absolute left-3 top-2.5 h-4 w-4 text-slate-400" />
          <Input
            placeholder="Search documents..."
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            className="pl-9"
          />
        </div>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
        {filtered.map((mat) => (
          <Card key={mat.material_id} className="flex flex-col justify-between hover:border-blue-300 transition-colors">
            <CardHeader className="pb-3">
              <div className="flex items-start justify-between gap-2">
                <Badge variant="outline" className="font-mono text-xs text-blue-700">
                  {mat.course_code}
                </Badge>
                <Badge variant="secondary" className="text-[10px]">
                  {mat.file_type} • {mat.file_size}
                </Badge>
              </div>
              <CardTitle className="text-sm font-semibold mt-2 line-clamp-2">
                {mat.title}
              </CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <p className="text-xs text-slate-600 line-clamp-3">
                {mat.description}
              </p>

              <div className="space-y-3 pt-3 border-t border-slate-100">
                <div className="flex items-center justify-between text-[11px] text-slate-400">
                  <span>Instructor: {mat.faculty_name}</span>
                  <span>Uploaded {mat.uploaded_at}</span>
                </div>
                <Button size="sm" className="w-full bg-blue-600 hover:bg-blue-700 text-white text-xs">
                  <Download className="mr-1.5 h-3.5 w-3.5" /> Download Document
                </Button>
              </div>
            </CardContent>
          </Card>
        ))}
      </div>
    </div>
  );
}
