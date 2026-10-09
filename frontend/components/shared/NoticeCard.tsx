"use client";

import React from "react";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent } from "@/components/ui/card";
import { formatDateTime } from "@/lib/utils";
import { Bell, Trash2 } from "lucide-react";

interface NoticeCardProps {
  id?: string;
  title: string;
  content: string;
  targetRole?: string;
  authorName?: string;
  createdAt?: string;
  onDelete?: (id: string) => void;
  canDelete?: boolean;
}

export const NoticeCard: React.FC<NoticeCardProps> = ({
  id,
  title,
  content,
  targetRole = "ALL",
  authorName,
  createdAt,
  onDelete,
  canDelete = false,
}) => {
  const getBadgeVariant = (role: string) => {
    switch (role) {
      case "STUDENT":
        return "success";
      case "FACULTY":
        return "warning";
      default:
        return "default";
    }
  };

  return (
    <Card className="hover:border-blue-200 dark:hover:border-blue-900/50 transition-colors">
      <CardContent className="p-4 sm:p-5">
        <div className="flex items-start justify-between gap-3">
          <div className="flex items-start gap-3">
            <div className="mt-0.5 flex h-8 w-8 shrink-0 items-center justify-center rounded-lg bg-blue-50 text-blue-600 dark:bg-blue-950/60 dark:text-blue-400">
              <Bell className="h-4 w-4" />
            </div>
            <div>
              <div className="flex flex-wrap items-center gap-2">
                <h4 className="text-sm sm:text-base font-semibold text-slate-900 dark:text-white">
                  {title}
                </h4>
                <Badge variant={getBadgeVariant(targetRole) as any}>
                  {targetRole}
                </Badge>
              </div>
              <p className="mt-1.5 text-xs sm:text-sm text-slate-600 dark:text-slate-300 leading-relaxed">
                {content}
              </p>
              <div className="mt-3 flex items-center gap-3 text-xs text-slate-400 dark:text-slate-500">
                {authorName && <span>By {authorName}</span>}
                {createdAt && <span>• {formatDateTime(createdAt)}</span>}
              </div>
            </div>
          </div>

          {canDelete && id && onDelete && (
            <button
              onClick={() => onDelete(id)}
              className="rounded-md p-1.5 text-slate-400 hover:bg-rose-50 hover:text-rose-600 dark:hover:bg-rose-950/40 dark:hover:text-rose-400 cursor-pointer transition-colors"
              title="Delete announcement"
            >
              <Trash2 className="h-4 w-4" />
            </button>
          )}
        </div>
      </CardContent>
    </Card>
  );
};
