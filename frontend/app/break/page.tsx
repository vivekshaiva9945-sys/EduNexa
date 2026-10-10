"use client";

import React, { useState } from "react";
import Link from "next/link";
import { Antigravity } from "@/components/animations/Antigravity";
import { DotField } from "@/components/animations/DotField";
import { Button } from "@/components/ui/button";
import { ArrowLeft, Sparkles, Sliders, RefreshCw } from "lucide-react";

export default function StudentBreakPlaygroundPage() {
  const [mode, setMode] = useState<"antigravity" | "dotfield">("antigravity");
  const [particleCount, setParticleCount] = useState(160);

  return (
    <div className="relative min-h-screen w-full overflow-hidden bg-slate-950 text-white selection:bg-indigo-500 selection:text-white">
      {/* Background Playground Canvas */}
      <div className="absolute inset-0 z-0">
        {mode === "antigravity" ? (
          <Antigravity
            count={particleCount}
            magnetRadius={160}
            ringRadius={55}
            particleSize={4.5}
            color="#38bdf8"
            secondaryColor="#ec4899"
            waveAmplitude={24}
            waveSpeed={0.035}
          />
        ) : (
          <DotField
            dotRadius={2.0}
            dotSpacing={16}
            cursorRadius={450}
            bulgeStrength={85}
            glowRadius={190}
            sparkle={true}
            waveAmplitude={2.2}
            gradientFrom="rgba(56, 189, 248, 0.45)"
            gradientTo="rgba(236, 72, 153, 0.4)"
          />
        )}
        <div className="absolute inset-0 bg-radial-gradient from-transparent via-slate-950/40 to-slate-950/80 pointer-events-none" />
      </div>

      {/* Header Bar */}
      <header className="relative z-10 flex items-center justify-between p-6 max-w-7xl mx-auto">
        <Link href="/" className="flex items-center gap-2 group">
          <Button
            variant="outline"
            size="sm"
            className="rounded-xl border-slate-700 bg-slate-900/80 hover:bg-slate-800 text-slate-300 text-xs flex items-center gap-1.5 shadow-sm"
          >
            <ArrowLeft className="w-3.5 h-3.5" /> Campus Home
          </Button>
        </Link>

        {/* Mode Selector */}
        <div className="flex items-center gap-1.5 p-1 rounded-2xl bg-slate-900/80 border border-slate-800 backdrop-blur-md shadow-lg">
          <button
            onClick={() => setMode("antigravity")}
            className={`px-3 py-1.5 rounded-xl text-xs font-bold transition-all ${
              mode === "antigravity"
                ? "bg-gradient-to-r from-blue-600 to-indigo-600 text-white shadow-md"
                : "text-slate-400 hover:text-slate-200"
            }`}
          >
            Antigravity Repulsion
          </button>
          <button
            onClick={() => setMode("dotfield")}
            className={`px-3 py-1.5 rounded-xl text-xs font-bold transition-all ${
              mode === "dotfield"
                ? "bg-gradient-to-r from-blue-600 to-indigo-600 text-white shadow-md"
                : "text-slate-400 hover:text-slate-200"
            }`}
          >
            Dot Field Bulge
          </button>
        </div>
      </header>

      {/* Floating HUD Card */}
      <div className="relative z-10 flex min-h-[75vh] items-center justify-center p-6 pointer-events-none">
        <div className="max-w-md w-full rounded-3xl border border-slate-700/60 bg-slate-900/70 p-8 backdrop-blur-2xl shadow-2xl text-center space-y-5 pointer-events-auto">
          <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-pink-500/10 border border-pink-500/20 text-pink-400 text-xs font-bold">
            <Sparkles className="w-3.5 h-3.5" /> Focus & De-Stress Zone
          </div>

          <h1 className="text-3xl font-black text-white tracking-tight">
            Student Physics Sandbox
          </h1>
          <p className="text-xs sm:text-sm text-slate-300 leading-relaxed">
            Take a 5-minute break between study modules. Move your cursor around the viewport to disrupt gravitational field equilibrium.
          </p>

          <div className="space-y-2 pt-2 border-t border-slate-800 text-left">
            <div className="flex items-center justify-between text-xs text-slate-400">
              <span className="flex items-center gap-1">
                <Sliders className="w-3.5 h-3.5" /> Particle Density
              </span>
              <span className="font-mono text-indigo-400">{particleCount} items</span>
            </div>
            <input
              type="range"
              min="60"
              max="240"
              step="20"
              value={particleCount}
              onChange={(e) => setParticleCount(Number(e.target.value))}
              className="w-full h-1.5 bg-slate-800 rounded-lg appearance-none cursor-pointer accent-indigo-500"
            />
          </div>

          <div className="flex items-center justify-center gap-3 pt-2">
            <Link href="/login">
              <Button size="sm" className="bg-indigo-600 hover:bg-indigo-500 text-white text-xs font-bold px-4 py-2 rounded-xl shadow-md cursor-pointer">
                Return to Class Portal →
              </Button>
            </Link>
          </div>
        </div>
      </div>
    </div>
  );
}
