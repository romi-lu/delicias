import React from "react";
import clsx from "clsx";
import { motion } from "framer-motion";

type MetricCardProps = {
  label: React.ReactNode;
  value: React.ReactNode;
  className?: string;
  icon?: React.ReactNode;
};

export default function MetricCard({
  label,
  value,
  className = "",
  icon,
}: MetricCardProps) {
  return (
    <motion.div
      initial={{ opacity: 0, y: 8 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.25 }}
      className={clsx(
        "rounded-xl border border-[var(--admin-border)] bg-[var(--admin-surface)] shadow-sm p-4 hover:shadow-md transition-shadow",
        className
      )}
    >
      <div className="flex flex-col gap-1">
        {icon && (
          <div className="mb-1 text-[var(--admin-primary)]" aria-hidden>
            {icon}
          </div>
        )}
        <div className="text-xs font-medium text-[var(--admin-text-muted)] uppercase tracking-wide">
          {label}
        </div>
        <div className="text-2xl font-bold text-[var(--admin-text)]">{value}</div>
      </div>
    </motion.div>
  );
}

export function StatsGrid({
  children,
  className = "",
}: {
  children: React.ReactNode;
  className?: string;
}) {
  return (
    <div
      className={clsx(
        "grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4",
        className
      )}
    >
      {children}
    </div>
  );
}
