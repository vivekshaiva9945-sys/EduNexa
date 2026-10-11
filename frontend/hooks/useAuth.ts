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
          // Initialize live connection with real admin authentication
          try {
            const authRes = await authApi.login("admin@apex.edunexa.edu", "Admin@123", "admin");
            if (authRes?.access_token) {
              const me = await authApi.getCurrentUser();
              if (isMounted && me) setUser(me);
            } else {
              if (isMounted) setUser(MOCK_USERS.admin);
            }
          } catch {
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

  const loginAs = async (role: "admin" | "faculty" | "student") => {
    setIsLoading(true);
    const mockUser = MOCK_USERS[role];
    try {
      const authRes = await authApi.login(mockUser.email, undefined, role);
      if (authRes?.access_token) {
        localStorage.setItem("edunexa_token", authRes.access_token);
        if (authRes.college_id) localStorage.setItem("edunexa_tenant_id", authRes.college_id);
        const currentUser = await authApi.getCurrentUser();
        if (currentUser) {
          setUser(currentUser);
          localStorage.setItem("edunexa_user", JSON.stringify(currentUser));
        } else {
          setUser(mockUser);
          localStorage.setItem("edunexa_user", JSON.stringify(mockUser));
        }
      } else {
        localStorage.setItem("edunexa_user", JSON.stringify(mockUser));
        setUser(mockUser);
      }
    } catch {
      localStorage.setItem("edunexa_token", `mock-jwt-token-${role}`);
      localStorage.setItem("edunexa_tenant_id", mockUser.college_id);
      localStorage.setItem("edunexa_user", JSON.stringify(mockUser));
      setUser(mockUser);
    } finally {
      setIsLoading(false);
    }

    if (role === "admin") router.push("/admin/dashboard");
    else if (role === "faculty") router.push("/faculty/dashboard");
    else router.push("/student/dashboard");
  };

  const logout = () => {
    localStorage.removeItem("edunexa_token");
    localStorage.removeItem("edunexa_user");
    localStorage.removeItem("edunexa_tenant_id");
    setUser(null);
    router.push("/login");
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
    loginAs,
    logout,
    switchTenant,
    isAuthenticated: !!user,
  };
}
