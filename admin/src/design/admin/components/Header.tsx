"use client";

import React, { useState, useRef, useEffect } from "react";
import { Menu, Search, Bell, Sun, Moon, ChevronDown, Settings, LogOut } from "lucide-react";
import { useTheme } from "next-themes";

type HeaderProps = {
  onToggleSidebar?: () => void;
  title?: string;
  onLogout?: () => void;
  user?: { nombre?: string; email?: string; rol?: string } | null;
};

/**
 * Admin Header (Topbar)
 * - Botón de menú (móvil)
 * - Título de sección
 * - Buscador global
 * - Acciones: tema, notificaciones, menú usuario
 * - Accesibilidad: aria-labels, focus trap en menú
 */
export default function Header({
  onToggleSidebar,
  title = "Dashboard",
  onLogout,
  user,
}: HeaderProps) {
  const { theme, setTheme } = useTheme();
  const [menuOpen, setMenuOpen] = useState(false);
  const menuRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const handleClickOutside = (e: MouseEvent) => {
      if (menuRef.current && !menuRef.current.contains(e.target as Node)) {
        setMenuOpen(false);
      }
    };
    document.addEventListener("mousedown", handleClickOutside);
    return () => document.removeEventListener("mousedown", handleClickOutside);
  }, []);

  const toggleTheme = () => {
    setTheme(theme === "dark" ? "light" : "dark");
  };

  const displayName = user?.nombre || user?.email || "Administrador";
  const initial = displayName.charAt(0).toUpperCase();

  return (
    <header
      className="sticky top-0 z-40 bg-[var(--admin-surface)]/95 backdrop-blur-md border-b border-[var(--admin-border)]"
      role="banner"
    >
      <div className="container flex h-14 items-center justify-between gap-3">
        {/* Izquierda: menú + título */}
        <div className="flex items-center gap-3">
          <button
            type="button"
            aria-label="Abrir menú de navegación"
            onClick={onToggleSidebar}
            className="md:hidden inline-flex h-10 w-10 items-center justify-center rounded-lg text-[var(--admin-text)] hover:bg-[var(--admin-surface-hover)] transition-colors"
          >
            <Menu className="h-5 w-5" aria-hidden />
          </button>
          <h1 className="text-sm sm:text-base font-semibold text-[var(--admin-text)] truncate">
            {title}
          </h1>
        </div>

        {/* Centro: buscador (oculto en móvil) */}
        <div className="hidden md:flex flex-1 max-w-md mx-4">
          <div className="relative w-full">
            <Search
              className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-[var(--admin-text-muted)]"
              aria-hidden
            />
            <input
              type="search"
              placeholder="Buscar en el panel…"
              aria-label="Buscar en el panel"
              className="w-full rounded-lg border border-[var(--admin-border)] bg-[var(--admin-bg)] pl-9 pr-3 py-2 text-sm text-[var(--admin-text)] placeholder:text-[var(--admin-text-muted)] focus:border-[var(--admin-primary)] focus:ring-2 focus:ring-[var(--admin-primary)]/20 transition-all"
            />
          </div>
        </div>

        {/* Derecha: acciones */}
        <div className="flex items-center gap-2">
          <button
            type="button"
            onClick={toggleTheme}
            className="inline-flex h-10 w-10 items-center justify-center rounded-lg text-[var(--admin-text-muted)] hover:bg-[var(--admin-surface-hover)] hover:text-[var(--admin-text)] transition-colors"
            aria-label={theme === "dark" ? "Cambiar a tema claro" : "Cambiar a tema oscuro"}
          >
            {theme === "dark" ? (
              <Sun className="h-5 w-5" aria-hidden />
            ) : (
              <Moon className="h-5 w-5" aria-hidden />
            )}
          </button>
          <button
            type="button"
            className="inline-flex h-10 w-10 items-center justify-center rounded-lg text-[var(--admin-text-muted)] hover:bg-[var(--admin-surface-hover)] hover:text-[var(--admin-text)] transition-colors relative"
            aria-label="Notificaciones"
          >
            <Bell className="h-5 w-5" aria-hidden />
          </button>

          {/* Menú usuario */}
          <div className="relative" ref={menuRef}>
            <button
              type="button"
              aria-haspopup="menu"
              aria-expanded={menuOpen}
              aria-controls="user-menu"
              id="user-menu-button"
              onClick={() => setMenuOpen((v) => !v)}
              className="inline-flex items-center gap-2 rounded-lg border border-[var(--admin-border)] bg-[var(--admin-surface)] px-2.5 py-2 text-sm hover:bg-[var(--admin-surface-hover)] transition-colors focus:outline-none focus-visible:ring-2 focus-visible:ring-[var(--admin-primary)]"
            >
              <div
                className="h-8 w-8 rounded-full bg-gradient-to-br from-[var(--admin-primary)] to-[var(--admin-secondary)] text-white flex items-center justify-center text-sm font-medium"
                aria-hidden
              >
                {initial}
              </div>
              <span className="hidden sm:inline text-[var(--admin-text)] max-w-[120px] truncate">
                {displayName}
              </span>
              <ChevronDown
                className={`h-4 w-4 text-[var(--admin-text-muted)] transition-transform ${menuOpen ? "rotate-180" : ""}`}
                aria-hidden
              />
            </button>

            {menuOpen && (
              <div
                id="user-menu"
                role="menu"
                aria-labelledby="user-menu-button"
                className="absolute right-0 mt-2 w-56 rounded-xl border border-[var(--admin-border)] bg-[var(--admin-surface)] shadow-lg py-1 animate-fade-in"
              >
                <a
                  href="/configuracion"
                  role="menuitem"
                  className="flex items-center gap-2 px-3 py-2.5 text-sm text-[var(--admin-text)] hover:bg-[var(--admin-surface-hover)] transition-colors"
                  onClick={() => setMenuOpen(false)}
                >
                  <Settings className="h-4 w-4" aria-hidden />
                  Configuración
                </a>
                <button
                  type="button"
                  role="menuitem"
                  onClick={() => {
                    onLogout?.();
                    setMenuOpen(false);
                  }}
                  className="flex items-center gap-2 w-full px-3 py-2.5 text-left text-sm text-[var(--admin-danger)] hover:bg-[var(--admin-danger-light)] dark:hover:bg-[var(--admin-danger-light-hover)] transition-colors"
                >
                  <LogOut className="h-4 w-4" aria-hidden />
                  Cerrar sesión
                </button>
              </div>
            )}
          </div>
        </div>
      </div>
    </header>
  );
}
