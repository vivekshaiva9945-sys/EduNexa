"use client";

import React, { useState } from "react";
import { useAuth } from "@/hooks/useAuth";
import { AppSidebar } from "@/components/shared/AppSidebar";
import { HeaderBar } from "@/components/shared/HeaderBar";

export default function DashboardLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const { user, loginAs, logout, switchTenant } = useAuth();
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);

  return (
    <div className="flex h-screen w-full overflow-hidden bg-slate-50 dark:bg-slate-950 font-sans">
      {/* Desktop Sidebar */}
      <AppSidebar
        user={user}
        onLogout={logout}
        className="hidden md:flex"
      />

      {/* Mobile Drawer */}
      {mobileMenuOpen && (
        <div className="fixed inset-0 z-50 flex md:hidden">
          <div
            className="fixed inset-0 bg-black/60 backdrop-blur-xs"
            onClick={() => setMobileMenuOpen(false)}
          />
          <div className="relative z-10 w-64 bg-slate-900">
            <AppSidebar
              user={user}
              onLogout={logout}
              className="w-full h-full"
            />
          </div>
        </div>
      )}

      {/* Main View Area */}
      <div className="flex flex-1 flex-col overflow-hidden">
        <HeaderBar
          user={user}
          onSwitchRole={loginAs}
          onSwitchTenant={switchTenant}
          onToggleMobileMenu={() => setMobileMenuOpen((p) => !p)}
        />
        <main className="flex-1 overflow-y-auto p-4 md:p-8 bg-slate-50/70 dark:bg-slate-950">
          <div className="mx-auto max-w-7xl space-y-6">
            {children}
          </div>
        </main>
      </div>
    </div>
  );
}
