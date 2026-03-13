import React from "react";

type BadgeProps = React.HTMLAttributes<HTMLSpanElement> & {
  variant?: "default" | "success" | "warning" | "danger" | "accent" | "muted";
  size?: "sm" | "md";
};

const base = "inline-flex items-center rounded-full font-medium";
const sizeMap: Record<NonNullable<BadgeProps["size"]>, string> = {
  sm: "text-xs px-2.5 py-0.5",
  md: "text-sm px-3 py-0.5",
};

const variantMap: Record<NonNullable<BadgeProps["variant"]>, string> = {
  default: "bg-[var(--color-surface-muted)] text-[var(--color-text-muted)]",
  muted: "bg-[var(--color-neutral-200)] text-[var(--color-neutral-700)]",
  accent: "bg-[var(--color-primary)]/20 text-[var(--color-secondary)]",
  success: "bg-[var(--color-success-bg)] text-[var(--color-success)]",
  warning: "bg-[var(--color-warning-bg)] text-[var(--color-warning)]",
  danger: "bg-[var(--color-error-bg)] text-[var(--color-error)]",
};

export default function Badge({
  variant = "default",
  size = "sm",
  className = "",
  children,
  ...props
}: BadgeProps) {
  const classes = `${base} ${sizeMap[size]} ${variantMap[variant]} ${className}`.trim();
  return (
    <span {...props} className={classes}>
      {children}
    </span>
  );
}
