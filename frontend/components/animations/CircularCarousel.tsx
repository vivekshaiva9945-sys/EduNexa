"use client";

import React, { useCallback, useEffect, useRef, useState } from "react";
import { ChevronLeft, ChevronRight, BookOpen, Star, Sparkles } from "lucide-react";

export interface CircularCarouselItem {
  src: string;
  alt?: string;
  title: string;
  subtitle: string;
  tag?: string;
  rating?: string;
  code?: string;
  credits?: string;
}

export interface CircularCarouselProps {
  items: CircularCarouselItem[];
  radius?: number;
  speed?: number;
  autoplay?: boolean;
  onItemClick?: (item: CircularCarouselItem, index: number) => void;
  className?: string;
}

export const CircularCarousel: React.FC<CircularCarouselProps> = ({
  items = [],
  radius = 420,
  speed = 0.25,
  autoplay = true,
  onItemClick,
  className = "",
}) => {
  const [angle, setAngle] = useState(0);
  const [activeIndex, setActiveIndex] = useState(0);
  const [isDragging, setIsDragging] = useState(false);
  const [isHovered, setIsHovered] = useState(false);

  const angleRef = useRef(0);
  const targetAngleRef = useRef<number | null>(null);
  const velocityRef = useRef(0);
  const pressRef = useRef<{ startX: number; startAngle: number; moved: boolean } | null>(null);
  const rafRef = useRef<number | null>(null);
  const containerRef = useRef<HTMLDivElement>(null);

  const count = items.length;
  const step = count > 0 ? 360 / count : 72;

  // Sync state
  angleRef.current = angle;

  // Snap to specific index
  const rotateToIndex = useCallback(
    (index: number) => {
      const target = -index * step;
      let current = angleRef.current;
      // Find shortest angle distance
      const diff = ((((target - current) % 360) + 540) % 360) - 180;
      targetAngleRef.current = current + diff;
    },
    [step]
  );

  const handleNext = useCallback(() => {
    const nextIdx = (activeIndex + 1) % count;
    rotateToIndex(nextIdx);
  }, [activeIndex, count, rotateToIndex]);

  const handlePrev = useCallback(() => {
    const prevIdx = (activeIndex - 1 + count) % count;
    rotateToIndex(prevIdx);
  }, [activeIndex, count, rotateToIndex]);

  // Animation Loop with Spring Lerp
  useEffect(() => {
    let lastTime = performance.now();

    const loop = (time: number) => {
      const dt = Math.min((time - lastTime) / 1000, 0.05);
      lastTime = time;

      if (isDragging) {
        // Dragging handled in pointer events
      } else if (targetAngleRef.current !== null) {
        // Spring smoothly toward target
        const diff = targetAngleRef.current - angleRef.current;
        if (Math.abs(diff) < 0.1) {
          angleRef.current = targetAngleRef.current;
          targetAngleRef.current = null;
        } else {
          angleRef.current += diff * Math.min(dt * 8, 0.25);
        }
        setAngle(angleRef.current);
      } else if (autoplay && !isHovered) {
        // Subtle drift
        angleRef.current -= speed * dt * 20;
        setAngle(angleRef.current);
      }

      // Compute active front index
      const normalized = ((-angleRef.current % 360) + 360) % 360;
      const nearestIdx = Math.round(normalized / step) % count;
      setActiveIndex(nearestIdx);

      rafRef.current = requestAnimationFrame(loop);
    };

    rafRef.current = requestAnimationFrame(loop);

    return () => {
      if (rafRef.current) cancelAnimationFrame(rafRef.current);
    };
  }, [autoplay, isDragging, isHovered, speed, step, count]);

  // Pointer Drag Handlers
  const handlePointerDown = (e: React.PointerEvent) => {
    if (e.button !== 0) return;
    setIsDragging(true);
    targetAngleRef.current = null;
    pressRef.current = {
      startX: e.clientX,
      startAngle: angleRef.current,
      moved: false,
    };
    (e.currentTarget as HTMLElement).setPointerCapture(e.pointerId);
  };

  const handlePointerMove = (e: React.PointerEvent) => {
    if (!pressRef.current) return;
    const dx = e.clientX - pressRef.current.startX;
    if (Math.abs(dx) > 4) {
      pressRef.current.moved = true;
    }
    // Sensitivity factor
    const sensitivity = 0.35;
    const newAngle = pressRef.current.startAngle + dx * sensitivity;
    angleRef.current = newAngle;
    setAngle(newAngle);
  };

  const handlePointerUp = (e: React.PointerEvent) => {
    if (!pressRef.current) return;
    const moved = pressRef.current.moved;
    pressRef.current = null;
    setIsDragging(false);

    if (moved) {
      // Snap to nearest card
      const normalized = ((-angleRef.current % 360) + 360) % 360;
      const nearestIdx = Math.round(normalized / step) % count;
      rotateToIndex(nearestIdx);
    }
  };

  return (
    <div
      ref={containerRef}
      className={`relative w-full h-[540px] flex flex-col items-center justify-between select-none overflow-hidden ${className}`}
      onMouseEnter={() => setIsHovered(true)}
      onMouseLeave={() => setIsHovered(false)}
    >
      {/* 3D Cylindrical Stage */}
      <div
        className="relative w-full flex-1 flex items-center justify-center cursor-grab active:cursor-grabbing touch-pan-y"
        style={{ perspective: "1600px" }}
        onPointerDown={handlePointerDown}
        onPointerMove={handlePointerMove}
        onPointerUp={handlePointerUp}
        onPointerCancel={handlePointerUp}
      >
        <div
          className="relative w-0 h-0"
          style={{
            transformStyle: "preserve-3d",
            transform: "rotateX(-5deg)",
          }}
        >
          {items.map((item, index) => {
            const cardAngle = angle + index * step;
            const rad = (cardAngle * Math.PI) / 180;
            const cos = Math.cos(rad);
            const isFacingFront = cos > -0.15; // Hide back-facing cards to prevent clutter
            const isActive = index === activeIndex;

            // Opacity fades as cards curve into background
            const depthOpacity = Math.max(0.2, (cos + 1) / 2);
            const depthScale = isActive ? 1.05 : Math.max(0.85, 0.88 + cos * 0.12);

            return (
              <div
                key={index}
                className="absolute left-[-150px] top-[-200px] w-[300px] h-[400px] rounded-3xl overflow-hidden transition-all duration-150"
                style={{
                  transformStyle: "preserve-3d",
                  transform: `rotateY(${cardAngle}deg) translateZ(${radius}px) scale(${depthScale})`,
                  opacity: isFacingFront ? depthOpacity : 0,
                  visibility: isFacingFront ? "visible" : "hidden",
                  zIndex: Math.round((cos + 1) * 100),
                }}
                onClick={() => {
                  if (!pressRef.current?.moved) {
                    if (isActive) {
                      onItemClick?.(item, index);
                    } else {
                      rotateToIndex(index);
                    }
                  }
                }}
              >
                {/* Premium Course Card */}
                <div
                  className={`relative w-full h-full flex flex-col rounded-3xl border bg-slate-900/90 backdrop-blur-2xl shadow-2xl transition-all duration-300 ${
                    isActive
                      ? "border-indigo-500/80 shadow-indigo-500/25 ring-2 ring-indigo-500/40"
                      : "border-slate-800/80 hover:border-slate-700"
                  }`}
                >
                  {/* Card Cover Image Header */}
                  <div className="relative h-44 w-full overflow-hidden bg-slate-950">
                    <img
                      src={item.src}
                      alt={item.title}
                      className="h-full w-full object-cover transition-transform duration-500 hover:scale-105"
                      loading="lazy"
                    />
                    <div className="absolute inset-0 bg-gradient-to-t from-slate-900 via-transparent to-black/30" />

                    {/* Category Tag Badge */}
                    {item.tag && (
                      <span className="absolute top-3 left-3 px-2.5 py-1 rounded-full text-[10px] font-bold bg-slate-950/80 text-indigo-300 border border-indigo-500/30 backdrop-blur-md flex items-center gap-1 shadow-md">
                        <Sparkles className="w-2.5 h-2.5 text-pink-400" />
                        {item.tag}
                      </span>
                    )}

                    {/* Rating Pill */}
                    {item.rating && (
                      <span className="absolute top-3 right-3 px-2 py-0.5 rounded-full text-[10px] font-semibold bg-slate-950/80 text-amber-300 border border-amber-500/30 backdrop-blur-md flex items-center gap-1 shadow-md">
                        <Star className="w-3 h-3 fill-amber-400 text-amber-400" />
                        {item.rating}
                      </span>
                    )}
                  </div>

                  {/* Card Body */}
                  <div className="flex-1 p-5 flex flex-col justify-between space-y-3">
                    <div className="space-y-1.5">
                      <div className="flex items-center gap-2">
                        <span className="font-mono text-[11px] font-extrabold text-indigo-400 px-2 py-0.5 rounded bg-indigo-950/60 border border-indigo-800/40">
                          {item.code || `MOD-0${index + 1}`}
                        </span>
                        {item.credits && (
                          <span className="text-[10px] text-slate-400 font-medium">
                            {item.credits}
                          </span>
                        )}
                      </div>
                      <h3 className="text-base font-bold text-white leading-snug line-clamp-2">
                        {item.title}
                      </h3>
                      <p className="text-xs text-slate-400 line-clamp-2">
                        {item.subtitle}
                      </p>
                    </div>

                    {/* Bottom Action Footer */}
                    <div className="pt-2 border-t border-slate-800/80 flex items-center justify-between">
                      <span className="text-[11px] text-slate-400 flex items-center gap-1.5">
                        <BookOpen className="w-3.5 h-3.5 text-indigo-400" />
                        Syllabus & Roster
                      </span>
                      <span className="text-xs font-bold text-indigo-400 hover:text-indigo-300 transition-colors flex items-center gap-0.5 cursor-pointer">
                        View →
                      </span>
                    </div>
                  </div>
                </div>
              </div>
            );
          })}
        </div>
      </div>

      {/* Floating Navigation Arrows */}
      <button
        onClick={handlePrev}
        aria-label="Previous Course"
        className="absolute left-4 top-1/2 -translate-y-1/2 z-30 h-11 w-11 rounded-2xl bg-slate-900/80 hover:bg-slate-800 border border-slate-700/70 text-slate-200 hover:text-white flex items-center justify-center backdrop-blur-xl shadow-xl hover:scale-105 active:scale-95 transition-all cursor-pointer"
      >
        <ChevronLeft className="h-5 w-5" />
      </button>

      <button
        onClick={handleNext}
        aria-label="Next Course"
        className="absolute right-4 top-1/2 -translate-y-1/2 z-30 h-11 w-11 rounded-2xl bg-slate-900/80 hover:bg-slate-800 border border-slate-700/70 text-slate-200 hover:text-white flex items-center justify-center backdrop-blur-xl shadow-xl hover:scale-105 active:scale-95 transition-all cursor-pointer"
      >
        <ChevronRight className="h-5 w-5" />
      </button>

      {/* Bottom Pagination & Caption Controls */}
      <div className="z-20 flex flex-col items-center gap-3 pt-2 pb-3">
        {/* Pagination Indicator Dots */}
        <div className="flex items-center gap-2">
          {items.map((_, idx) => (
            <button
              key={idx}
              onClick={() => rotateToIndex(idx)}
              className={`h-2 rounded-full transition-all duration-300 cursor-pointer ${
                idx === activeIndex
                  ? "w-8 bg-indigo-500 shadow-md shadow-indigo-500/50"
                  : "w-2 bg-slate-700 hover:bg-slate-600"
              }`}
              aria-label={`Go to slide ${idx + 1}`}
            />
          ))}
        </div>

        {/* Current Active Caption */}
        <div className="text-center">
          <p className="text-xs font-bold text-slate-200">
            {items[activeIndex]?.title}
            <span className="text-slate-400 font-normal">
              {" "}
              — {items[activeIndex]?.subtitle}
            </span>
          </p>
          <p className="text-[11px] text-slate-500 mt-0.5">
            Drag horizontally or use arrows to rotate syllabus orbit ({activeIndex + 1}/{count})
          </p>
        </div>
      </div>
    </div>
  );
};

export default CircularCarousel;
