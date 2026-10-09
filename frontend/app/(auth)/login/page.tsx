"use client";

import React, { useState } from "react";
import { useAuth } from "@/hooks/useAuth";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { School, ShieldCheck, GraduationCap, BookOpen, ArrowRight } from "lucide-react";

export default function LoginPage() {
  const { loginAs } = useAuth();
  const [email, setEmail] = useState("admin@apex.edunexa.edu");
  const [password, setPassword] = useState("Admin@123");
  const [tenant, setTenant] = useState("apex.edunexa.edu");
  const [isSubmitting, setIsSubmitting] = useState(false);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    setIsSubmitting(true);
    const role = email.includes("admin")
      ? "admin"
      : email.includes("rajesh") || email.includes("faculty")
      ? "faculty"
      : "student";
    loginAs(role as any);
  };

  return (
    <div className="flex min-h-screen w-full flex-col lg:flex-row bg-slate-900">
      {/* Left Branding Panel */}
      <div className="relative flex flex-col justify-between p-8 lg:p-12 lg:w-1/2 bg-gradient-to-br from-slate-950 via-slate-900 to-blue-950 text-white border-b lg:border-b-0 lg:border-r border-slate-800">
        <div>
          <div className="flex items-center gap-3">
            <div className="flex h-11 w-11 items-center justify-center rounded-xl bg-blue-600 text-white shadow-lg">
              <School className="h-6 w-6" />
            </div>
            <div>
              <h1 className="text-2xl font-bold tracking-tight">EduNexa</h1>
              <p className="text-xs text-blue-400 font-medium tracking-wide uppercase">
                Enterprise Academic Management
              </p>
            </div>
          </div>

          <div className="mt-16 max-w-md space-y-6">
            <h2 className="text-3xl lg:text-4xl font-extrabold tracking-tight text-white leading-tight">
              One Unified Portal for Administrations, Faculty & Students.
            </h2>
            <p className="text-sm text-slate-300 leading-relaxed">
              Real-time attendance intelligence, academic calendar orchestration,
              grade administration, and digital learning distribution under strict
              multi-tenant isolation.
            </p>

            <div className="space-y-3 pt-4">
              <div className="flex items-center gap-3 text-sm text-slate-300">
                <ShieldCheck className="h-5 w-5 text-emerald-400" />
                <span>PostgreSQL Row-Level Security & Tenant Isolation</span>
              </div>
              <div className="flex items-center gap-3 text-sm text-slate-300">
                <GraduationCap className="h-5 w-5 text-blue-400" />
                <span>Automated Grade Book & Credit-Weighted GPA Tracking</span>
              </div>
              <div className="flex items-center gap-3 text-sm text-slate-300">
                <BookOpen className="h-5 w-5 text-purple-400" />
                <span>Centralized Digital Syllabus & Course Material Distribution</span>
              </div>
            </div>
          </div>
        </div>

        <div className="mt-12 text-xs text-slate-500">
          © 2026 EduNexa Systems. Multi-Tenant Academic Management Framework.
        </div>
      </div>

      {/* Right Login Panel */}
      <div className="flex flex-1 items-center justify-center p-6 lg:p-12 bg-slate-950/60">
        <div className="w-full max-w-md space-y-8 rounded-2xl border border-slate-800 bg-slate-900/80 p-8 backdrop-blur-xl shadow-2xl">
          <div className="space-y-2 text-center lg:text-left">
            <h3 className="text-xl font-bold tracking-tight text-white">
              Institutional Sign In
            </h3>
            <p className="text-xs text-slate-400">
              Access your role-based academic dashboard
            </p>
          </div>

          {/* Quick Demo Role Selectors */}
          <div className="space-y-2 rounded-xl border border-slate-800/80 bg-slate-950/50 p-3">
            <span className="text-[11px] font-semibold uppercase tracking-wider text-slate-400 block mb-2">
              Instant Demo Quick-Fill:
            </span>
            <div className="grid grid-cols-3 gap-2">
              <button
                type="button"
                onClick={() => {
                  setEmail("admin@apex.edunexa.edu");
                  setPassword("Admin@123");
                  loginAs("admin");
                }}
                className="rounded-lg border border-blue-800/60 bg-blue-950/40 p-2 text-center text-xs font-medium text-blue-300 hover:bg-blue-900/60 transition-colors cursor-pointer"
              >
                Admin
              </button>
              <button
                type="button"
                onClick={() => {
                  setEmail("rajesh.nambiar@apex.edunexa.edu");
                  setPassword("Faculty@123");
                  loginAs("faculty");
                }}
                className="rounded-lg border border-purple-800/60 bg-purple-950/40 p-2 text-center text-xs font-medium text-purple-300 hover:bg-purple-900/60 transition-colors cursor-pointer"
              >
                Faculty
              </button>
              <button
                type="button"
                onClick={() => {
                  setEmail("aarav.sharma1@apex.edunexa.edu");
                  setPassword("Student@123");
                  loginAs("student");
                }}
                className="rounded-lg border border-emerald-800/60 bg-emerald-950/40 p-2 text-center text-xs font-medium text-emerald-300 hover:bg-emerald-900/60 transition-colors cursor-pointer"
              >
                Student
              </button>
            </div>
          </div>

          <form onSubmit={handleSubmit} className="space-y-4">
            <div className="space-y-1.5">
              <label className="text-xs font-medium text-slate-300">
                Institutional Domain (Tenant)
              </label>
              <select
                value={tenant}
                onChange={(e) => setTenant(e.target.value)}
                className="flex h-9 w-full rounded-lg border border-slate-700 bg-slate-800 px-3 py-1 text-sm text-slate-100 focus:outline-none focus:ring-2 focus:ring-blue-500"
              >
                <option value="apex.edunexa.edu">apex.edunexa.edu (Apex Inst.)</option>
                <option value="horizon.edunexa.edu">horizon.edunexa.edu (Horizon Univ.)</option>
              </select>
            </div>

            <div className="space-y-1.5">
              <label className="text-xs font-medium text-slate-300">
                Official Email Address
              </label>
              <Input
                type="email"
                required
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                className="border-slate-700 bg-slate-800 text-slate-100 focus-visible:ring-blue-500"
                placeholder="name@apex.edunexa.edu"
              />
            </div>

            <div className="space-y-1.5">
              <label className="text-xs font-medium text-slate-300">
                Account Password
              </label>
              <Input
                type="password"
                required
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                className="border-slate-700 bg-slate-800 text-slate-100 focus-visible:ring-blue-500"
              />
            </div>

            <Button
              type="submit"
              disabled={isSubmitting}
              className="w-full bg-blue-600 hover:bg-blue-700 text-white font-medium py-2.5 mt-2"
            >
              Sign In to Portal <ArrowRight className="ml-2 h-4 w-4" />
            </Button>
          </form>
        </div>
      </div>
    </div>
  );
}
