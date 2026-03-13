"use client";

import React, { useState } from "react";
import Header from "./Header";
import Sidebar from "./Sidebar";
import { useAuth } from "@/context/AuthContext";

type ShellProps = {
  children: React.ReactNode;
  headerTitle?: string;
};

/**
 * Contenedor principal del Panel Admin Delicias.
 * Orquesta Header y Sidebar, define el área principal.
 * Layout responsivo: sidebar 256px en desktop, drawer en móvil.
 */
export default function Shell({ children, headerTitle }: ShellProps) {
  const [sidebarOpen, setSidebarOpen] = useState(false);
  const { user, logout } = useAuth();

  const handleLogout = () => {
    logout();
    if (typeof window !== "undefined") {
      window.location.href = "/login";
    }
  };

  return (
    <div className="min-h-screen bg-[var(--admin-bg-subtle)]">
      <Sidebar open={sidebarOpen} onClose={() => setSidebarOpen(false)} />
      <div className="md:pl-64 min-h-screen flex flex-col">
        <Header
          title={headerTitle || "Panel de Administración"}
          onToggleSidebar={() => setSidebarOpen(true)}
          onLogout={handleLogout}
          user={user}
        />
        <main className="container py-6 flex-1" role="main">
          <div className="min-h-[calc(100vh-8rem)]">{children}</div>
        </main>
      </div>
    </div>
  );
}
