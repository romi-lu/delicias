"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { useAuth } from "@/context/AuthContext";
import { buttonClasses, Alert } from "@/design/admin";
import { Cake, Eye, EyeOff, Loader2 } from "lucide-react";
import { motion } from "framer-motion";

export default function AdminLoginPage() {
  const router = useRouter();
  const { login } = useAuth();

  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [showPassword, setShowPassword] = useState(false);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError(null);
    try {
      const result = await login(email, password, true);
      if (result.success) {
        router.push("/");
      } else {
        setError(result.error || "Error al iniciar sesión");
      }
    } catch (err: unknown) {
      const msg = err instanceof Error ? err.message : "Error al iniciar sesión";
      setError(msg);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-[var(--admin-bg-subtle)] px-4 py-8">
      {/* Fondo decorativo sutil */}
      <div
        className="fixed inset-0 -z-10 opacity-30"
        aria-hidden
        style={{
          backgroundImage: `radial-gradient(circle at 20% 80%, var(--admin-primary-light) 0%, transparent 50%),
            radial-gradient(circle at 80% 20%, var(--admin-accent-light) 0%, transparent 50%)`,
        }}
      />

      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.4, ease: "easeOut" }}
        className="w-full max-w-md"
      >
        <div className="rounded-2xl border-2 border-t-4 border-t-[var(--admin-primary)] border-[var(--admin-border)] bg-[var(--admin-surface)] shadow-xl overflow-hidden">
          <div className="p-8 sm:p-10">
            {/* Logo y título */}
            <div className="flex flex-col items-center text-center mb-8">
              <div className="flex h-16 w-16 items-center justify-center rounded-2xl bg-gradient-to-br from-[var(--admin-primary)] to-[var(--admin-secondary)] text-white shadow-lg mb-4">
                <Cake className="h-8 w-8" aria-hidden />
              </div>
              <h1 className="text-xl font-bold text-[var(--admin-text)]">
                Panel de Administración
              </h1>
              <p className="mt-1 text-sm text-[var(--admin-text-muted)]">
                Ingresa tus credenciales para acceder
              </p>
            </div>

            <form onSubmit={handleSubmit} className="space-y-5" noValidate>
              <div>
                <label
                  htmlFor="email"
                  className="block text-sm font-medium text-[var(--admin-text)] mb-1.5"
                >
                  Correo electrónico
                </label>
                <input
                  id="email"
                  type="email"
                  autoComplete="email"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  className="w-full rounded-lg border border-[var(--admin-border)] bg-[var(--admin-bg)] px-4 py-2.5 text-[var(--admin-text)] placeholder:text-[var(--admin-text-muted)] focus:border-[var(--admin-primary)] focus:ring-2 focus:ring-[var(--admin-primary)]/20 transition-all"
                  placeholder="admin@delicias.com"
                  required
                  aria-required="true"
                  aria-invalid={!!error}
                />
              </div>

              <div>
                <label
                  htmlFor="password"
                  className="block text-sm font-medium text-[var(--admin-text)] mb-1.5"
                >
                  Contraseña
                </label>
                <div className="relative">
                  <input
                    id="password"
                    type={showPassword ? "text" : "password"}
                    autoComplete="current-password"
                    value={password}
                    onChange={(e) => setPassword(e.target.value)}
                    className="w-full rounded-lg border border-[var(--admin-border)] bg-[var(--admin-bg)] px-4 py-2.5 pr-12 text-[var(--admin-text)] placeholder:text-[var(--admin-text-muted)] focus:border-[var(--admin-primary)] focus:ring-2 focus:ring-[var(--admin-primary)]/20 transition-all"
                    placeholder="••••••••"
                    required
                    aria-required="true"
                    aria-describedby={showPassword ? "password-visible" : undefined}
                  />
                  <button
                    type="button"
                    onClick={() => setShowPassword(!showPassword)}
                    className="absolute right-3 top-1/2 -translate-y-1/2 text-[var(--admin-text-muted)] hover:text-[var(--admin-text)] transition-colors p-1 rounded"
                    aria-label={showPassword ? "Ocultar contraseña" : "Mostrar contraseña"}
                    tabIndex={-1}
                  >
                    {showPassword ? (
                      <EyeOff className="h-4 w-4" aria-hidden />
                    ) : (
                      <Eye className="h-4 w-4" aria-hidden />
                    )}
                  </button>
                </div>
              </div>

              {error && (
                <Alert variant="danger" role="alert">
                  {error}
                </Alert>
              )}

              <button
                type="submit"
                disabled={loading}
                className={buttonClasses({
                  variant: "primary",
                  size: "md",
                })}
                style={{
                  width: "100%",
                  minHeight: "44px",
                }}
                aria-busy={loading}
              >
                {loading ? (
                  <>
                    <Loader2 className="h-4 w-4 animate-spin" aria-hidden />
                    Iniciando sesión…
                  </>
                ) : (
                  "Entrar"
                )}
              </button>
            </form>

            <p className="mt-6 text-center text-sm text-[var(--admin-text-muted)]">
              Acceso restringido a administradores autorizados
            </p>
          </div>
        </div>
      </motion.div>
    </div>
  );
}
