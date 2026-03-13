"use client";

import React from "react";
import Link from "next/link";
import { usePathname } from "next/navigation";
import {
  LayoutDashboard,
  FileText,
  ShoppingBag,
  Folder,
  Users,
  Settings,
  X,
  ClipboardList,
  BarChart3,
  Cake,
} from "lucide-react";
import { motion, AnimatePresence } from "framer-motion";

type SidebarProps = {
  open?: boolean;
  onClose?: () => void;
};

const navLinks = [
  { href: "/", label: "Dashboard", icon: LayoutDashboard },
  { href: "/comprobantes", label: "Comprobantes", icon: FileText },
  { href: "/reportes", label: "Reportes", icon: BarChart3 },
  { href: "/pedidos", label: "Pedidos", icon: ClipboardList },
  { href: "/productos", label: "Productos", icon: ShoppingBag },
  { href: "/categorias", label: "Categorías", icon: Folder },
  { href: "/usuarios", label: "Usuarios", icon: Users },
  { href: "/configuracion", label: "Configuración", icon: Settings },
];

/**
 * Sidebar Admin Delicias
 * - Estático en escritorio (izquierda)
 * - Cajón (drawer) en móviles con superposición
 * - Resalta el enlace activo
 * - Accesibilidad: aria-current, focus visible
 */
export default function Sidebar({ open = false, onClose }: SidebarProps) {
  const pathname = usePathname();

  const SidebarContent = (
    <div
      className="flex h-full w-64 flex-col bg-[var(--admin-surface)] border-r border-[var(--admin-border)]"
      role="navigation"
      aria-label="Navegación principal"
    >
      {/* Logo / Brand */}
      <div className="flex items-center justify-between px-4 py-4 border-b border-[var(--admin-border)]">
        <Link
          href="/"
          className="flex items-center gap-2.5 focus:outline-none focus-visible:ring-2 focus-visible:ring-[var(--admin-primary)] focus-visible:ring-offset-2 rounded-lg"
          aria-label="Ir al inicio"
        >
          <div className="flex h-10 w-10 items-center justify-center rounded-xl bg-gradient-to-br from-[var(--admin-primary)] to-[var(--admin-secondary)] text-white shadow-md">
            <Cake className="h-5 w-5" aria-hidden />
          </div>
          <div className="leading-tight">
            <div className="text-sm font-semibold text-[var(--admin-text)]">Delicias</div>
            <div className="text-xs text-[var(--admin-text-muted)]">Panel Admin</div>
          </div>
        </Link>
        {onClose && (
          <button
            type="button"
            aria-label="Cerrar menú"
            onClick={onClose}
            className="md:hidden inline-flex h-9 w-9 items-center justify-center rounded-lg text-[var(--admin-text-muted)] hover:bg-[var(--admin-surface-hover)] hover:text-[var(--admin-text)] transition-colors"
          >
            <X className="h-5 w-5" />
          </button>
        )}
      </div>

      {/* Navegación */}
      <nav className="mt-2 flex-1 overflow-y-auto px-2 py-3 space-y-0.5">
        {navLinks.map((link, i) => {
          const active =
            pathname === link.href || (link.href !== "/" && pathname.startsWith(link.href));
          const Icon = link.icon;
          return (
            <motion.div
              key={link.href}
              initial={{ opacity: 0, x: -8 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ delay: i * 0.03, duration: 0.2 }}
            >
              <Link
                href={link.href}
                aria-current={active ? "page" : undefined}
                className={`
                  flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm font-medium
                  transition-all duration-150
                  ${
                    active
                      ? "bg-[var(--admin-primary-light)] text-[var(--admin-primary)] border-l-2 border-[var(--admin-primary)]"
                      : "text-[var(--admin-text-muted)] hover:bg-[var(--admin-surface-hover)] hover:text-[var(--admin-text)]"
                  }
                  focus:outline-none focus-visible:ring-2 focus-visible:ring-[var(--admin-primary)] focus-visible:ring-offset-2
                `}
                onClick={onClose}
              >
                <Icon className="h-4 w-4 flex-shrink-0" aria-hidden />
                <span>{link.label}</span>
              </Link>
            </motion.div>
          );
        })}
      </nav>

      {/* Footer del sidebar */}
      <div className="px-4 py-3 border-t border-[var(--admin-border)]">
        <div className="text-xs text-[var(--admin-text-muted)]">
          © {new Date().getFullYear()} Delicias
        </div>
      </div>
    </div>
  );

  return (
    <>
      {/* Escritorio: sidebar fijo */}
      <aside
        className="hidden md:block fixed inset-y-0 left-0 z-30"
        aria-label="Barra lateral de navegación"
      >
        {SidebarContent}
      </aside>

      {/* Móvil: overlay + drawer */}
      <AnimatePresence>
        {open && (
          <motion.div
            className="md:hidden fixed inset-0 z-40"
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            transition={{ duration: 0.2 }}
          >
            <button
              type="button"
              aria-label="Cerrar menú"
              className="absolute inset-0 bg-black/50 backdrop-blur-sm"
              onClick={onClose}
            />
            <motion.div
              className="absolute inset-y-0 left-0 w-64 shadow-xl"
              initial={{ x: -280 }}
              animate={{ x: 0 }}
              exit={{ x: -280 }}
              transition={{ type: "spring", damping: 25, stiffness: 300 }}
            >
              {SidebarContent}
            </motion.div>
          </motion.div>
        )}
      </AnimatePresence>
    </>
  );
}
