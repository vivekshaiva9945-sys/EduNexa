"use client";

import React, { useState } from "react";
import { useAdmin } from "@/hooks/useAdmin";
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import {
  Dialog,
  DialogHeader,
  DialogTitle,
  DialogDescription,
  DialogFooter,
} from "@/components/ui/dialog";
import { Calendar, Plus, CalendarDays, Sparkles } from "lucide-react";
import { formatDateTime } from "@/lib/utils";

export default function AdminCalendarPage() {
  const { calendarEvents, createCalendarEvent } = useAdmin();
  const [modalOpen, setModalOpen] = useState(false);
  const [title, setTitle] = useState("");
  const [type, setType] = useState("EXAM");
  const [startDate, setStartDate] = useState("");
  const [endDate, setEndDate] = useState("");
  const [description, setDescription] = useState("");

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!title || !startDate) return;

    await createCalendarEvent({
      event_title: title,
      event_type: type,
      start_date: startDate,
      end_date: endDate || startDate,
      description,
    });

    setTitle("");
    setDescription("");
    setStartDate("");
    setEndDate("");
    setModalOpen(false);
  };

  const getTypeBadge = (eventType: string) => {
    switch (eventType) {
      case "EXAM":
        return <Badge variant="destructive">EXAMINATION</Badge>;
      case "HOLIDAY":
        return <Badge variant="success">HOLIDAY / RECESS</Badge>;
      default:
        return <Badge variant="default">EVENT / WORKSHOP</Badge>;
    }
  };

  return (
    <div className="space-y-6">
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <h2 className="text-2xl font-bold tracking-tight text-slate-900">
            Institutional Academic Calendar
          </h2>
          <p className="text-xs sm:text-sm text-slate-500 mt-1">
            Requirement ENT-09: Manage institutional exams, holidays, and campus milestones.
          </p>
        </div>
        <Button
          onClick={() => setModalOpen(true)}
          className="bg-blue-600 hover:bg-blue-700 text-white"
        >
          <Plus className="mr-2 h-4 w-4" /> Add Academic Milestone
        </Button>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
        {calendarEvents.map((evt) => (
          <Card key={evt.event_id} className="hover:border-blue-300 transition-colors">
            <CardHeader className="pb-3">
              <div className="flex items-start justify-between gap-2">
                <CardTitle className="text-base font-semibold">
                  {evt.event_title}
                </CardTitle>
                {getTypeBadge(evt.event_type)}
              </div>
            </CardHeader>
            <CardContent className="space-y-3">
              <p className="text-xs sm:text-sm text-slate-600 leading-relaxed">
                {evt.description}
              </p>
              <div className="flex items-center gap-2 pt-2 border-t border-slate-100 text-xs font-medium text-slate-500">
                <CalendarDays className="h-4 w-4 text-blue-600" />
                <span>
                  {formatDateTime(evt.start_date)}
                  {evt.end_date !== evt.start_date && ` – ${formatDateTime(evt.end_date)}`}
                </span>
              </div>
            </CardContent>
          </Card>
        ))}
      </div>

      {/* Add Event Dialog */}
      <Dialog open={modalOpen} onOpenChange={setModalOpen}>
        <form onSubmit={handleSubmit}>
          <DialogHeader>
            <DialogTitle>Add Academic Calendar Event</DialogTitle>
            <DialogDescription>
              Broadcast examination windows and official institutional recess schedules.
            </DialogDescription>
          </DialogHeader>

          <div className="space-y-4 py-2">
            <div className="space-y-1.5">
              <label className="text-xs font-medium text-slate-700">
                Milestone Title
              </label>
              <Input
                required
                placeholder="e.g. End-Semester Laboratory Practicals"
                value={title}
                onChange={(e) => setTitle(e.target.value)}
              />
            </div>

            <div className="space-y-1.5">
              <label className="text-xs font-medium text-slate-700">
                Milestone Category
              </label>
              <select
                value={type}
                onChange={(e) => setType(e.target.value)}
                className="flex h-9 w-full rounded-lg border border-slate-200 bg-white px-3 py-1 text-sm text-slate-900 focus:outline-none focus:ring-2 focus:ring-blue-500"
              >
                <option value="EXAM">EXAM (Examinations & Tests)</option>
                <option value="HOLIDAY">HOLIDAY (Official Campus Recess)</option>
                <option value="EVENT">EVENT (Symposium, Seminar, Hackathon)</option>
              </select>
            </div>

            <div className="grid grid-cols-2 gap-3">
              <div className="space-y-1.5">
                <label className="text-xs font-medium text-slate-700">
                  Start Date
                </label>
                <Input
                  type="date"
                  required
                  value={startDate}
                  onChange={(e) => setStartDate(e.target.value)}
                />
              </div>
              <div className="space-y-1.5">
                <label className="text-xs font-medium text-slate-700">
                  End Date
                </label>
                <Input
                  type="date"
                  value={endDate}
                  onChange={(e) => setEndDate(e.target.value)}
                />
              </div>
            </div>

            <div className="space-y-1.5">
              <label className="text-xs font-medium text-slate-700">
                Description
              </label>
              <textarea
                rows={3}
                placeholder="Details regarding eligible departments, regulations, or dates..."
                value={description}
                onChange={(e) => setDescription(e.target.value)}
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
            <Button type="submit" className="bg-blue-600 hover:bg-blue-700 text-white">
              Schedule Milestone
            </Button>
          </DialogFooter>
        </form>
      </Dialog>
    </div>
  );
}
