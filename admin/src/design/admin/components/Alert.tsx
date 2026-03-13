import React from "react";
import clsx from "clsx";

type Variant = "info" | "danger" | "warning" | "success";
type Size = "sm" | "md";

const base =
  "rounded-lg border p-3 text-sm shadow-sm";

const sizeMap: Record<Size, string> = {
  sm: "p-2 text-sm",
  md: "p-3 text-sm",
};

const variantMap: Record<Variant, string> = {
  info: "bg-[var(--admin-info-light)] border-[var(--admin-info)]/30 text-[var(--admin-info)]",
  danger:
    "bg-[var(--admin-danger-light)] border-[var(--admin-danger)]/30 text-[var(--admin-danger)]",
  warning:
    "bg-[var(--admin-warning-light)] border-[var(--admin-warning)]/30 text-[var(--admin-warning)]",
  success:
    "bg-[var(--admin-success-light)] border-[var(--admin-success)]/30 text-[var(--admin-success)]",
};

export function alertClasses({
  variant = "info",
  size = "md",
}: {
  variant?: Variant;
  size?: Size;
}) {
  return clsx(base, sizeMap[size], variantMap[variant]);
}

export interface AlertProps extends React.HTMLAttributes<HTMLDivElement> {
  variant?: Variant;
  size?: Size;
  title?: string;
  children?: React.ReactNode;
}

export default function Alert({
  variant = "info",
  size = "md",
  title,
  children,
  className = "",
  ...rest
}: AlertProps) {
  return (
    <div
      className={clsx(alertClasses({ variant, size }), className)}
      role="alert"
      {...rest}
    >
      {title ? (
        <div className="font-semibold mb-1 text-inherit">{title}</div>
      ) : null}
      {children ? (
        <div className="leading-relaxed text-inherit flex-1">{children}</div>
      ) : null}
    </div>
  );
}
