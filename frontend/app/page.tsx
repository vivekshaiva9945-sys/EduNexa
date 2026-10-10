"use client";

import React from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { useAuth } from "@/hooks/useAuth";
import { LineWaves } from "@/components/animations/LineWaves";
import { CircularCarousel } from "@/components/animations/CircularCarousel";
import { DecryptedText } from "@/components/animations/DecryptedText";
import { Button } from "@/components/ui/button";
import {
  School,
  ShieldCheck,
  GraduationCap,
  Sparkles,
  ArrowRight,
  Layers,
  Cpu,
  CheckCircle2,
  Users,
  Compass,
} from "lucide-react";

export default function LandingPage() {
  const router = useRouter();
  const { user, loginAs } = useAuth();

  const handlePortalLaunch = () => {
    if (user) {
      if (user.role === "ADMIN") router.push("/admin/dashboard");
      else if (user.role === "FACULTY") router.push("/faculty/dashboard");
      else router.push("/student/dashboard");
    } else {
      router.push("/login");
    }
  };

  const showcaseItems = [
    {
      code: "CS-301",
      credits: "4 Credits • Core",
      src: "https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=600&q=80",
      title: "Distributed Computing Systems",
      subtitle: "Dr. Rajesh Nambiar • Dept. of Computer Science",
      tag: "Computer Science",
      rating: "4.95 (142 enrolled)",
    },
    {
      code: "AI-402",
      credits: "4 Credits • Advanced",
      src: "https://images.unsplash.com/photo-1555949963-ff9fe0c870eb?w=600&q=80",
      title: "Deep Neural Networks & NLP",
      subtitle: "Prof. Sarah Connor • Machine Intelligence Lab",
      tag: "Artificial Intelligence",
      rating: "4.98 (210 enrolled)",
    },
    {
      code: "MATH-204",
      credits: "3 Credits • Theory",
      src: "https://images.unsplash.com/photo-1509228468518-180dd4864904?w=600&q=80",
      title: "Discrete Mathematics & Logic",
      subtitle: "Dr. Alan Turing • Mathematical Sciences",
      tag: "Mathematics",
      rating: "4.88 (98 enrolled)",
    },
    {
      code: "ECE-310",
      credits: "4 Credits • Lab Included",
      src: "https://images.unsplash.com/photo-1518770660439-4636190af475?w=600&q=80",
      title: "Real-time Embedded Systems",
      subtitle: "Prof. H. Karimi • Dept. of Microelectronics",
      tag: "Electronics",
      rating: "4.91 (115 enrolled)",
    },
    {
      code: "CS-415",
      credits: "3 Credits • Elective",
      src: "https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=600&q=80",
      title: "Cloud Infrastructure Architecture",
      subtitle: "Dr. Rajesh Nambiar • Systems Architecture",
      tag: "Cloud & DevOps",
      rating: "4.96 (180 enrolled)",
    },
  ];

  return (
    <div className="relative min-h-screen w-full bg-slate-950 text-slate-100 overflow-x-hidden selection:bg-indigo-500 selection:text-white">
      {/* Navigation Bar */}
      <nav className="sticky top-0 z-50 w-full border-b border-slate-800/80 bg-slate-950/75 backdrop-blur-xl">
        <div className="mx-auto flex max-w-7xl items-center justify-between px-6 py-4">
          <Link href="/" className="flex items-center gap-3 group">
            <div className="flex h-10 w-10 items-center justify-center rounded-xl bg-gradient-to-br from-blue-500 to-indigo-600 text-white shadow-lg shadow-indigo-500/25 border border-indigo-400/30 group-hover:scale-105 transition-transform">
              <School className="h-5 w-5" />
            </div>
            <div>
              <span className="text-xl font-black tracking-tight text-white">
                EduNexa
              </span>
              <span className="ml-2 rounded-full bg-indigo-500/10 px-2 py-0.5 text-[10px] font-bold text-indigo-400 border border-indigo-500/20">
                PRO
              </span>
            </div>
          </Link>

          <div className="hidden md:flex items-center gap-6 text-sm font-medium text-slate-300">
            <a href="#hero" className="hover:text-white transition-colors">
              Platform
            </a>
            <a href="#showcase" className="hover:text-white transition-colors">
              Curriculum Showcase
            </a>
            <a href="#roles" className="hover:text-white transition-colors">
              Role Access
            </a>
            <Link
              href="/break"
              className="text-xs text-indigo-400 hover:text-indigo-300 transition-colors flex items-center gap-1 px-2.5 py-1 rounded-full bg-indigo-950/60 border border-indigo-800/50"
            >
              <Compass className="w-3.5 h-3.5" /> Student Break
            </Link>
          </div>

          <div className="flex items-center gap-3">
            {user ? (
              <Button
                onClick={handlePortalLaunch}
                className="bg-gradient-to-r from-blue-600 to-indigo-600 hover:from-blue-500 hover:to-indigo-500 text-white text-xs font-bold px-4 py-2 rounded-xl shadow-lg shadow-indigo-600/30 hover:shadow-indigo-600/50 hover:scale-105 transition-all cursor-pointer"
              >
                Go to {user.role} Dashboard <ArrowRight className="ml-1.5 h-3.5 w-3.5" />
              </Button>
            ) : (
              <Link href="/login">
                <Button className="bg-indigo-600 hover:bg-indigo-500 text-white text-xs font-bold px-4 py-2 rounded-xl shadow-md shadow-indigo-600/30 hover:scale-105 transition-all cursor-pointer">
                  Sign In <ArrowRight className="ml-1.5 h-3.5 w-3.5" />
                </Button>
              </Link>
            )}
          </div>
        </div>
      </nav>

      {/* 2. HERO SECTION - The "Wow" Factor with Line Waves */}
      <section id="hero" className="relative min-h-[90vh] w-full flex items-center justify-center px-6 py-20 overflow-hidden">
        {/* Kinetic WebGL Shader Background */}
        <div className="absolute inset-0 z-0 pointer-events-none opacity-90">
          <LineWaves
            speed={0.35}
            innerLineCount={42.0}
            outerLineCount={48.0}
            warpIntensity={1.35}
            rotation={-35}
            brightness={0.38}
            color1="#38bdf8" // Neon Sky Blue
            color2="#818cf8" // Neon Indigo
            color3="#c084fc" // Neon Purple
            enableMouseInteraction={true}
            mouseInfluence={2.8}
          />
          {/* Subtle Radial Vignette for Content Contrast */}
          <div className="absolute inset-0 bg-radial-gradient from-transparent via-slate-950/50 to-slate-950" />
        </div>

        {/* Sleek Glassmorphism Hero Container */}
        <div className="relative z-10 mx-auto max-w-4xl w-full rounded-3xl border border-slate-700/60 bg-slate-900/60 p-8 md:p-14 backdrop-blur-2xl shadow-2xl shadow-indigo-950/60 text-center space-y-8">
          <div className="inline-flex items-center gap-2 px-3.5 py-1.5 rounded-full bg-indigo-950/70 border border-indigo-600/40 text-indigo-300 text-xs font-semibold shadow-inner">
            <Sparkles className="w-3.5 h-3.5 text-pink-400" />
            <span>Next-Generation Academic Management Engine</span>
          </div>

          <div className="space-y-4">
            <h1 className="text-4xl sm:text-6xl md:text-7xl font-black tracking-tight text-white leading-[1.08]">
              Where Academic Rigor Meets{" "}
              <span className="bg-gradient-to-r from-blue-400 via-indigo-300 to-pink-400 bg-clip-text text-transparent">
                <DecryptedText text="Fluid Intelligence" speed={35} />
              </span>
            </h1>
            <p className="mx-auto max-w-2xl text-sm sm:text-base md:text-lg text-slate-300 font-normal leading-relaxed">
              Empower university administration, faculty mentors, and students with real-time attendance telemetry, multi-tenant row isolation, and automated grade ledgers.
            </p>
          </div>

          {/* Action CTAs inside Glass Container */}
          <div className="flex flex-col sm:flex-row items-center justify-center gap-4 pt-2">
            <Button
              onClick={handlePortalLaunch}
              className="w-full sm:w-auto h-12 px-8 rounded-2xl bg-gradient-to-r from-blue-600 via-indigo-600 to-purple-600 hover:from-blue-500 hover:to-purple-500 text-white font-extrabold text-sm shadow-xl shadow-indigo-600/35 hover:shadow-indigo-600/60 hover:scale-105 active:scale-95 transition-all cursor-pointer"
            >
              Launch Institutional Portal <ArrowRight className="ml-2 h-4 w-4" />
            </Button>
            <Link href="/login" className="w-full sm:w-auto">
              <Button
                variant="outline"
                className="w-full sm:w-auto h-12 px-7 rounded-2xl border-slate-700 bg-slate-900/70 hover:bg-slate-800 text-slate-200 font-semibold text-sm hover:text-white hover:border-slate-500 transition-all cursor-pointer"
              >
                Access Role Demo
              </Button>
            </Link>
          </div>

          {/* Feature Badges */}
          <div className="grid grid-cols-1 sm:grid-cols-3 gap-3 pt-6 border-t border-slate-800/80 text-left">
            <div className="flex items-center gap-3 p-3 rounded-xl bg-slate-950/40 border border-slate-800/60">
              <ShieldCheck className="h-5 w-5 text-emerald-400 shrink-0" />
              <div>
                <p className="text-xs font-bold text-white">PostgreSQL RLS</p>
                <p className="text-[11px] text-slate-400">Strict Multi-Tenant Isolation</p>
              </div>
            </div>

            <div className="flex items-center gap-3 p-3 rounded-xl bg-slate-950/40 border border-slate-800/60">
              <GraduationCap className="h-5 w-5 text-blue-400 shrink-0" />
              <div>
                <p className="text-xs font-bold text-white">GPA Verification</p>
                <p className="text-[11px] text-slate-400">Automated Grade Ledger</p>
              </div>
            </div>

            <div className="flex items-center gap-3 p-3 rounded-xl bg-slate-950/40 border border-slate-800/60">
              <Cpu className="h-5 w-5 text-purple-400 shrink-0" />
              <div>
                <p className="text-xs font-bold text-white">Live Telemetry</p>
                <p className="text-[11px] text-slate-400">Sub-second Sync Across Campus</p>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* 4. COURSE & FEATURE SHOWCASE - 3D Circular Carousel */}
      <section id="showcase" className="relative w-full py-24 px-6 border-t border-slate-800/80 bg-slate-950">
        <div className="mx-auto max-w-7xl">
          <div className="text-center space-y-3 mb-10">
            <span className="text-xs font-extrabold uppercase tracking-widest text-indigo-400">
              Interactive 3D Curriculum Deck
            </span>
            <h2 className="text-3xl sm:text-5xl font-black text-white tracking-tight">
              Curated Academic Offerings
            </h2>
            <p className="mx-auto max-w-xl text-xs sm:text-sm text-slate-400">
              Swipe, drag, or click arrows to explore active syllabus offerings across Apex Institute & Horizon University.
            </p>
          </div>

          <div className="relative rounded-3xl border border-slate-800/80 bg-gradient-to-b from-slate-900/60 via-slate-900/40 to-slate-950/80 p-4 sm:p-8 backdrop-blur-xl shadow-2xl shadow-indigo-950/40 overflow-hidden">
            <CircularCarousel
              items={showcaseItems}
              radius={380}
              autoplay={true}
              speed={0.2}
            />
          </div>
        </div>
      </section>

      {/* Instant Role Switching Sandbox */}
      <section id="roles" className="relative w-full py-20 px-6 border-t border-slate-800/80 bg-gradient-to-b from-slate-950 to-slate-900">
        <div className="mx-auto max-w-5xl space-y-8">
          <div className="text-center space-y-3">
            <h3 className="text-2xl sm:text-4xl font-extrabold text-white tracking-tight">
              One Platform. Three Tailored Experiences.
            </h3>
            <p className="text-xs sm:text-sm text-slate-400">
              Click any persona to instantly test role-gated capabilities:
            </p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            {/* Admin Card */}
            <div className="rounded-2xl border border-slate-800 bg-slate-900/80 p-6 space-y-4 hover:border-blue-500/60 transition-all hover:-translate-y-1 shadow-lg">
              <div className="flex items-center justify-between">
                <span className="p-2.5 rounded-xl bg-blue-500/10 text-blue-400 border border-blue-500/20 font-bold text-xs">
                  ADMIN
                </span>
                <span className="text-xs text-slate-500">Apex Institute</span>
              </div>
              <h4 className="text-lg font-bold text-white">University Chancellor</h4>
              <p className="text-xs text-slate-400 leading-relaxed">
                Oversee campus-wide KPIs, faculty timetable schedules, college broadcasts, and institutional governance.
              </p>
              <Button
                onClick={() => loginAs("admin")}
                className="w-full bg-blue-600 hover:bg-blue-500 text-white font-semibold text-xs py-2 rounded-xl transition-all cursor-pointer"
              >
                Sign In as Admin →
              </Button>
            </div>

            {/* Faculty Card */}
            <div className="rounded-2xl border border-slate-800 bg-slate-900/80 p-6 space-y-4 hover:border-purple-500/60 transition-all hover:-translate-y-1 shadow-lg">
              <div className="flex items-center justify-between">
                <span className="p-2.5 rounded-xl bg-purple-500/10 text-purple-400 border border-purple-500/20 font-bold text-xs">
                  FACULTY
                </span>
                <span className="text-xs text-slate-500">Dr. Rajesh Nambiar</span>
              </div>
              <h4 className="text-lg font-bold text-white">Course Instructor</h4>
              <p className="text-xs text-slate-400 leading-relaxed">
                1-click batch attendance recording, exam assessment marks entry, lecture schedule, and syllabus distribution.
              </p>
              <Button
                onClick={() => loginAs("faculty")}
                className="w-full bg-purple-600 hover:bg-purple-500 text-white font-semibold text-xs py-2 rounded-xl transition-all cursor-pointer"
              >
                Sign In as Faculty →
              </Button>
            </div>

            {/* Student Card */}
            <div className="rounded-2xl border border-slate-800 bg-slate-900/80 p-6 space-y-4 hover:border-emerald-500/60 transition-all hover:-translate-y-1 shadow-lg">
              <div className="flex items-center justify-between">
                <span className="p-2.5 rounded-xl bg-emerald-500/10 text-emerald-400 border border-emerald-500/20 font-bold text-xs">
                  STUDENT
                </span>
                <span className="text-xs text-slate-500">Aarav Sharma</span>
              </div>
              <h4 className="text-lg font-bold text-white">Undergraduate Scholar</h4>
              <p className="text-xs text-slate-400 leading-relaxed">
                Attendance percentage health meter, warning alerts for the 75% rule, timetable, and GPA progress card.
              </p>
              <Button
                onClick={() => loginAs("student")}
                className="w-full bg-emerald-600 hover:bg-emerald-500 text-white font-semibold text-xs py-2 rounded-xl transition-all cursor-pointer"
              >
                Sign In as Student →
              </Button>
            </div>
          </div>
        </div>
      </section>

      {/* Footer */}
      <footer className="border-t border-slate-800/80 bg-slate-950 py-10 px-6 text-center text-xs text-slate-500">
        <div className="mx-auto max-w-7xl flex flex-col sm:flex-row items-center justify-between gap-4">
          <div className="flex items-center gap-2">
            <School className="h-4 w-4 text-indigo-400" />
            <span className="font-bold text-slate-300">EduNexa Systems</span>
            <span>• Multi-Tenant Academic Management Framework</span>
          </div>
          <div className="flex items-center gap-4 text-slate-400">
            <Link href="/break" className="hover:text-indigo-400 transition-colors">
              Student Break
            </Link>
            <Link href="/login" className="hover:text-indigo-400 transition-colors">
              Sign In
            </Link>
            <span>v2.4 (React Bits Integrated)</span>
          </div>
        </div>
      </footer>
    </div>
  );
}
