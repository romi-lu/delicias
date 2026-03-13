"use client";
import React, { useState } from "react";
import { useRouter } from "next/navigation";
import { useAuth } from "@/context/AuthContext";
import { motion } from "framer-motion";
import Link from "next/link";
import { LogIn, Loader2 } from "lucide-react";

export default function LoginPage() {
  const router = useRouter();
  const { login } = useAuth();

  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const onSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);
    setLoading(true);
    const res = await login(email, password, false);
    setLoading(false);
    if (res.success) {
      router.push("/");
    } else {
      setError(res.error || "Error al iniciar sesión");
    }
  };

  return (
    <div className="min-h-[80vh] flex items-center justify-center px-4 py-12">
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.4 }}
        className="w-full max-w-md card p-6 sm:p-8 shadow-lg"
      >
        <h1 className="text-2xl sm:text-3xl font-bold text-[var(--color-secondary)] mb-2">
          Iniciar sesión
        </h1>
        <p className="text-[var(--color-text-muted)] text-sm mb-6">
          Accede a tu cuenta para realizar pedidos y ver tu historial.
        </p>

        {error && (
          <div
            className="mb-4 p-4 rounded-xl bg-[var(--color-error-bg)] text-[var(--color-error)] text-sm"
            role="alert"
          >
            {error}
          </div>
        )}

        <form onSubmit={onSubmit} className="space-y-4">
          <div>
            <label htmlFor="login-email" className="block text-sm font-medium text-[var(--color-text)] mb-1">
              Email
            </label>
            <input
              id="login-email"
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              required
              className="input-base"
              placeholder="tu@email.com"
              autoComplete="email"
            />
          </div>
          <div>
            <label htmlFor="login-password" className="block text-sm font-medium text-[var(--color-text)] mb-1">
              Contraseña
            </label>
            <input
              id="login-password"
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              required
              className="input-base"
              placeholder="••••••••"
              autoComplete="current-password"
            />
          </div>
          <motion.button
            type="submit"
            disabled={loading}
            className="btn btn-primary w-full inline-flex items-center justify-center gap-2"
            whileHover={{ scale: 1.01 }}
            whileTap={{ scale: 0.99 }}
          >
            {loading ? (
              <>
                <Loader2 size={18} className="animate-spin" aria-hidden />
                Ingresando...
              </>
            ) : (
              <>
                <LogIn size={18} aria-hidden />
                Ingresar
              </>
            )}
          </motion.button>
        </form>

        <p className="text-sm text-[var(--color-text-muted)] mt-6 text-center">
          ¿No tienes cuenta?{" "}
          <Link
            href="/register"
            className="font-semibold text-[var(--color-secondary)] hover:underline"
          >
            Regístrate
          </Link>
        </p>
      </motion.div>
    </div>
  );
}
