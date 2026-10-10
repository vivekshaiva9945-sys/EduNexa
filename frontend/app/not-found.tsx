"use client";

import React from "react";
import Link from "next/link";
import { Antigravity } from "@/components/animations/Antigravity";
import { Button } from "@/components/ui/button";
import { Home, Compass, ArrowLeft } from "lucide-react";

export default function NotFoundPage() {
  return (
    <div className="relative flex min-h-screen w-full flex-col items-center justify-center overflow-hidden bg-slate-950 p-6 text-white selection:bg-indigo-500 selection:text-white">
      {/* 5. INTERACTIVE 404 PLAYGROUND - Antigravity Background */}
      <div className="absolute inset-0 z-0">
        <Antigravity
          count={150}
          magnetRadius={160}
          ringRadius={55}
          particleSize={4.5}
          color="#38bdf8"
          secondaryColor="#ec4899"
          waveAmplitude={22}
          waveSpeed={0.035}
        />
        <div className="absolute inset-0 bg-gradient-to-t from-slate-950 via-slate-950/40 to-slate-950/80 pointer-events-none" />
      </div>

      {/* Glassmorphic 404 Container */}
      <div className="relative z-10 mx-auto max-w-lg rounded-3xl border border-slate-700/60 bg-slate-900/70 p-8 sm:p-12 text-center backdrop-blur-2xl shadow-2xl shadow-indigo-950/50 space-y-6">
        <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-indigo-500/10 border border-indigo-500/20 text-indigo-400 text-xs font-bold uppercase tracking-wider">
          <Compass className="w-3.5 h-3.5 animate-spin" /> Zero Gravity Zone
        </div>

        <div className="space-y-2">
          <h1 className="text-7xl sm:text-8xl font-black tracking-tight bg-gradient-to-r from-blue-400 via-indigo-200 to-pink-400 bg-clip-text text-transparent">
            404
          </h1>
          <h2 className="text-xl sm:text-2xl font-bold text-white">
            Course or Page Lost in Orbit
          </h2>
          <p className="text-xs sm:text-sm text-slate-300/90 leading-relaxed">
            The institutional resource you requested has drifted outside our tenant grid. Move your cursor to repel the zero-gravity orbital particles.
          </p>
        </div>

        <div className="flex flex-col sm:flex-row items-center justify-center gap-3 pt-2">
          <Link href="/" className="w-full sm:w-auto">
            <Button className="w-full sm:w-auto h-11 px-6 rounded-xl bg-gradient-to-r from-blue-600 to-indigo-600 hover:from-blue-500 hover:to-indigo-500 text-white font-bold text-xs shadow-lg shadow-indigo-600/30 hover:scale-105 transition-all cursor-pointer">
              <Home className="mr-1.5 h-4 w-4" /> Return to Campus Portal
            </Button>
          </Link>
          <Link href="/login" className="w-full sm:w-auto">
            <Button
              variant="outline"
              className="w-full sm:w-auto h-11 px-5 rounded-xl border-slate-700 bg-slate-800/80 hover:bg-slate-700 text-slate-200 text-xs font-semibold"
            >
              <ArrowLeft className="mr-1.5 h-3.5 w-3.5" /> Back to Sign In
            </Button>
          </Link>
        </div>

        <p className="text-[11px] text-slate-500 pt-2">
          Interactive physics powered by React Bits • EduNexa Motion Engine
        </p>
      </div>
    </div>
  );
}
