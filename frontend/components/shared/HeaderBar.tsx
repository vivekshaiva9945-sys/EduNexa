"use client";

import React from "react";
import { MockUser } from "@/lib/mockData";
import { Badge } from "@/components/ui/badge";
import { Building2, ShieldCheck, GraduationCap, BookOpen, Menu } from "lucide-react";

interface HeaderBarProps {
  user: MockUser | null;
  onSwitchTenant: (name: string, domain: string) => void;
  onToggleMobileMenu?: () => void;
}

export const HeaderBar: React.FC<HeaderBarProps> = ({
  user,
  onSwitchTenant,
  onToggleMobileMenu,
}) => {
  const isApex = user?.college_domain?.includes("apex");
  const role = user?.role?.toUpperCase() || "USER";

  const renderRoleBadge = () => {
    switch (role) {
      case "ADMIN":
        return (
          <div className="flex items-center gap-1.5 px-3 py-1 rounded-full bg-indigo-50 dark:bg-indigo-950/60 border border-indigo-200 dark:border-indigo-800/80 text-indigo-700 dark:text-indigo-300 font-semibold text-xs shadow-xs">
            <ShieldCheck className="h-3.5 w-3.5 text-indigo-600 dark:text-indigo-400" />
            <span className="tracking-wide">Administrator</span>
          </div>
        );
      case "FACULTY":
        return (
          <div className="flex items-center gap-1.5 px-3 py-1 rounded-full bg-blue-50 dark:bg-blue-950/60 border border-blue-200 dark:border-blue-800/80 text-blue-700 dark:text-blue-300 font-semibold text-xs shadow-xs">
            <BookOpen className="h-3.5 w-3.5 text-blue-600 dark:text-blue-400" />
            <span className="tracking-wide">Faculty</span>
          </div>
        );
      case "STUDENT":
        return (
          <div className="flex items-center gap-1.5 px-3 py-1 rounded-full bg-emerald-50 dark:bg-emerald-950/60 border border-emerald-200 dark:border-emerald-800/80 text-emerald-700 dark:text-emerald-300 font-semibold text-xs shadow-xs">
            <GraduationCap className="h-3.5 w-3.5 text-emerald-600 dark:text-emerald-400" />
            <span className="tracking-wide">Student</span>
          </div>
        );
      default:
        return (
          <Badge variant="outline" className="text-xs uppercase font-semibold">
            {role}
          </Badge>
        );
    }
  };

  return (
    <header className="sticky top-0 z-30 flex h-16 w-full items-center justify-between border-b border-slate-200/80 bg-white/80 px-4 md:px-6 backdrop-blur-md dark:border-slate-800 dark:bg-slate-900/80">
      <div className="flex items-center gap-3">
        {onToggleMobileMenu && (
          <button
            onClick={onToggleMobileMenu}
            className="md:hidden flex h-9 w-9 items-center justify-center rounded-lg border border-slate-200 text-slate-600 dark:border-slate-800 dark:text-slate-300"
          >
            <Menu className="h-5 w-5" />
          </button>
        )}

        <div className="hidden sm:flex items-center gap-2">
          <Building2 className="h-4 w-4 text-blue-600 dark:text-blue-400" />
          <span className="text-xs md:text-sm font-semibold text-slate-800 dark:text-slate-100">
            {user?.college_name || "Apex Institute of Technology"}
          </span>
          <Badge variant="outline" className="text-[10px] hidden md:inline-flex">
            {user?.college_domain}
          </Badge>
        </div>
      </div>

      <div className="flex items-center gap-3">
        {/* Tenant selector */}
        <div className="hidden lg:flex items-center bg-slate-100 dark:bg-slate-800 p-1 rounded-lg text-xs">
          <button
            onClick={() =>
              onSwitchTenant("Apex Institute of Technology", "apex.edunexa.edu")
            }
            className={`px-2.5 py-1 rounded-md transition-all cursor-pointer ${
              isApex
                ? "bg-white dark:bg-slate-900 text-blue-600 font-semibold shadow-xs"
                : "text-slate-500 hover:text-slate-900"
            }`}
          >
            Apex Inst.
          </button>
          <button
            onClick={() =>
              onSwitchTenant("Horizon University", "horizon.edunexa.edu")
            }
            className={`px-2.5 py-1 rounded-md transition-all cursor-pointer ${
              !isApex
                ? "bg-white dark:bg-slate-900 text-blue-600 font-semibold shadow-xs"
                : "text-slate-500 hover:text-slate-900"
            }`}
          >
            Horizon Univ.
          </button>
        </div>

        {/* Static Authenticated Role Badge based strictly on session data */}
        {renderRoleBadge()}

        {/* Profile Avatar & Identity */}
        <div className="flex items-center gap-2 pl-3 border-l border-slate-200 dark:border-slate-800">
          <div className="flex h-8 w-8 items-center justify-center rounded-full bg-blue-100 text-blue-700 dark:bg-blue-900/60 dark:text-blue-300 font-semibold text-xs border border-blue-200 dark:border-blue-700">
            {user?.profile?.first_name?.[0] || "U"}
          </div>
          <span className="hidden xl:inline-block text-xs font-medium text-slate-700 dark:text-slate-300">
            {user?.profile?.first_name} {user?.profile?.last_name}
          </span>
        </div>
      </div>
    </header>
  );
};
