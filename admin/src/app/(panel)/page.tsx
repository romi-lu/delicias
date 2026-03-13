"use client";

import { useEffect, useMemo, useState } from "react";
import axios from "axios";
import type { AxiosResponse } from "axios";
import { MetricCard, StatsGrid, Badge, Alert } from "@/design/admin";
import { formatPEN } from "@/utils/currency";
import { ResponsiveContainer, LineChart, Line, XAxis, YAxis, Tooltip, PieChart, Pie, Cell, Legend } from "recharts";
import { motion } from "framer-motion";
import { DollarSign, Package, Folder, Users } from "lucide-react";

type Comprobante = { tipo?: "boleta" | "factura"; total?: number; created_at?: string };

export default function AdminDashboardPage() {
  const [loading, setLoading] = useState(true);
  const [metrics, setMetrics] = useState({ productos: 0, categorias: 0, usuarios: 0, ventasSemana: 0 });
  const [comprobantes, setComprobantes] = useState<Comprobante[]>([]);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const loadMetrics = async () => {
      try {
        const [prodRes, catRes, usrRes, compRes] = await Promise.all([
          axios.get("/api/productos?pagina=1&limite=1"),
          axios.get("/api/categorias"),
          axios.get("/api/usuarios/admin/todos?pagina=1&limite=1"),
          axios.get("/api/facturacion/admin/comprobantes?pagina=1&limite=200"),
        ]);

        const getCount = (r: AxiosResponse<unknown>): number => {
          const data = r?.data as unknown;
          if (
            typeof data === "object" &&
            data !== null &&
            "pagination" in (data as Record<string, unknown>) &&
            typeof (data as { pagination?: { total?: unknown } }).pagination?.total !== "undefined"
          ) {
            return Number((data as { pagination?: { total?: unknown } }).pagination?.total ?? 0);
          }
          if (Array.isArray(data)) return data.length;
          if (typeof data === "object" && data !== null) {
            const o = data as Record<string, unknown>;
            if (typeof o.total !== "undefined") return Number(o.total as number);
            if (typeof o.count !== "undefined") return Number(o.count as number);
            if (typeof (o as { Count?: unknown }).Count !== "undefined") return Number((o as { Count?: unknown }).Count as number);
            if (Array.isArray(o.productos)) return o.productos.length;
            if (Array.isArray(o.usuarios)) return o.usuarios.length;
          }
          return 0;
        };

        const compDataRaw = Array.isArray((compRes.data as any)?.comprobantes)
          ? ((compRes.data as any).comprobantes as Comprobante[])
          : Array.isArray(compRes.data)
            ? (compRes.data as Comprobante[])
            : [];

        setMetrics({
          productos: getCount(prodRes),
          categorias: getCount(catRes),
          usuarios: getCount(usrRes),
          ventasSemana: compDataRaw
            .filter((c) => !!c.created_at)
            .filter((c) => {
              const d = new Date(String(c.created_at));
              const now = new Date();
              const diff = (now.getTime() - d.getTime()) / (1000 * 60 * 60 * 24);
              return diff <= 7;
            })
            .reduce((acc, c) => acc + Number(c.total || 0), 0),
        });
        setComprobantes(compDataRaw);
        setError(null);
      } catch (e: unknown) {
        const msg = axios.isAxiosError(e)
          ? (e.response?.data as { message?: string } | undefined)?.message || e.message
          : "No se pudieron cargar las métricas";
        setError(msg);
      } finally {
        setLoading(false);
      }
    };

    loadMetrics();
  }, []);

  // Ventas semanales: agrupar por día de la semana
  const ventasSemanalData = useMemo(() => {
    const nombres = ["Lun", "Mar", "Mié", "Jue", "Vie", "Sáb", "Dom"];
    const sums = new Array(7).fill(0) as number[];
    for (const c of comprobantes) {
      if (!c.created_at) continue;
      const d = new Date(String(c.created_at));
      const now = new Date();
      const diff = (now.getTime() - d.getTime()) / (1000 * 60 * 60 * 24);
      if (diff > 7) continue;
      // JS getDay(): 0=Dom,1=Lun,...6=Sab
      const dow = d.getDay();
      const idx = dow === 0 ? 6 : dow - 1; // convert to Lun..Dom indexing
      sums[idx] += Number(c.total || 0);
    }
    return nombres.map((name, i) => ({ name, ventas: Math.round(sums[i]) }));
  }, [comprobantes]);

  // Distribución de comprobantes por tipo (boleta/factura)
  const tipoDistribucion = useMemo(() => {
    const counts: Record<string, number> = { boleta: 0, factura: 0 };
    for (const c of comprobantes) {
      const t = String(c.tipo || "").toLowerCase();
      if (t === "boleta" || t === "factura") counts[t] += 1;
    }
    return [
      { name: "Boleta", value: counts.boleta },
      { name: "Factura", value: counts.factura },
    ];
  }, [comprobantes]);

  const COLORS = ["#10b981", "#f59e0b"];

  return (
    <motion.div
      initial={{ opacity: 0, y: 8 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.3, staggerChildren: 0.05 }}
    >
      <StatsGrid>
        <MetricCard
          label="Ventas (semanal)"
          value={formatPEN(metrics.ventasSemana)}
          icon={<DollarSign className="h-5 w-5" />}
        />
        <MetricCard
          label="Productos"
          value={metrics.productos}
          icon={<Package className="h-5 w-5" />}
        />
        <MetricCard
          label="Categorías"
          value={metrics.categorias}
          icon={<Folder className="h-5 w-5" />}
        />
        <MetricCard
          label="Usuarios"
          value={metrics.usuarios}
          icon={<Users className="h-5 w-5" />}
        />
      </StatsGrid>

      {error && <Alert variant="danger" className="mt-3">{error}</Alert>}
      {loading && <Alert variant="info" className="mt-3">Cargando métricas…</Alert>}

      {/* Gráfico de ventas semanales */}
      <motion.div
        initial={{ opacity: 0, y: 8 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.1 }}
        className="mt-6 rounded-xl border border-[var(--admin-border)] bg-[var(--admin-surface)] shadow-sm overflow-hidden"
      >
        <div className="p-5">
          <div className="mb-4 flex items-center justify-between">
            <strong className="text-[var(--admin-text)]">Visión general de ventas (7 días)</strong>
            <Badge variant="muted" size="sm">
              Semanal
            </Badge>
          </div>
          <div className="h-48">
            <ResponsiveContainer width="100%" height="100%">
              <LineChart data={ventasSemanalData} margin={{ top: 10, right: 20, bottom: 0, left: 0 }}>
                <XAxis
                  dataKey="name"
                  tick={{ fill: "#6b7280", fontSize: 12 }}
                  tickLine={false}
                  axisLine={{ stroke: "#e5e0d8" }}
                />
                <YAxis
                  tick={{ fill: "#6b7280", fontSize: 12 }}
                  tickLine={false}
                  axisLine={{ stroke: "#e5e0d8" }}
                />
                <Tooltip
                  wrapperStyle={{
                    borderRadius: 8,
                    border: "1px solid #e5e0d8",
                    backgroundColor: "#ffffff",
                  }}
                />
                <Line
                  type="monotone"
                  dataKey="ventas"
                  stroke="#b87333"
                  strokeWidth={2}
                  dot={{ r: 3, fill: "#b87333" }}
                />
              </LineChart>
            </ResponsiveContainer>
          </div>
        </div>
      </motion.div>

      {/* Distribución de comprobantes por tipo */}
      <motion.div
        initial={{ opacity: 0, y: 8 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.15 }}
        className="mt-6 rounded-xl border border-[var(--admin-border)] bg-[var(--admin-surface)] shadow-sm overflow-hidden"
      >
        <div className="p-5">
          <div className="mb-4 flex items-center justify-between">
            <strong className="text-[var(--admin-text)]">Comprobantes emitidos por tipo</strong>
            <Badge variant="muted" size="sm">
              Boleta vs Factura
            </Badge>
          </div>
          <div className="h-48">
            <ResponsiveContainer width="100%" height="100%">
              <PieChart>
                <Pie data={tipoDistribucion} dataKey="value" nameKey="name" cx="50%" cy="50%" outerRadius={80} label>
                  {tipoDistribucion.map((_, index) => (
                    <Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} />
                  ))}
                </Pie>
                <Legend />
                <Tooltip />
              </PieChart>
            </ResponsiveContainer>
          </div>
        </div>
      </motion.div>
    </motion.div>
  );
}

