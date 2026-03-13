import React from "react";
import clsx from "clsx";

export default function StatusBadge({ active }: { active?: boolean }) {
  return (
    <span
      className={clsx(
        "inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium",
        active
          ? "bg-[var(--admin-success-light)] text-[var(--admin-success)]"
          : "bg-[var(--admin-surface-hover)] text-[var(--admin-text-muted)]"
      )}
      role="status"
      aria-label={active ? "Activo" : "Inactivo"}
    >
      {active ? "Activo" : "Inactivo"}
    </span>
  );
}
