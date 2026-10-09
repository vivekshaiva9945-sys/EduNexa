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
    try {
      const stored = localStorage.getItem("edunexa_user");
      if (stored) {
        setUser(JSON.parse(stored));
      } else {
        setUser(MOCK_USERS.admin);
        localStorage.setItem("edunexa_user", JSON.stringify(MOCK_USERS.admin));
        localStorage.setItem("edunexa_tenant_id", MOCK_USERS.admin.college_id);
        localStorage.setItem("edunexa_token", "mock-jwt-token-admin");
      }
    } catch {
      setUser(MOCK_USERS.admin);
    } finally {
      setIsLoading(false);
    }
  }, []);

  const loginAs = async (role: "admin" | "faculty" | "student") => {
    setIsLoading(true);
    const mockUser = MOCK_USERS[role];
    try {
      const authRes = await authApi.login(mockUser.email, undefined, role);
      if (authRes?.access_token) {
        localStorage.setItem("edunexa_token", authRes.access_token);
        localStorage.setItem("edunexa_tenant_id", authRes.college_id);
      }
    } catch {
      localStorage.setItem("edunexa_token", `mock-jwt-token-${role}`);
      localStorage.setItem("edunexa_tenant_id", mockUser.college_id);
    }
    localStorage.setItem("edunexa_user", JSON.stringify(mockUser));
    setUser(mockUser);
    setIsLoading(false);

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
