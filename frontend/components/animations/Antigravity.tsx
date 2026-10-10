"use client";

import React, { useEffect, useRef, useState } from "react";

export interface AntigravityProps {
  count?: number;
  magnetRadius?: number;
  ringRadius?: number;
  waveSpeed?: number;
  waveAmplitude?: number;
  particleSize?: number;
  lerpSpeed?: number;
  color?: string;
  secondaryColor?: string;
  autoAnimate?: boolean;
  particleVariance?: number;
  rotationSpeed?: number;
  className?: string;
}

interface Particle {
  x: number;
  y: number;
  originX: number;
  originY: number;
  vx: number;
  vy: number;
  size: number;
  color: string;
  angle: number;
  speed: number;
  shape: "circle" | "capsule" | "square";
}

export const Antigravity: React.FC<AntigravityProps> = ({
  count = 140,
  magnetRadius = 140,
  ringRadius = 45,
  waveSpeed = 0.03,
  waveAmplitude = 25,
  particleSize = 4,
  lerpSpeed = 0.08,
  color = "#818cf8", // Electric Indigo
  secondaryColor = "#f472b6", // Neon Pink
  autoAnimate = true,
  particleVariance = 1.4,
  rotationSpeed = 0.015,
  className = "",
}) => {
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const mouseRef = useRef({ x: -9999, y: -9999, isHovering: false });
  const [stats, setStats] = useState({ count });

  useEffect(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const ctx = canvas.getContext("2d");
    if (!ctx) return;

    let animationFrameId: number;
    let width = (canvas.width = canvas.parentElement?.offsetWidth || window.innerWidth);
    let height = (canvas.height = canvas.parentElement?.offsetHeight || 600);
    const dpr = Math.min(window.devicePixelRatio || 1, 2);

    function resize() {
      if (!canvas?.parentElement) return;
      width = canvas.parentElement.offsetWidth;
      height = canvas.parentElement.offsetHeight;
      canvas.width = width * dpr;
      canvas.height = height * dpr;
      canvas.style.width = `${width}px`;
      canvas.style.height = `${height}px`;
      ctx!.setTransform(dpr, 0, 0, dpr, 0, 0);
    }

    resize();
    window.addEventListener("resize", resize);

    const particles: Particle[] = [];
    const shapes: ("circle" | "capsule" | "square")[] = ["circle", "capsule", "square"];

    for (let i = 0; i < count; i++) {
      const x = Math.random() * width;
      const y = Math.random() * height;
      particles.push({
        x,
        y,
        originX: x,
        originY: y,
        vx: (Math.random() - 0.5) * 0.8,
        vy: (Math.random() - 0.5) * 0.8,
        size: Math.random() * particleSize * particleVariance + 2,
        color: Math.random() > 0.4 ? color : secondaryColor,
        angle: Math.random() * Math.PI * 2,
        speed: (Math.random() * 0.5 + 0.5) * waveSpeed,
        shape: shapes[Math.floor(Math.random() * shapes.length)],
      });
    }

    const handleMouseMove = (e: MouseEvent) => {
      const rect = canvas.getBoundingClientRect();
      mouseRef.current.x = e.clientX - rect.left;
      mouseRef.current.y = e.clientY - rect.top;
      mouseRef.current.isHovering = true;
    };

    const handleMouseLeave = () => {
      mouseRef.current.isHovering = false;
      mouseRef.current.x = -9999;
      mouseRef.current.y = -9999;
    };

    window.addEventListener("mousemove", handleMouseMove, { passive: true });
    canvas.addEventListener("mouseleave", handleMouseLeave);

    let tick = 0;
    let isVisible = true;

    const observer = new IntersectionObserver(([entry]) => {
      isVisible = entry.isIntersecting;
      if (isVisible && !animationFrameId) {
        animationFrameId = requestAnimationFrame(render);
      }
    });
    observer.observe(canvas);

    function render() {
      if (!isVisible) {
        animationFrameId = 0 as any;
        return;
      }
      animationFrameId = requestAnimationFrame(render);
      tick++;

      ctx!.clearRect(0, 0, width, height);

      // Global subtle ambient field
      const mx = mouseRef.current.x;
      const my = mouseRef.current.y;

      for (let i = 0; i < particles.length; i++) {
        const p = particles[i];

        // Float wave motion
        p.angle += p.speed;
        const floatX = Math.cos(p.angle) * waveAmplitude * 0.4;
        const floatY = Math.sin(p.angle * 1.2) * waveAmplitude;

        let targetX = p.originX + floatX;
        let targetY = p.originY + floatY;

        // Anti-gravity repulsion from cursor
        const dx = targetX - mx;
        const dy = targetY - my;
        const dist = Math.sqrt(dx * dx + dy * dy);

        if (dist < magnetRadius) {
          const force = (1 - dist / magnetRadius) * 60;
          const angle = Math.atan2(dy, dx);
          targetX += Math.cos(angle) * (force + ringRadius);
          targetY += Math.sin(angle) * (force + ringRadius);
        }

        p.x += (targetX - p.x) * lerpSpeed;
        p.y += (targetY - p.y) * lerpSpeed;

        // Wrap around borders gently
        if (p.x < -20) p.x = width + 20;
        if (p.x > width + 20) p.x = -20;
        if (p.y < -20) p.y = height + 20;
        if (p.y > height + 20) p.y = -20;

        // Draw particle with glowing aura
        ctx!.save();
        ctx!.translate(p.x, p.y);
        ctx!.rotate(tick * rotationSpeed + p.angle);

        ctx!.fillStyle = p.color;
        ctx!.shadowColor = p.color;
        ctx!.shadowBlur = 12;

        if (p.shape === "circle") {
          ctx!.beginPath();
          ctx!.arc(0, 0, p.size, 0, Math.PI * 2);
          ctx!.fill();
        } else if (p.shape === "square") {
          ctx!.fillRect(-p.size, -p.size, p.size * 2, p.size * 2);
        } else {
          // Capsule
          ctx!.beginPath();
          ctx!.roundRect(-p.size * 0.8, -p.size * 1.6, p.size * 1.6, p.size * 3.2, p.size);
          ctx!.fill();
        }

        ctx!.restore();
      }
    }

    animationFrameId = requestAnimationFrame(render);

    return () => {
      cancelAnimationFrame(animationFrameId);
      observer.disconnect();
      window.removeEventListener("resize", resize);
      window.removeEventListener("mousemove", handleMouseMove);
      canvas.removeEventListener("mouseleave", handleMouseLeave);
    };
  }, [
    count,
    magnetRadius,
    ringRadius,
    waveSpeed,
    waveAmplitude,
    particleSize,
    lerpSpeed,
    color,
    secondaryColor,
    rotationSpeed,
  ]);

  return (
    <div className={`relative h-full w-full overflow-hidden ${className}`}>
      <canvas
        ref={canvasRef}
        className="absolute inset-0 h-full w-full pointer-events-none"
      />
    </div>
  );
};

export default Antigravity;
