"use client";

import React, { createContext, useContext, useEffect, useMemo, useState } from "react";
import axios from "axios";

// Configuración de axios:
// En el navegador, dejamos baseURL vacío para que las rutas relativas ("/api" y "/uploads")
// pasen por los rewrites de Next.js (ver next.config.ts) y así evitamos problemas de CORS.
// En SSR/build, usamos la variable de entorno con fallback al backend local.
const isBrowser = typeof window !== "undefined";
// Misma lógica que el frontend: SSR usa BACKEND_URL (Railway). No hace falta NEXT_PUBLIC_API_BASE_URL.
const serverApiBase = (process.env.BACKEND_URL || "http://localhost:6002").replace(/\/$/, "");
axios.defaults.baseURL = isBrowser ? "" : serverApiBase;

const AuthContext = createContext();

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error("useAuth debe ser usado dentro de un AuthProvider");
  }
  return context;
};

const readToken = () => {
  if (typeof window === "undefined") return null;
  // Compatibilidad: antes se usó admin_token en el admin separado.
  return localStorage.getItem("token") || localStorage.getItem("admin_token");
};

export const AuthProvider = ({ children }) => {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);
  const [token, setToken] = useState(readToken());

  // Debe aplicarse en render (no solo en useEffect): los efectos de hijos corren antes que los del
  // provider, y el dashboard hacía /api/usuarios/admin/* sin Bearer → 401 y "Unauthorized".
  if (typeof window !== "undefined") {
    if (token) {
      axios.defaults.headers.common["Authorization"] = `Bearer ${token}`;
    } else {
      delete axios.defaults.headers.common["Authorization"];
    }
  }

  const logout = () => {
    setToken(null);
    setUser(null);
    if (typeof window !== "undefined") {
      localStorage.removeItem("token");
      localStorage.removeItem("admin_token");
      // Eliminar cookie del token
      document.cookie = "token=; path=/; max-age=0";
    }
    delete axios.defaults.headers.common["Authorization"];
  };

  // Interceptor global para manejar 401/403 y forzar cierre de sesión seguro
  useEffect(() => {
    const resInterceptor = axios.interceptors.response.use(
      (response) => response,
      (error) => {
        const status = error?.response?.status;
        if (status === 401 || status === 403) {
          logout();
          if (typeof window !== "undefined") {
            window.location.href = "/login";
          }
        }
        return Promise.reject(error);
      },
    );

    return () => {
      axios.interceptors.response.eject(resInterceptor);
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [token]);

  // Verificar token al cargar la aplicación
  useEffect(() => {
    const verifyToken = async () => {
      if (token) {
        try {
          const response = await axios.get("/api/auth/verify");
          if (response.data?.tipo === "admin" && response.data.admin) {
            setUser({ ...response.data.admin, tipo: "admin", activo: true });
          } else {
            logout();
          }
        } catch (error) {
          logout();
        }
      }
      setLoading(false);
    };

    verifyToken();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [token]);

  const login = async (email, password, isAdmin = false) => {
    try {
      const endpoint = isAdmin ? "/api/auth/admin/login" : "/api/auth/login";
      const response = await axios.post(endpoint, { email, password });

      const { token: newToken } = response.data;
      const userData = isAdmin ? response.data.admin : response.data.user;
      const normalizedUser = isAdmin
        ? { ...userData, tipo: "admin", activo: true }
        : { ...userData, tipo: "usuario", activo: true };

      setToken(newToken);
      setUser(normalizedUser);

      if (typeof window !== "undefined") {
        localStorage.setItem("token", newToken);
        // Compatibilidad: mantener admin_token para el admin separado anterior
        localStorage.setItem("admin_token", newToken);
        const maxAgeDays = 7;
        document.cookie = `token=${newToken}; path=/; max-age=${60 * 60 * 24 * maxAgeDays}`;
      }

      return { success: true, user: normalizedUser };
    } catch (error) {
      const message =
        error.response?.data?.message ||
        error.response?.data?.mensaje ||
        "Error al iniciar sesión";
      return { success: false, error: message };
    }
  };

  const value = useMemo(
    () => ({
      user,
      token,
      loading,
      login,
      logout,
      isAuthenticated: () => !!user && !!token,
      isAdmin: () => user?.tipo === "admin" && user?.activo,
      isUser: () => user?.tipo === "usuario" && user?.activo,
      updateUser: (updatedUser) => setUser(updatedUser),
    }),
    [user, token, loading],
  );

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
};

