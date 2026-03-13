import React from "react";
import clsx from "clsx";

type BadgeProps = {
  children: React.ReactNode;
  variant?: "muted" | "info" | "success" | "warning" | "danger" | "primary" | "secondary";
  size?: "sm" | "md";
  className?: string;
};

const base =
  "inline-flex items-center rounded-full font-medium transition-colors";

const sizeMap = {
  sm: "text-xs px-2 py-0.5",
  md: "text-sm px-2.5 py-1",
} as const;

const variantMap = {
  muted: "bg-[var(--admin-surface-hover)] text-[var(--admin-text-muted)]",
  info: "bg-[var(--admin-info-light)] text-[var(--admin-info)]",
  success: "bg-[var(--admin-success-light)] text-[var(--admin-success)]",
  warning: "bg-[var(--admin-warning-light)] text-[var(--admin-warning)]",
  danger: "bg-[var(--admin-danger-light)] text-[var(--admin-danger)]",
  primary:
    "bg-[var(--admin-primary)] text-white",
  secondary:
    "bg-[var(--admin-surface-hover)] text-[var(--admin-text)] border border-[var(--admin-border)]",
} as const;

export function badgeClasses({
  variant = "muted",
  size = "sm",
}: {
  variant?: BadgeProps["variant"];
  size?: BadgeProps["size"];
}) {
  return clsx(base, sizeMap[size ?? "sm"], variantMap[variant ?? "muted"]);
}

export default function Badge({
  children,
  variant = "muted",
  size = "sm",
  className = "",
}: BadgeProps) {
  return (
    <span
      className={clsx(badgeClasses({ variant, size }), className)}
      role="status"
    >
      {children}
    </span>
  );
}
