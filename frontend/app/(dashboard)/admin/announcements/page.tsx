"use client";

import React, { useState } from "react";
import { useAdmin } from "@/hooks/useAdmin";
import { NoticeCard } from "@/components/shared/NoticeCard";
import { AnimatedList } from "@/components/animations/AnimatedList";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import {
  Dialog,
  DialogHeader,
  DialogTitle,
  DialogDescription,
  DialogFooter,
} from "@/components/ui/dialog";
import { Plus, Bell } from "lucide-react";

export default function AdminAnnouncementsPage() {
  const { announcements, createAnnouncement, deleteAnnouncement, isCreatingAnnouncement } =
    useAdmin();

  const [dialogOpen, setDialogOpen] = useState(false);
  const [title, setTitle] = useState("");
  const [content, setContent] = useState("");
  const [targetRole, setTargetRole] = useState("ALL");

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!title.trim() || !content.trim()) return;

    await createAnnouncement({
      title,
      content,
      target_role: targetRole,
    });

    setTitle("");
    setContent("");
    setTargetRole("ALL");
    setDialogOpen(false);
  };

  return (
    <div className="space-y-6">
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <h2 className="text-2xl font-bold tracking-tight text-slate-900">
            Institutional Notice Board
          </h2>
          <p className="text-xs sm:text-sm text-slate-500 mt-1">
            Requirement ADM-02: Publish global announcements & role-targeted advisories.
          </p>
        </div>
        <Button
          onClick={() => setDialogOpen(true)}
          className="bg-blue-600 hover:bg-blue-700 text-white"
        >
          <Plus className="mr-2 h-4 w-4" /> New Announcement
        </Button>
      </div>

      {/* Announcements List */}
      <div className="max-w-4xl">
        {announcements.length > 0 ? (
          <AnimatedList>
            {announcements.map((item) => (
              <NoticeCard
                key={item.announcement_id}
                id={item.announcement_id}
                title={item.title}
                content={item.content}
                targetRole={item.target_role}
                authorName={item.author_name}
                createdAt={item.created_at}
                onDelete={deleteAnnouncement}
                canDelete={true}
              />
            ))}
          </AnimatedList>
        ) : (
          <div className="flex flex-col items-center justify-center p-12 text-center rounded-xl border border-dashed border-slate-200 bg-white">
            <Bell className="h-10 w-10 text-slate-300 mb-3" />
            <p className="text-sm font-semibold text-slate-600">No active announcements</p>
            <p className="text-xs text-slate-400 mt-1">
              Publish an advisory to inform faculty and students across the campus.
            </p>
          </div>
        )}
      </div>

      {/* Publish Notice Modal */}
      <Dialog open={dialogOpen} onOpenChange={setDialogOpen}>
        <form onSubmit={handleSubmit}>
          <DialogHeader>
            <DialogTitle>Publish Institutional Announcement</DialogTitle>
            <DialogDescription>
              This announcement will immediately appear on the feeds of selected user roles.
            </DialogDescription>
          </DialogHeader>

          <div className="space-y-4 py-2">
            <div className="space-y-1.5">
              <label className="text-xs font-medium text-slate-700">
                Notice Title
              </label>
              <Input
                required
                placeholder="e.g. Schedule Revision for Midterm Examinations"
                value={title}
                onChange={(e) => setTitle(e.target.value)}
              />
            </div>

            <div className="space-y-1.5">
              <label className="text-xs font-medium text-slate-700">
                Target Audience
              </label>
              <select
                value={targetRole}
                onChange={(e) => setTargetRole(e.target.value)}
                className="flex h-9 w-full rounded-lg border border-slate-200 bg-white px-3 py-1 text-sm text-slate-900 focus:outline-none focus:ring-2 focus:ring-blue-500"
              >
                <option value="ALL">Entire Campus (All Roles)</option>
                <option value="FACULTY">Faculty Members Only</option>
                <option value="STUDENT">Students Only</option>
              </select>
            </div>

            <div className="space-y-1.5">
              <label className="text-xs font-medium text-slate-700">
                Announcement Body
              </label>
              <textarea
                required
                rows={4}
                placeholder="Provide detailed instructions, guidelines, or notice specifics..."
                value={content}
                onChange={(e) => setContent(e.target.value)}
                className="flex w-full rounded-lg border border-slate-200 bg-white p-3 text-sm text-slate-900 placeholder:text-slate-400 focus:outline-none focus:ring-2 focus:ring-blue-500"
              />
            </div>
          </div>

          <DialogFooter>
            <Button
              type="button"
              variant="outline"
              onClick={() => setDialogOpen(false)}
            >
              Cancel
            </Button>
            <Button
              type="submit"
              disabled={isCreatingAnnouncement}
              className="bg-blue-600 hover:bg-blue-700 text-white"
            >
              {isCreatingAnnouncement ? "Publishing..." : "Broadcast Notice"}
            </Button>
          </DialogFooter>
        </form>
      </Dialog>
    </div>
  );
}
