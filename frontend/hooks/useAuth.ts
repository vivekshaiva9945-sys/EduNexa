"use client";

import { useEffect, useState, useCallback } from "react";
import { useRouter } from "next/navigation";
import { authApi } from "@/lib/api";
import { MOCK_USERS, MockUser } from "@/lib/mockData";
import {
  setAuthSession,
  clearAuthSession,
  isSessionActive,
} from "@/lib/session";

export function useAuth() {
  const router = useRouter();
  const [user, setUser] = useState<MockUser | null>(null);
  const [isLoading, setIsLoading] = useState(true);

  // Synchronize state with actual session tokens and catch bfcache events
  useEffect(() => {
    let isMounted = true;

    const initializeAuth = async () => {
      try {
        if (!isSessionActive()) {
          if (isMounted) {
            setUser(null);
            setIsLoading(false);
          }
          return;
        }

        // Active session exists - load user metadata
        const stored = typeof window !== "undefined" ? localStorage.getItem("edunexa_user") : null;
        if (stored) {
          try {
            const parsed = JSON.parse(stored);
            if (isMounted) setUser(parsed);
          } catch {
            // Ignore parse error
          }
        }

        // Verify token validity with backend
        try {
          const remoteUser = await authApi.getCurrentUser();
          if (isMounted) {
            if (remoteUser) {
              setUser(remoteUser);
            } else if (!stored) {
              // Token invalid or revoked
              clearAuthSession();
              setUser(null);
            }
          }
        } catch {
          // If offline and stored user exists, keep stored user
        }
      } catch {
        if (isMounted) setUser(null);
      } finally {
        if (isMounted) setIsLoading(false);
      }
    };

    initializeAuth();

    // Listen to browser Back/Forward (bfcache) restorations
    const handlePageShow = (event: PageTransitionEvent) => {
      if (event.persisted || !isSessionActive()) {
        if (!isSessionActive()) {
          setUser(null);
          setIsLoading(false);
          if (typeof window !== "undefined" && !window.location.pathname.startsWith("/login")) {
            window.location.replace("/login");
          }
        }
      }
    };

    window.addEventListener("pageshow", handlePageShow);

    return () => {
      isMounted = false;
      window.removeEventListener("pageshow", handlePageShow);
    };
  }, []);

  const login = async (
    email: string,
    password?: string,
    tenantDomain?: string
  ): Promise<{ success: boolean; error?: string }> => {
    setIsLoading(true);
    try {
      const authRes = await authApi.login(email.trim(), password);
      if (authRes?.access_token) {
        let currentUser: MockUser | null = null;
        try {
          currentUser = await authApi.getCurrentUser();
        } catch {
          // Fallback
        }

        const role = (authRes.role || currentUser?.role || "ADMIN").toUpperCase();
        const finalUser: MockUser = currentUser || {
          user_id: authRes.user_id,
          college_id: authRes.college_id,
          college_name: tenantDomain?.includes("horizon") ? "Horizon University" : "Apex Institute of Technology",
          college_domain: tenantDomain || "apex.edunexa.edu",
          email: email.trim(),
          role: role as any,
          is_active: true,
          profile: {
            admin_id: role === "ADMIN" ? authRes.profile_id : undefined,
            faculty_id: role === "FACULTY" ? authRes.profile_id : undefined,
            student_id: role === "STUDENT" ? authRes.profile_id : undefined,
            first_name: role === "ADMIN" ? "Administrator" : role === "FACULTY" ? "Faculty Member" : "Student",
            last_name: "",
          },
        };

        // Store tokens across both Cookies (for Next.js middleware) and LocalStorage
        setAuthSession(authRes.access_token, finalUser);
        setUser(finalUser);

        let targetPath = "/admin/dashboard";
        if (role === "FACULTY") targetPath = "/faculty/dashboard";
        else if (role === "STUDENT") targetPath = "/student/dashboard";

        if (typeof window !== "undefined") {
          // Use replace to prevent back-button loops into login
          window.location.replace(targetPath);
        } else {
          router.replace(targetPath);
        }
        return { success: true };
      }
      return { success: false, error: "Authentication failed. Please check credentials." };
    } catch (err: any) {
      console.error("Login failed:", err);
      const detail = err?.response?.data?.detail || err?.message || "Invalid email or password";
      return { success: false, error: detail };
    } finally {
      setIsLoading(false);
    }
  };

  const loginAs = async (role: "admin" | "faculty" | "student") => {
    const mockUser = MOCK_USERS[role];
    const pwd = role === "admin" ? "Admin@123" : role === "faculty" ? "Faculty@123" : "Student@123";
    return login(mockUser.email, pwd, mockUser.college_domain);
  };

  const logout = useCallback(async () => {
    // 1. Immediately revoke token on backend server
    try {
      await authApi.logout();
    } catch {
      // Swallowed: client teardown must always succeed
    }

    // 2. Completely destroy client-side credentials
    clearAuthSession();
    setUser(null);

    // 3. Force hard navigation to login and replace history entry
    // Replacing current history entry ensures the browser's Back button cannot navigate to this dashboard
    if (typeof window !== "undefined") {
      window.location.replace("/login");
    } else {
      router.replace("/login");
    }
  }, [router]);

  const switchTenant = (collegeName: string, domain: string) => {
    if (!user) return;
    const updatedUser: MockUser = {
      ...user,
      college_name: collegeName,
      college_domain: domain,
    };
    setUser(updatedUser);
    if (typeof window !== "undefined") {
      localStorage.setItem("edunexa_user", JSON.stringify(updatedUser));
    }
  };

  return {
    user,
    isLoading,
    login,
    loginAs,
    logout,
    switchTenant,
    isAuthenticated: !!user && isSessionActive(),
  };
}
