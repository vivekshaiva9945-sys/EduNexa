"use client";

import React from "react";
import Link from "next/link";
import { usePathname } from "next/navigation";
import { cn } from "@/lib/utils";
import { MockUser } from "@/lib/mockData";
import {
  LayoutDashboard,
  Users,
  CalendarDays,
  FileText,
  Clock,
  GraduationCap,
  Bell,
  BookOpen,
  ClipboardCheck,
  TrendingUp,
  School,
  LogOut,
} from "lucide-react";

interface AppSidebarProps {
  user: MockUser | null;
  onLogout: () => void;
  className?: string;
}

export const AppSidebar: React.FC<AppSidebarProps> = ({
  user,
  onLogout,
  className = "",
}) => {
  const pathname = usePathname();
  const role = user?.role || "ADMIN";

  const adminLinks = [
    { href: "/admin/dashboard", label: "Dashboard", icon: LayoutDashboard },
    { href: "/admin/attendance", label: "Attendance Trends", icon: TrendingUp },
    { href: "/admin/announcements", label: "Notice Board", icon: Bell },
    { href: "/admin/faculty", label: "Faculty Records", icon: Users },
    { href: "/admin/calendar", label: "Academic Calendar", icon: CalendarDays },
  ];

  const facultyLinks = [
    { href: "/faculty/dashboard", label: "Dashboard", icon: LayoutDashboard },
    { href: "/faculty/attendance", label: "Mark Attendance", icon: ClipboardCheck },
    { href: "/faculty/timetable", label: "Teaching Schedule", icon: Clock },
    { href: "/faculty/grades", label: "Assessment Grades", icon: GraduationCap },
    { href: "/faculty/materials", label: "Course Materials", icon: BookOpen },
  ];

  const studentLinks = [
    { href: "/student/dashboard", label: "Dashboard", icon: LayoutDashboard },
    { href: "/student/attendance", label: "Attendance Log", icon: ClipboardCheck },
    { href: "/student/timetable", label: "Class Timetable", icon: Clock },
    { href: "/student/grades", label: "Grades & GPA", icon: GraduationCap },
    { href: "/student/materials", label: "Study Resources", icon: FileText },
    { href: "/student/calendar", label: "Events & Exams", icon: CalendarDays },
  ];

  const links =
    role === "ADMIN"
      ? adminLinks
      : role === "FACULTY"
      ? facultyLinks
      : studentLinks;

  return (
    <aside
      className={cn(
        "flex flex-col h-screen w-64 border-r border-slate-200/80 bg-slate-900 text-slate-200 shrink-0",
        className
      )}
    >
      {/* Brand & Tenant header */}
      <div className="p-5 border-b border-slate-800">
        <div className="flex items-center gap-2.5">
          <div className="flex h-9 w-9 items-center justify-center rounded-lg bg-blue-600 text-white shadow-md">
            <School className="h-5 w-5" />
          </div>
          <div>
            <h1 className="font-bold text-base tracking-tight text-white font-sans">
              EduNexa
            </h1>
            <span className="text-[10px] font-medium tracking-wide uppercase text-blue-400 block truncate max-w-[150px]">
              {user?.college_name || "Apex Institute"}
            </span>
          </div>
        </div>
      </div>

      {/* Role Pill */}
      <div className="px-5 py-3 border-b border-slate-800/60 bg-slate-950/40">
        <div className="flex items-center justify-between text-xs">
          <span className="text-slate-400">Current Role</span>
          <span className="font-semibold text-blue-400 bg-blue-950/80 border border-blue-800/60 px-2 py-0.5 rounded-md text-[10px] tracking-wider uppercase">
            {role}
          </span>
        </div>
      </div>

      {/* Navigation */}
      <nav className="flex-1 overflow-y-auto px-3 py-4 space-y-1">
        {links.map((link) => {
          const Icon = link.icon;
          const isActive = pathname === link.href;

          return (
            <Link
              key={link.href}
              href={link.href}
              className={cn(
                "flex items-center gap-3 px-3 py-2 rounded-lg text-sm font-medium transition-all group",
                isActive
                  ? "bg-blue-600 text-white shadow-sm font-semibold"
                  : "text-slate-400 hover:text-white hover:bg-slate-800/70"
              )}
            >
              <Icon
                className={cn(
                  "h-4 w-4 transition-transform group-hover:scale-110",
                  isActive ? "text-white" : "text-slate-400 group-hover:text-white"
                )}
              />
              <span>{link.label}</span>
            </Link>
          );
        })}
      </nav>

      {/* Footer Profile / Logout */}
      <div className="p-4 border-t border-slate-800 bg-slate-950/50">
        <div className="flex items-center justify-between">
          <div className="truncate pr-2">
            <p className="text-xs font-semibold text-white truncate">
              {user?.profile?.first_name} {user?.profile?.last_name}
            </p>
            <p className="text-[10px] text-slate-400 truncate">{user?.email}</p>
          </div>
          <button
            onClick={onLogout}
            title="Log out"
            className="flex h-8 w-8 items-center justify-center rounded-lg text-slate-400 hover:text-rose-400 hover:bg-rose-950/40 transition-colors cursor-pointer"
          >
            <LogOut className="h-4 w-4" />
          </button>
        </div>
      </div>
    </aside>
  );
};
