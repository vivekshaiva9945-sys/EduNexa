"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { authApi } from "@/lib/api";
import { MOCK_USERS, MockUser } from "@/lib/mockData";

export function useAuth() {
  const router = useRouter();
  const [user, setUser] = useState<MockUser | null>(null);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    let isMounted = true;

    const initializeAuth = async () => {
      try {
        const token = localStorage.getItem("edunexa_token");
        const stored = localStorage.getItem("edunexa_user");

        if (token && !token.startsWith("mock-") && stored) {
          try {
            const parsed = JSON.parse(stored);
            if (isMounted) setUser(parsed);
          } catch {
            // ignore parse error
          }
          // Verify with backend
          try {
            const me = await authApi.getCurrentUser();
            if (isMounted && me) setUser(me);
          } catch {
            // Keep parsed user
          }
        } else {
          // If stored user exists, keep it
          if (stored) {
            try {
              const parsed = JSON.parse(stored);
              if (isMounted) setUser(parsed);
            } catch {
              if (isMounted) setUser(MOCK_USERS.admin);
            }
          } else {
            if (isMounted) setUser(MOCK_USERS.admin);
          }
        }
      } catch {
        if (isMounted) setUser(MOCK_USERS.admin);
      } finally {
        if (isMounted) setIsLoading(false);
      }
    };

    initializeAuth();

    return () => {
      isMounted = false;
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
        localStorage.setItem("edunexa_token", authRes.access_token);
        if (authRes.college_id) localStorage.setItem("edunexa_tenant_id", authRes.college_id);

        let currentUser: MockUser | null = null;
        try {
          currentUser = await authApi.getCurrentUser();
        } catch {
          // fallback
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

        setUser(finalUser);
        localStorage.setItem("edunexa_user", JSON.stringify(finalUser));

        let targetPath = "/admin/dashboard";
        if (role === "FACULTY") targetPath = "/faculty/dashboard";
        else if (role === "STUDENT") targetPath = "/student/dashboard";

        if (typeof window !== "undefined") {
          window.location.href = targetPath;
        } else {
          router.push(targetPath);
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

  const logout = () => {
    localStorage.removeItem("edunexa_token");
    localStorage.removeItem("edunexa_user");
    localStorage.removeItem("edunexa_tenant_id");
    setUser(null);
    if (typeof window !== "undefined") {
      window.location.href = "/login";
    } else {
      router.push("/login");
    }
  };

  const switchTenant = (collegeName: string, domain: string) => {
    if (!user) return;
    const updatedUser: MockUser = {
      ...user,
      college_name: collegeName,
      college_domain: domain,
    };
    setUser(updatedUser);
    localStorage.setItem("edunexa_user", JSON.stringify(updatedUser));
  };

  return {
    user,
    isLoading,
    login,
    loginAs,
    logout,
    switchTenant,
    isAuthenticated: !!user,
  };
}
