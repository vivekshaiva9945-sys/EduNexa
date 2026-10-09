"use client";

import React, { useState } from "react";
import { useFaculty } from "@/hooks/useFaculty";
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Input } from "@/components/ui/input";
import {
  Dialog,
  DialogHeader,
  DialogTitle,
  DialogDescription,
  DialogFooter,
} from "@/components/ui/dialog";
import { Plus, FileText, Download, Trash2, BookOpen } from "lucide-react";
import { MOCK_MATERIALS } from "@/lib/mockData";

export default function FacultyMaterialsPage() {
  const { courses, uploadMaterial, isUploadingMaterial } = useFaculty();

  const [materials, setMaterials] = useState(MOCK_MATERIALS);
  const [selectedCourse, setSelectedCourse] = useState("ALL");
  const [modalOpen, setModalOpen] = useState(false);
  const [title, setTitle] = useState("");
  const [desc, setDesc] = useState("");
  const [targetCourse, setTargetCourse] = useState("crs-cs101");

  const filtered =
    selectedCourse === "ALL"
      ? materials
      : materials.filter((m) => m.course_id === selectedCourse);

  const handleUpload = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!title) return;

    const res = await uploadMaterial({
      course_id: targetCourse,
      title,
      description: desc,
      file_type: "PDF",
    });

    setMaterials((prev) => [
      {
        material_id: `mat-${Date.now()}`,
        course_id: targetCourse,
        course_code: courses.find((c) => c.course_id === targetCourse)?.course_code || "APEX-CS101",
        title,
        description: desc,
        file_type: "PDF",
        file_size: "2.8 MB",
        uploaded_at: new Date().toISOString().split("T")[0],
        faculty_name: "Dr. Rajesh Nambiar",
      },
      ...prev,
    ]);

    setTitle("");
    setDesc("");
    setModalOpen(false);
  };

  const handleDelete = (id: string) => {
    setMaterials((prev) => prev.filter((m) => m.material_id !== id));
  };

  return (
    <div className="space-y-6">
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <h2 className="text-2xl font-bold tracking-tight text-slate-900">
            Digital Course Materials Manager
          </h2>
          <p className="text-xs sm:text-sm text-slate-500 mt-1">
            Requirement FAC-05: Distribute syllabus notes, slides, and study guides.
          </p>
        </div>
        <Button
          onClick={() => setModalOpen(true)}
          className="bg-blue-600 hover:bg-blue-700 text-white"
        >
          <Plus className="mr-2 h-4 w-4" /> Upload Material
        </Button>
      </div>

      {/* Filter bar */}
      <div className="flex items-center gap-2 overflow-x-auto pb-1">
        <button
          onClick={() => setSelectedCourse("ALL")}
          className={`px-3 py-1.5 rounded-lg text-xs font-medium cursor-pointer transition-colors ${
            selectedCourse === "ALL"
              ? "bg-blue-600 text-white"
              : "bg-white border border-slate-200 text-slate-700 hover:bg-slate-50"
          }`}
        >
          All Courses
        </button>
        {courses.map((c) => (
          <button
            key={c.course_id}
            onClick={() => setSelectedCourse(c.course_id)}
            className={`px-3 py-1.5 rounded-lg text-xs font-medium whitespace-nowrap cursor-pointer transition-colors ${
              selectedCourse === c.course_id
                ? "bg-blue-600 text-white"
                : "bg-white border border-slate-200 text-slate-700 hover:bg-slate-50"
            }`}
          >
            {c.course_code}
          </button>
        ))}
      </div>

      {/* Materials Cards Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
        {filtered.map((mat) => (
          <Card key={mat.material_id} className="flex flex-col justify-between">
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
              <div className="flex items-center justify-between pt-3 border-t border-slate-100 text-[11px] text-slate-400">
                <span>Uploaded: {mat.uploaded_at}</span>
                <div className="flex items-center gap-2">
                  <button
                    onClick={() => handleDelete(mat.material_id)}
                    className="p-1 text-slate-400 hover:text-rose-600 cursor-pointer transition-colors"
                    title="Delete"
                  >
                    <Trash2 className="h-4 w-4" />
                  </button>
                  <Button size="sm" variant="outline" className="h-7 text-xs">
                    <Download className="mr-1 h-3 w-3" /> Download
                  </Button>
                </div>
              </div>
            </CardContent>
          </Card>
        ))}
      </div>

      {/* Upload Dialog */}
      <Dialog open={modalOpen} onOpenChange={setModalOpen}>
        <form onSubmit={handleUpload}>
          <DialogHeader>
            <DialogTitle>Distribute Course Material</DialogTitle>
            <DialogDescription>
              Upload documents, syllabus packets, or slides for enrolled students.
            </DialogDescription>
          </DialogHeader>

          <div className="space-y-4 py-2">
            <div className="space-y-1.5">
              <label className="text-xs font-medium text-slate-700">
                Course Section
              </label>
              <select
                value={targetCourse}
                onChange={(e) => setTargetCourse(e.target.value)}
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
              <label className="text-xs font-medium text-slate-700">
                Document Title
              </label>
              <Input
                required
                placeholder="e.g. Module 3: Dynamic Programming Notes"
                value={title}
                onChange={(e) => setTitle(e.target.value)}
              />
            </div>

            <div className="space-y-1.5">
              <label className="text-xs font-medium text-slate-700">
                Summary / Description
              </label>
              <textarea
                rows={3}
                placeholder="Key topics covered, reading references, practice questions..."
                value={desc}
                onChange={(e) => setDesc(e.target.value)}
                className="flex w-full rounded-lg border border-slate-200 bg-white p-3 text-sm text-slate-900 focus:outline-none focus:ring-2 focus:ring-blue-500"
              />
            </div>
          </div>

          <DialogFooter>
            <Button
              type="button"
              variant="outline"
              onClick={() => setModalOpen(false)}
            >
              Cancel
            </Button>
            <Button
              type="submit"
              disabled={isUploadingMaterial}
              className="bg-blue-600 hover:bg-blue-700 text-white"
            >
              {isUploadingMaterial ? "Uploading..." : "Publish Material"}
            </Button>
          </DialogFooter>
        </form>
      </Dialog>
    </div>
  );
}
