import React from "react";
import clsx from "clsx";

export type ButtonVariant =
  | "primary"
  | "secondary"
  | "outline"
  | "ghost"
  | "danger"
  | "success"
  | "warning"
  | "link"
  | "outline-primary"
  | "outline-secondary"
  | "outline-success"
  | "outline-danger";

export type ButtonSize = "sm" | "md";

type ButtonProps = React.ButtonHTMLAttributes<HTMLButtonElement> & {
  variant?: ButtonVariant;
  size?: ButtonSize;
};

const baseClasses =
  "inline-flex items-center justify-center gap-2 rounded-lg font-medium transition-all duration-150 focus:outline-none focus-visible:ring-2 focus-visible:ring-offset-2 disabled:opacity-50 disabled:pointer-events-none";

const sizeClasses: Record<ButtonSize, string> = {
  sm: "h-8 px-3 text-sm",
  md: "h-10 px-4 text-sm min-h-[44px]",
};

const variantClasses: Record<ButtonVariant, string> = {
  primary:
    "bg-[var(--admin-primary)] text-white hover:bg-[var(--admin-primary-hover)] focus-visible:ring-[var(--admin-primary)] shadow-sm hover:shadow-md",
  secondary:
    "bg-[var(--admin-surface-hover)] text-[var(--admin-text)] border border-[var(--admin-border)] hover:bg-[var(--admin-border)]",
  outline:
    "border border-[var(--admin-border)] text-[var(--admin-text)] hover:bg-[var(--admin-surface-hover)]",
  ghost:
    "border border-transparent text-[var(--admin-text)] hover:bg-[var(--admin-surface-hover)]",
  danger:
    "bg-[var(--admin-danger)] text-white hover:opacity-90 focus-visible:ring-[var(--admin-danger)]",
  success:
    "bg-[var(--admin-success)] text-white hover:opacity-90 focus-visible:ring-[var(--admin-success)]",
  warning:
    "bg-[var(--admin-warning)] text-white hover:opacity-90 focus-visible:ring-[var(--admin-warning)]",
  link: "bg-transparent text-[var(--admin-primary)] hover:underline px-0 py-0 h-auto focus-visible:ring-[var(--admin-primary)]",
  "outline-primary":
    "border-2 border-[var(--admin-primary)] text-[var(--admin-primary)] hover:bg-[var(--admin-primary)] hover:text-white focus-visible:ring-[var(--admin-primary)]",
  "outline-secondary":
    "border border-[var(--admin-border)] text-[var(--admin-text-muted)] hover:bg-[var(--admin-surface-hover)] hover:text-[var(--admin-text)]",
  "outline-success":
    "border border-[var(--admin-success)] text-[var(--admin-success)] hover:bg-[var(--admin-success-light)]",
  "outline-danger":
    "border border-[var(--admin-danger)] text-[var(--admin-danger)] hover:bg-[var(--admin-danger-light)]",
};

export function buttonClasses({
  variant = "primary",
  size = "md",
}: {
  variant?: ButtonVariant;
  size?: ButtonSize;
}) {
  return clsx(baseClasses, sizeClasses[size], variantClasses[variant]);
}

export default function Button({
  variant = "primary",
  size = "md",
  className = "",
  ...props
}: ButtonProps) {
  return (
    <button
      className={clsx(buttonClasses({ variant, size }), className)}
      {...props}
    />
  );
}
