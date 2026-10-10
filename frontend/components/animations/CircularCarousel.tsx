"use client";

import React, {
  useCallback,
  useEffect,
  useLayoutEffect,
  useMemo,
  useRef,
  useState,
} from "react";

export interface CircularCarouselItem {
  src: string;
  alt?: string;
  title?: string;
  subtitle?: string;
  tag?: string;
  rating?: string;
}

export type CircularCarouselPreset = "cylinder" | "orbit" | "wheel" | "panorama";
export type CircularCarouselIntro = "assemble" | "rise" | "spin" | "none";
export type CircularCarouselAutoplay = "drift" | "step" | "off";

export interface CircularCarouselProps {
  items?: CircularCarouselItem[];
  preset?: CircularCarouselPreset;
  intro?: CircularCarouselIntro;
  cardWidth?: number;
  aspectRatio?: number;
  gap?: number;
  curve?: number;
  tilt?: number;
  perspective?: number;
  autoplay?: CircularCarouselAutoplay;
  speed?: number;
  interval?: number;
  direction?: "left" | "right";
  draggable?: boolean;
  momentum?: number;
  snap?: boolean;
  pauseOnHover?: boolean;
  focusOnClick?: boolean;
  parallax?: number;
  stretch?: number;
  depthFade?: number;
  fadeColor?: string;
  innerShade?: number;
  cornerRadius?: number;
  captions?: boolean;
  onChange?: (index: number) => void;
  onItemClick?: (item: CircularCarouselItem, index: number) => void;
  className?: string;
  style?: React.CSSProperties;
}

type Vec3 = [number, number, number];

interface Layout {
  axis: "x" | "y";
  tilt: number;
  perspective: number;
  curve: number;
  spread: number;
  inward: boolean;
  billboard: boolean;
  backfaces: boolean;
  window: number;
}

interface Tile {
  index: number;
  total: number;
  start: number;
  end: number;
  size: number;
  move: string;
}

interface Sample {
  time: number;
  angle: number;
}

interface Press {
  id: number;
  x: number;
  y: number;
  angle: number;
  moved: boolean;
  origin: number;
  samples: Sample[];
}

interface CarouselState {
  angle: number;
  velocity: number;
  target: number | null;
  dir: number;
  press: Press | null;
  drag: boolean;
  hover: boolean;
  pointer: { inside: boolean; x: number; y: number };
  yaw: number;
  pitch: number;
  intro: { type: CircularCarouselIntro; start: number } | null;
  introDone: boolean;
  holdUntil: number;
  stepAt: number;
  suppressClick: boolean;
  wheelTimer: ReturnType<typeof setTimeout> | undefined;
  fit: number;
  shift: number;
  drop: number;
  last: number;
}

interface Settings {
  count: number;
  step: number;
  radius: number;
  layout: Layout;
  axis: "x" | "y";
  tilt: number;
  perspective: number;
  cardW: number;
  cardH: number;
  intro: CircularCarouselIntro;
  autoplay: CircularCarouselAutoplay;
  speed: number;
  interval: number;
  draggable: boolean;
  momentum: number;
  snap: boolean;
  pauseOnHover: boolean;
  parallax: number;
  stretch: number;
  depthFade: number;
  captions: boolean;
  reduced: boolean;
}

interface IntroPose {
  radius: number;
  lift: number;
}

const PRESETS: Record<CircularCarouselPreset, Layout> = {
  cylinder: {
    axis: "y",
    tilt: -5,
    perspective: 2500,
    curve: 1,
    spread: 1,
    inward: false,
    billboard: false,
    backfaces: true,
    window: 0,
  },
  orbit: {
    axis: "y",
    tilt: -14,
    perspective: 1600,
    curve: 0,
    spread: 1.45,
    inward: false,
    billboard: true,
    backfaces: false,
    window: 0,
  },
  wheel: {
    axis: "x",
    tilt: 0,
    perspective: 1800,
    curve: 0,
    spread: 1,
    inward: false,
    billboard: false,
    backfaces: true,
    window: 1.7,
  },
  panorama: {
    axis: "y",
    tilt: 0,
    perspective: 0,
    curve: 1,
    spread: 1,
    inward: true,
    billboard: false,
    backfaces: false,
    window: 0,
  },
};

const INTRO_LENGTH: Record<CircularCarouselIntro, number> = {
  assemble: 1500,
  rise: 1400,
  spin: 1800,
  none: 0,
};
const TILES = 6;
const OVERLAP = 2;
const DRAG_THRESHOLD = 5;
const SPRING = 118;
const SETTLE_SPEED = 9;
const CAPTION_SPACE = 76;
const TO_RAD = Math.PI / 180;

const clamp = (value: number, min: number, max: number) =>
  Math.min(max, Math.max(min, value));
const wrap = (degrees: number) =>
  ((((degrees + 180) % 360) + 360) % 360) - 180;
const easeOut = (t: number) => 1 - Math.pow(1 - t, 4);
const easeOutQuint = (t: number) => 1 - Math.pow(1 - t, 5);

const rotateX = (p: Vec3, degrees: number): Vec3 => {
  const r = degrees * TO_RAD;
  const c = Math.cos(r);
  const s = Math.sin(r);
  return [p[0], p[1] * c - p[2] * s, p[1] * s + p[2] * c];
};

const rotateY = (p: Vec3, degrees: number): Vec3 => {
  const r = degrees * TO_RAD;
  const c = Math.cos(r);
  const s = Math.sin(r);
  return [p[0] * c + p[2] * s, p[1], -p[0] * s + p[2] * c];
};

export const CircularCarousel: React.FC<CircularCarouselProps> = ({
  items = [],
  preset = "cylinder",
  intro = "rise",
  cardWidth = 260,
  aspectRatio = 1.35,
  gap = 24,
  curve,
  tilt,
  perspective,
  autoplay = "drift",
  speed = 12,
  interval = 3,
  direction = "left",
  draggable = true,
  momentum = 0.6,
  snap = true,
  pauseOnHover = true,
  focusOnClick = true,
  parallax = 0.3,
  stretch = 0.5,
  depthFade = 0.45,
  fadeColor = "#020617",
  innerShade = 0.6,
  cornerRadius = 16,
  captions = true,
  onChange,
  onItemClick,
  className = "",
  style,
}) => {
  const count = items.length;
  const shape: CircularCarouselPreset = PRESETS[preset] ? preset : "cylinder";
  const layout = PRESETS[shape];
  const axis = layout.axis;
  const tiltValue = tilt ?? layout.tilt;
  const curveValue = layout.billboard ? 0 : clamp(curve ?? layout.curve, 0, 1);

  const cardW = Math.max(60, cardWidth);
  const cardH = cardW / clamp(aspectRatio, 0.2, 5);
  const along = axis === "x" ? cardH : cardW;
  const step = count > 0 ? 360 / count : 360;

  const radius = useMemo(() => {
    const n = Math.max(count, 3);
    const pitch = (along + gap) * layout.spread;
    const chord = pitch / (2 * Math.sin(Math.PI / n));
    const arc = (n * pitch) / (2 * Math.PI);
    return Math.max(chord + (arc - chord) * curveValue, along * 0.6);
  }, [count, along, gap, curveValue, layout.spread]);

  const tiles = useMemo<Tile[]>(() => {
    const total = curveValue > 0.001 ? TILES : 1;
    const length = along / total;
    const bend = curveValue > 0.001 ? radius / curveValue : 0;
    return Array.from({ length: total }, (_, index) => {
      const start = index * length - (index > 0 ? OVERLAP / 2 : 0);
      const end = (index + 1) * length + (index < total - 1 ? OVERLAP / 2 : 0);
      const center = (start + end) / 2 - along / 2;
      const alpha = bend ? center / bend : 0;
      const shift = bend ? bend * Math.sin(alpha) : center;
      const sink = bend ? bend * (1 - Math.cos(alpha)) : 0;
      const depth = layout.inward ? sink : -sink;
      const turn = ((layout.inward ? -alpha : alpha) * 180) / Math.PI;
      const move =
        axis === "x"
          ? `translate3d(0px, ${shift}px, ${depth}px) rotateX(${-turn}deg)`
          : `translate3d(${shift}px, 0px, ${depth}px) rotateY(${turn}deg)`;
      return { index, total, start, end, size: end - start, move };
    });
  }, [along, axis, curveValue, layout.inward, radius]);

  const rootRef = useRef<HTMLDivElement>(null);
  const stageRef = useRef<HTMLDivElement>(null);
  const cameraRef = useRef<HTMLDivElement>(null);
  const ringRef = useRef<HTMLDivElement>(null);
  const cardRefs = useRef<(HTMLDivElement | null)[]>([]);
  const wakeRef = useRef<() => void>(() => {});
  const measureRef = useRef<() => void>(() => {});
  const activeRef = useRef(0);
  const [active, setActive] = useState(0);
  const [ready, setReady] = useState(false);
  const [dragging, setDragging] = useState(false);

  const stateRef = useRef<CarouselState>({
    angle: 0,
    velocity: 0,
    target: null,
    dir: 1,
    press: null,
    drag: false,
    hover: false,
    pointer: { inside: false, x: 0, y: 0 },
    yaw: 0,
    pitch: 0,
    intro: null,
    introDone: false,
    holdUntil: 0,
    stepAt: 0,
    suppressClick: false,
    wheelTimer: undefined,
    fit: 1,
    shift: 0,
    drop: 0,
    last: 0,
  });

  const settings: Settings = {
    count,
    step,
    radius,
    layout,
    axis,
    tilt: tiltValue,
    perspective: layout.inward ? radius : (perspective ?? layout.perspective),
    cardW,
    cardH,
    intro: intro in INTRO_LENGTH ? intro : "rise",
    autoplay,
    speed,
    interval: Math.max(0.5, interval),
    draggable,
    momentum: clamp(momentum, 0, 1),
    snap,
    pauseOnHover,
    parallax: clamp(parallax, 0, 1),
    stretch: clamp(stretch, 0, 1),
    depthFade: clamp(depthFade, 0, 1),
    captions,
    reduced: false,
  };
  const settingsRef = useRef(settings);
  settingsRef.current = settings;

  const dragSign = layout.inward ? -1 : 1;
  const directionSign = (direction === "right" ? 1 : -1) * dragSign;

  useEffect(() => {
    stateRef.current.dir = directionSign;
    wakeRef.current();
  }, [directionSign]);

  useEffect(() => {
    setReady(true);
  }, []);

  useLayoutEffect(() => {
    const root = rootRef.current;
    const stage = stageRef.current;
    const camera = cameraRef.current;
    const ring = ringRef.current;
    if (!root || !stage || !camera || !ring) return undefined;
    const state = stateRef.current;
    let raf = 0;
    let visible = true;

    const nearest = (angle: number) =>
      Math.round(angle / settingsRef.current.step) * settingsRef.current.step;

    const measure = () => {
      const s = settingsRef.current;
      const rect = root.getBoundingClientRect();
      if (!rect.width || !rect.height) return;
      const room = s.captions ? CAPTION_SPACE : 0;
      const width = rect.width * 0.94;
      const height = (rect.height - room) * 0.92;
      const P = s.perspective;
      let minX = Infinity;
      let maxX = -Infinity;
      let minY = Infinity;
      let maxY = -Infinity;

      const corners: [number, number][] = [
        [-s.cardW / 2, -s.cardH / 2],
        [s.cardW / 2, -s.cardH / 2],
        [-s.cardW / 2, s.cardH / 2],
        [s.cardW / 2, s.cardH / 2],
      ];
      for (let a = -180; a <= 180; a += 15) {
        for (const [cx, cy] of corners) {
          let p: Vec3 = rotateX(rotateY([cx, cy, s.radius], a), s.tilt);
          p = [p[0], p[1], p[2] - s.radius];
          if (p[2] >= P * 0.95) continue;
          const k = P / (P - p[2]);
          minX = Math.min(minX, p[0] * k);
          maxX = Math.max(maxX, p[0] * k);
          minY = Math.min(minY, p[1] * k);
          maxY = Math.max(maxY, p[1] * k);
        }
      }

      const spanX = Math.max(maxX - minX, 1);
      const spanY = Math.max(maxY - minY, 1);
      const fit = Math.min(1, width / spanX, height / spanY);
      state.fit = fit;
      state.shift = -((minY + maxY) / 2) * fit - room / 2;
      state.drop = (rect.height / fit) * 0.55 + s.cardH;
      stage.style.perspective = `${P}px`;
      stage.style.transform = `translate3d(0, ${state.shift}px, 0) scale(${fit})`;
    };
    measureRef.current = measure;

    const introCard = (elapsed: number, landing: number): IntroPose => {
      if (!state.intro) return { radius: 1, lift: 0 };
      const type = state.intro.type;
      const reach = Math.abs(wrap(landing + state.angle));
      if (type === "rise") {
        const delay = (reach / 180) * 480;
        const p = easeOutQuint(clamp((elapsed - delay) / 900, 0, 1));
        return { radius: 1, lift: (1 - p) * state.drop };
      }
      return { radius: 1, lift: 0 };
    };

    const advance = (s: Settings, dt: number, now: number) => {
      if (!state.introDone) {
        if (!state.intro) {
          state.intro = { type: s.intro, start: now };
        }
        if (state.intro && now - state.intro.start >= INTRO_LENGTH[state.intro.type]) {
          state.intro = null;
          state.introDone = true;
        }
      }

      const paused =
        (s.pauseOnHover && state.hover) || state.drag || now < state.holdUntil;
      const cruise =
        s.autoplay === "drift" && !paused && !state.intro
          ? s.speed * state.dir
          : 0;
      let busy = Boolean(state.intro) || state.drag;

      if (state.drag || state.intro) {
        state.velocity = state.drag ? state.velocity : 0;
      } else if (state.target !== null) {
        let remaining = dt;
        const damping = 2 * Math.sqrt(SPRING);
        while (remaining > 0) {
          const h = Math.min(remaining, 1 / 240);
          const accel =
            SPRING * (state.target - state.angle) - damping * state.velocity;
          state.velocity += accel * h;
          state.angle += state.velocity * h;
          remaining -= h;
        }
        if (
          Math.abs(state.target - state.angle) < 0.004 &&
          Math.abs(state.velocity) < 0.03
        ) {
          state.angle = state.target;
          state.velocity = 0;
          state.target = null;
        }
        busy = true;
      } else {
        const tau = 0.18 + s.momentum * 1.5;
        state.velocity += (cruise - state.velocity) * (1 - Math.exp(-dt / tau));
        state.angle += state.velocity * dt;
        if (cruise === 0 && s.snap && Math.abs(state.velocity) < SETTLE_SPEED) {
          state.target = nearest(state.angle);
        }
        busy =
          busy ||
          cruise !== 0 ||
          Math.abs(state.velocity) > 0.01 ||
          state.target !== null;
      }

      return busy;
    };

    const render = (s: Settings, now: number) => {
      const elapsed = state.intro ? now - state.intro.start : 0;
      const angle = state.angle;
      const R = s.radius;

      camera.style.transform = `translate3d(0, 0, ${-R}px) rotateX(${s.tilt}deg)`;
      ring.style.transform = `rotateY(${angle}deg)`;

      for (let index = 0; index < s.count; index++) {
        const card = cardRefs.current[index];
        if (!card) continue;
        const base = index * s.step;
        const mod = introCard(elapsed, base);
        const r = R * mod.radius;
        let transform = `rotateY(${base}deg) translateZ(${r}px)`;
        if (mod.lift) transform += ` translateY(${mod.lift}px)`;
        card.style.transform = transform;
      }

      const index =
        ((Math.round(-state.angle / s.step) % s.count) + s.count) % s.count || 0;
      if (index !== activeRef.current) {
        activeRef.current = index;
        setActive(index);
        onChange?.(index);
      }
    };

    const frame = (now: number) => {
      raf = 0;
      const s = settingsRef.current;
      const dt = state.last ? Math.min((now - state.last) / 1000, 0.05) : 1 / 60;
      state.last = now;
      const busy = advance(s, dt, now);
      render(s, now);
      if (busy && visible && !document.hidden) raf = requestAnimationFrame(frame);
      else state.last = 0;
    };

    const wake = () => {
      if (!raf && visible && !document.hidden) raf = requestAnimationFrame(frame);
    };
    wakeRef.current = wake;

    const resizeObserver = new ResizeObserver(() => {
      measure();
      wake();
    });
    resizeObserver.observe(root);

    const io = new IntersectionObserver(([entry]) => {
      visible = entry.isIntersecting;
      if (visible) wake();
      else cancelAnimationFrame(raf);
    });
    io.observe(root);

    measure();
    wake();

    return () => {
      cancelAnimationFrame(raf);
      resizeObserver.disconnect();
      io.disconnect();
    };
  }, [items, preset, count]);

  const handlePointerDown = (e: React.PointerEvent<HTMLDivElement>) => {
    if (!draggable || e.button !== 0) return;
    stateRef.current.press = {
      id: e.pointerId,
      x: e.clientX,
      y: e.clientY,
      angle: stateRef.current.angle,
      moved: false,
      origin: 0,
      samples: [{ time: performance.now(), angle: stateRef.current.angle }],
    };
  };

  const handlePointerMove = (e: React.PointerEvent<HTMLDivElement>) => {
    const press = stateRef.current.press;
    if (!press || press.id !== e.pointerId) return;
    const delta = e.clientX - press.x;
    if (!press.moved) {
      if (Math.abs(delta) < DRAG_THRESHOLD) return;
      press.moved = true;
      press.origin = delta;
      stateRef.current.drag = true;
      stateRef.current.target = null;
      setDragging(true);
    }
    const perPixel = 180 / (Math.PI * radius * stateRef.current.fit);
    stateRef.current.angle = press.angle + (delta - press.origin) * perPixel;
    wakeRef.current();
  };

  const releasePointer = () => {
    if (stateRef.current.press) {
      stateRef.current.press = null;
      stateRef.current.drag = false;
      setDragging(false);
      wakeRef.current();
    }
  };

  const current = items[active] || items[0];

  return (
    <div
      ref={rootRef}
      className={`relative h-[380px] w-full select-none overflow-hidden touch-pan-y ${
        dragging ? "cursor-grabbing" : "cursor-grab"
      } ${className}`}
      onPointerDown={handlePointerDown}
      onPointerMove={handlePointerMove}
      onPointerUp={releasePointer}
      onPointerCancel={releasePointer}
      onPointerEnter={() => {
        stateRef.current.hover = true;
      }}
      onPointerLeave={() => {
        stateRef.current.hover = false;
        releasePointer();
      }}
    >
      <div
        ref={stageRef}
        className="absolute inset-0 flex items-center justify-center"
      >
        <div ref={cameraRef} className="relative h-0 w-0 [transform-style:preserve-3d]">
          <div ref={ringRef} className="absolute left-0 top-0 h-0 w-0 [transform-style:preserve-3d]">
            {items.map((item, index) => (
              <div
                key={index}
                ref={(el) => {
                  cardRefs.current[index] = el;
                }}
                className="absolute left-[-130px] top-[-90px] h-[180px] w-[260px] [transform-style:preserve-3d] rounded-2xl bg-slate-900/90 border border-slate-700/60 p-4 shadow-xl backdrop-blur-md overflow-hidden cursor-pointer hover:border-blue-500/80 transition-colors"
                onClick={() => onItemClick?.(item, index)}
              >
                {item.tag && (
                  <span className="inline-block px-2.5 py-0.5 rounded-full text-[10px] font-semibold bg-blue-500/20 text-blue-400 border border-blue-500/30 mb-2">
                    {item.tag}
                  </span>
                )}
                <h4 className="text-sm font-bold text-white line-clamp-1">
                  {item.title}
                </h4>
                <p className="text-xs text-slate-400 line-clamp-2 mt-1">
                  {item.subtitle}
                </p>
                {item.rating && (
                  <div className="mt-3 flex items-center justify-between text-xs text-slate-300">
                    <span className="text-amber-400 font-semibold">{item.rating}</span>
                    <span className="text-[11px] text-blue-400">Explore →</span>
                  </div>
                )}
              </div>
            ))}
          </div>
        </div>
      </div>

      {captions && current && (
        <div className="pointer-events-none absolute inset-x-0 bottom-3 flex flex-col items-center gap-1 text-center">
          <span className="text-xs font-semibold text-slate-300">
            {current.title} • {current.subtitle}
          </span>
          <span className="text-[11px] text-slate-500">
            Swipe or drag horizontally to rotate showcase ({active + 1}/{count})
          </span>
        </div>
      )}
    </div>
  );
};

export default CircularCarousel;
