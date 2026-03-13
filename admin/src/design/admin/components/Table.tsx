import React from "react";
import clsx from "clsx";

export function Table({
  children,
  className = "",
}: {
  children: React.ReactNode;
  className?: string;
}) {
  return (
    <div
      className={clsx(
        "overflow-x-auto rounded-xl border border-[var(--admin-border)] bg-[var(--admin-surface)] shadow-sm",
        className
      )}
      role="region"
      aria-label="Tabla de datos"
    >
      <table className="min-w-full divide-y divide-[var(--admin-border)]">
        {children}
      </table>
    </div>
  );
}

export function THead({ children }: { children: React.ReactNode }) {
  return (
    <thead className="bg-[var(--admin-surface-hover)]">
      {children}
    </thead>
  );
}

export function Th({ children }: { children: React.ReactNode }) {
  return (
    <th
      scope="col"
      className="px-4 py-3 text-left text-xs font-semibold uppercase tracking-wider text-[var(--admin-text-muted)]"
    >
      {children}
    </th>
  );
}

export function TBody({ children }: { children: React.ReactNode }) {
  return (
    <tbody className="divide-y divide-[var(--admin-border)] bg-[var(--admin-surface)]">
      {children}
    </tbody>
  );
}

export function Tr({ children }: { children: React.ReactNode }) {
  return (
    <tr className="hover:bg-[var(--admin-surface-hover)]/50 transition-colors">
      {children}
    </tr>
  );
}

export function Td({
  children,
  className = "",
  colSpan,
}: {
  children: React.ReactNode;
  className?: string;
  colSpan?: number;
}) {
  return (
    <td
      className={clsx(
        "px-4 py-3 text-sm text-[var(--admin-text)]",
        className
      )}
      colSpan={colSpan}
    >
      {children}
    </td>
  );
}
