"use client";

import React, { useEffect, useState } from "react";
import { usePathname } from "next/navigation";
import { useAuth } from "@/hooks/useAuth";
import { isSessionActive } from "@/lib/session";
import { ShieldAlert, Loader2 } from "lucide-react";

interface AuthGuardProps {
  children: React.ReactNode;
}

export function AuthGuard({ children }: AuthGuardProps) {
  const pathname = usePathname();
  const { user, isLoading, isAuthenticated } = useAuth();
  const [isVerifying, setIsVerifying] = useState(true);

  // 1. Prevent BFcache (Back-Forward Cache) Data Leakage
  // When user clicks browser Back button after logout, browsers restore DOM from bfcache.
  useEffect(() => {
    const handlePageShow = (event: PageTransitionEvent) => {
      // If page was retrieved from Back-Forward cache or navigation is back/forward
      const navEntry = performance.getEntriesByType("navigation")[0] as PerformanceNavigationTiming | undefined;
      const isBackForward = navEntry?.type === "back_forward";

      if (event.persisted || isBackForward) {
        if (!isSessionActive()) {
          // Session is destroyed -> Immediately hard redirect to login and replace history
          window.location.replace("/login");
        }
      }
    };

    const handlePopState = () => {
      if (!isSessionActive()) {
        window.location.replace("/login");
      }
    };

    window.addEventListener("pageshow", handlePageShow);
    window.addEventListener("popstate", handlePopState);

    return () => {
      window.removeEventListener("pageshow", handlePageShow);
      window.removeEventListener("popstate", handlePopState);
    };
  }, []);

  // 2. Synchronous & Asynchronous Route Protection
  useEffect(() => {
    // Instant synchronous cookie & storage pre-check
    if (!isSessionActive()) {
      setIsVerifying(true);
      window.location.replace("/login");
      return;
    }

    if (!isLoading) {
      if (!isAuthenticated || !user) {
        window.location.replace("/login");
        return;
      }

      // Role authorization verification
      const role = user.role.toUpperCase();
      if (pathname.startsWith("/admin") && role !== "ADMIN") {
        const dest = role === "FACULTY" ? "/faculty/dashboard" : "/student/dashboard";
        window.location.replace(dest);
        return;
      }

      if (pathname.startsWith("/faculty") && role === "STUDENT") {
        window.location.replace("/student/dashboard");
        return;
      }

      if (pathname.startsWith("/student") && role === "FACULTY") {
        window.location.replace("/faculty/dashboard");
        return;
      }

      setIsVerifying(false);
    }
  }, [pathname, isLoading, isAuthenticated, user]);

  // If session is missing or actively verifying, prevent mounting protected DOM
  if (isLoading || isVerifying || !user) {
    return (
      <div className="flex h-screen w-full items-center justify-center bg-slate-950 text-slate-100">
        <div className="flex flex-col items-center gap-4 text-center px-4">
          <div className="flex h-14 w-14 items-center justify-center rounded-2xl bg-indigo-500/10 border border-indigo-500/30 text-indigo-400 shadow-xl shadow-indigo-500/10 animate-pulse">
            <ShieldAlert className="h-7 w-7" />
          </div>
          <div>
            <h2 className="text-lg font-semibold tracking-tight text-white">Verifying Secure Session</h2>
            <p className="text-xs text-slate-400 mt-1 max-w-sm">
              Enforcing enterprise access controls and verifying institutional security tokens...
            </p>
          </div>
          <div className="flex items-center gap-2 text-xs text-indigo-400 font-mono mt-2">
            <Loader2 className="h-3.5 w-3.5 animate-spin" />
            <span>Establishing zero-trust perimeter</span>
          </div>
        </div>
      </div>
    );
  }

  return <>{children}</>;
}
