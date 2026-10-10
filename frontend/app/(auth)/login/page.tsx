"use client";

import React, { useState } from "react";
import { useAuth } from "@/hooks/useAuth";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { SoftAurora } from "@/components/animations/SoftAurora";
import {
  School,
  ShieldCheck,
  GraduationCap,
  BookOpen,
  ArrowRight,
  Sparkles,
} from "lucide-react";
import Link from "next/link";

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
    <div className="relative min-h-screen w-full overflow-hidden bg-slate-950 flex flex-col lg:flex-row">
      {/* 3. AUTHENTICATION PAGES (Login / Signup) - Immersive Soft Aurora WebGL Background */}
      <div className="absolute inset-0 z-0 pointer-events-none opacity-85">
        <SoftAurora
          speed={0.4}
          scale={1.35}
          brightness={1.05}
          color1="#6366f1" // Deep indigo / electric purple
          color2="#ec4899" // Electric pink / magenta
          noiseFrequency={2.2}
          noiseAmplitude={0.9}
          bandSpread={1.2}
          layerOffset={0.35}
          enableMouseInteraction={true}
          mouseInfluence={0.2}
        />
        {/* Calming gradient vignette overlay to guarantee contrast and legibility */}
        <div className="absolute inset-0 bg-gradient-to-t from-slate-950 via-slate-950/40 to-slate-950/80" />
      </div>

      {/* Left Branding Panel (Glassmorphism Container) */}
      <div className="relative z-10 flex flex-col justify-between p-8 lg:p-14 lg:w-1/2 bg-slate-950/50 backdrop-blur-2xl text-white border-b lg:border-b-0 lg:border-r border-slate-800/60 shadow-2xl">
        <div>
          <div className="flex items-center justify-between">
            <Link href="/" className="flex items-center gap-3 group">
              <div className="flex h-12 w-12 items-center justify-center rounded-2xl bg-gradient-to-br from-blue-500 to-indigo-600 text-white shadow-lg shadow-indigo-500/25 border border-indigo-400/30 group-hover:scale-105 transition-transform">
                <School className="h-6 w-6" />
              </div>
              <div>
                <div className="flex items-center gap-2">
                  <h1 className="text-2xl font-black tracking-tight bg-gradient-to-r from-white via-slate-100 to-indigo-200 bg-clip-text text-transparent">
                    EduNexa
                  </h1>
                  <span className="px-2 py-0.5 rounded-full text-[10px] font-bold bg-indigo-500/20 text-indigo-300 border border-indigo-500/30 flex items-center gap-1">
                    <Sparkles className="w-2.5 h-2.5 text-pink-400" /> v2.4
                  </span>
                </div>
                <p className="text-[11px] text-indigo-300 font-semibold tracking-wider uppercase">
                  Enterprise Academic Cloud
                </p>
              </div>
            </Link>

            <Link
              href="/"
              className="text-xs text-slate-400 hover:text-white transition-colors flex items-center gap-1 px-3 py-1.5 rounded-lg bg-slate-900/60 border border-slate-800 hover:border-slate-700"
            >
              ← Back to Portal
            </Link>
          </div>

          <div className="mt-14 max-w-lg space-y-6">
            <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-indigo-950/60 border border-indigo-700/40 text-indigo-300 text-xs font-medium">
              <span className="relative flex h-2 w-2">
                <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-indigo-400 opacity-75"></span>
                <span className="relative inline-flex rounded-full h-2 w-2 bg-indigo-500"></span>
              </span>
              Next-Gen Academic Orchestration Engine
            </div>

            <h2 className="text-3xl lg:text-5xl font-black tracking-tight text-white leading-tight">
              A stress-free gateway for academic excellence.
            </h2>
            <p className="text-sm lg:text-base text-slate-300/90 leading-relaxed font-normal">
              Unified tenant access for university leadership, faculty researchers, and student scholars with instantaneous data synchronization.
            </p>

            <div className="space-y-3.5 pt-2">
              <div className="flex items-center gap-3.5 p-3 rounded-xl bg-slate-900/40 border border-slate-800/60 backdrop-blur-md">
                <div className="p-2 rounded-lg bg-emerald-500/10 text-emerald-400 border border-emerald-500/20">
                  <ShieldCheck className="h-5 w-5" />
                </div>
                <div>
                  <h4 className="text-xs font-bold text-slate-200">Tenant-Isolated Security</h4>
                  <p className="text-[11px] text-slate-400">PostgreSQL Row-Level Security with zero cross-tenant bleeding.</p>
                </div>
              </div>

              <div className="flex items-center gap-3.5 p-3 rounded-xl bg-slate-900/40 border border-slate-800/60 backdrop-blur-md">
                <div className="p-2 rounded-lg bg-blue-500/10 text-blue-400 border border-blue-500/20">
                  <GraduationCap className="h-5 w-5" />
                </div>
                <div>
                  <h4 className="text-xs font-bold text-slate-200">Automated Grade Ledger</h4>
                  <p className="text-[11px] text-slate-400">Instant credit-weighted GPA tracking and exam verification.</p>
                </div>
              </div>

              <div className="flex items-center gap-3.5 p-3 rounded-xl bg-slate-900/40 border border-slate-800/60 backdrop-blur-md">
                <div className="p-2 rounded-lg bg-purple-500/10 text-purple-400 border border-purple-500/20">
                  <BookOpen className="h-5 w-5" />
                </div>
                <div>
                  <h4 className="text-xs font-bold text-slate-200">Digital Resource Distribution</h4>
                  <p className="text-[11px] text-slate-400">Synchronized curriculum materials, lecture files & syllabi.</p>
                </div>
              </div>
            </div>
          </div>
        </div>

        <div className="mt-12 text-xs text-slate-500 flex items-center justify-between border-t border-slate-800/60 pt-4">
          <span>© 2026 EduNexa Systems Inc.</span>
          <span className="text-[11px] text-slate-400">Secured with 256-bit TLS</span>
        </div>
      </div>

      {/* Right Login Panel */}
      <div className="relative z-10 flex flex-1 items-center justify-center p-6 lg:p-12">
        <div className="w-full max-w-md space-y-7 rounded-3xl border border-slate-700/60 bg-slate-900/75 p-8 lg:p-10 backdrop-blur-2xl shadow-2xl shadow-indigo-950/50">
          <div className="space-y-2 text-center lg:text-left">
            <h3 className="text-2xl font-black tracking-tight text-white">
              Institutional Sign In
            </h3>
            <p className="text-xs text-slate-300">
              Select an account role or supply your university credentials
            </p>
          </div>

          {/* Quick Demo Role Selectors */}
          <div className="space-y-2.5 rounded-2xl border border-slate-700/50 bg-slate-950/60 p-3.5">
            <div className="flex items-center justify-between">
              <span className="text-[11px] font-bold uppercase tracking-wider text-slate-400 flex items-center gap-1.5">
                <Sparkles className="w-3 h-3 text-indigo-400" /> Instant Demo Quick-Fill:
              </span>
              <span className="text-[10px] text-slate-500">One-click sign in</span>
            </div>
            <div className="grid grid-cols-3 gap-2">
              <button
                type="button"
                onClick={() => {
                  setEmail("admin@apex.edunexa.edu");
                  setPassword("Admin@123");
                  loginAs("admin");
                }}
                className="rounded-xl border border-blue-600/50 bg-blue-950/50 p-2.5 text-center text-xs font-bold text-blue-300 hover:bg-blue-900/70 hover:scale-[1.02] active:scale-[0.98] transition-all cursor-pointer shadow-sm"
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
                className="rounded-xl border border-purple-600/50 bg-purple-950/50 p-2.5 text-center text-xs font-bold text-purple-300 hover:bg-purple-900/70 hover:scale-[1.02] active:scale-[0.98] transition-all cursor-pointer shadow-sm"
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
                className="rounded-xl border border-emerald-600/50 bg-emerald-950/50 p-2.5 text-center text-xs font-bold text-emerald-300 hover:bg-emerald-900/70 hover:scale-[1.02] active:scale-[0.98] transition-all cursor-pointer shadow-sm"
              >
                Student
              </button>
            </div>
          </div>

          <form onSubmit={handleSubmit} className="space-y-4">
            <div className="space-y-1.5">
              <label className="text-xs font-semibold text-slate-300">
                Institutional Domain (Tenant)
              </label>
              <select
                value={tenant}
                onChange={(e) => setTenant(e.target.value)}
                className="flex h-10 w-full rounded-xl border border-slate-700 bg-slate-800/90 px-3 py-1.5 text-sm text-slate-100 focus:outline-none focus:ring-2 focus:ring-indigo-500 transition-all"
              >
                <option value="apex.edunexa.edu">apex.edunexa.edu (Apex Inst.)</option>
                <option value="horizon.edunexa.edu">horizon.edunexa.edu (Horizon Univ.)</option>
              </select>
            </div>

            <div className="space-y-1.5">
              <label className="text-xs font-semibold text-slate-300">
                Official Email Address
              </label>
              <Input
                type="email"
                required
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                className="h-10 rounded-xl border-slate-700 bg-slate-800/90 text-slate-100 placeholder:text-slate-500 focus-visible:ring-indigo-500"
                placeholder="name@apex.edunexa.edu"
              />
            </div>

            <div className="space-y-1.5">
              <div className="flex items-center justify-between">
                <label className="text-xs font-semibold text-slate-300">
                  Account Password
                </label>
                <span className="text-[11px] text-indigo-400 hover:underline cursor-pointer">
                  Forgot?
                </span>
              </div>
              <Input
                type="password"
                required
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                className="h-10 rounded-xl border-slate-700 bg-slate-800/90 text-slate-100 focus-visible:ring-indigo-500"
              />
            </div>

            <Button
              type="submit"
              disabled={isSubmitting}
              className="w-full h-11 rounded-xl bg-gradient-to-r from-blue-600 via-indigo-600 to-purple-600 hover:from-blue-500 hover:to-purple-500 text-white font-bold py-2.5 mt-3 shadow-lg shadow-indigo-600/30 hover:shadow-indigo-600/50 hover:scale-[1.01] active:scale-[0.99] transition-all cursor-pointer"
            >
              Sign In to Portal <ArrowRight className="ml-2 h-4 w-4" />
            </Button>
          </form>
        </div>
      </div>
    </div>
  );
}
