"use client";

import React from "react";
import { MockUser } from "@/lib/mockData";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Building2, UserCheck, Menu } from "lucide-react";

interface HeaderBarProps {
  user: MockUser | null;
  onSwitchRole: (role: "admin" | "faculty" | "student") => void;
  onSwitchTenant: (name: string, domain: string) => void;
  onToggleMobileMenu?: () => void;
}

export const HeaderBar: React.FC<HeaderBarProps> = ({
  user,
  onSwitchRole,
  onSwitchTenant,
  onToggleMobileMenu,
}) => {
  const isApex = user?.college_domain?.includes("apex");

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

      <div className="flex items-center gap-2 sm:gap-3">
        {/* Tenant toggle */}
        <div className="hidden lg:flex items-center bg-slate-100 dark:bg-slate-800 p-1 rounded-lg text-xs">
          <button
            onClick={() =>
              onSwitchTenant("Apex Institute of Technology", "apex.edunexa.edu")
            }
            className={`px-2 py-1 rounded-md transition-all cursor-pointer ${
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
            className={`px-2 py-1 rounded-md transition-all cursor-pointer ${
              !isApex
                ? "bg-white dark:bg-slate-900 text-blue-600 font-semibold shadow-xs"
                : "text-slate-500 hover:text-slate-900"
            }`}
          >
            Horizon Univ.
          </button>
        </div>

        {/* Role Quick Switch for pairing / demo evaluation */}
        <div className="flex items-center gap-1 bg-slate-100 dark:bg-slate-800/80 p-1 rounded-lg">
          <Button
            size="sm"
            variant={user?.role === "ADMIN" ? "default" : "ghost"}
            className="h-7 text-xs px-2.5"
            onClick={() => onSwitchRole("admin")}
          >
            Admin
          </Button>
          <Button
            size="sm"
            variant={user?.role === "FACULTY" ? "default" : "ghost"}
            className="h-7 text-xs px-2.5"
            onClick={() => onSwitchRole("faculty")}
          >
            Faculty
          </Button>
          <Button
            size="sm"
            variant={user?.role === "STUDENT" ? "default" : "ghost"}
            className="h-7 text-xs px-2.5"
            onClick={() => onSwitchRole("student")}
          >
            Student
          </Button>
        </div>

        {/* Profile Avatar */}
        <div className="flex items-center gap-2 pl-2 border-l border-slate-200 dark:border-slate-800">
          <div className="flex h-8 w-8 items-center justify-center rounded-full bg-blue-100 text-blue-700 dark:bg-blue-900/60 dark:text-blue-300 font-semibold text-xs border border-blue-200 dark:border-blue-700">
            {user?.profile?.first_name?.[0] || "U"}
          </div>
        </div>
      </div>
    </header>
  );
};
