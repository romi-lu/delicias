"use client";
import React from "react";
import { motion } from "framer-motion";
import Button from "@/components/ui/Button";
import Badge from "@/components/ui/Badge";
import { formatPEN } from "@/utils/currency";
import getImageSrc from "@/utils/image";
import { ShoppingCart, Eye } from "lucide-react";

export type Producto = {
  id: number;
  nombre: string;
  descripcion?: string | null;
  precio: number;
  stock: number;
  destacado?: boolean;
  imagen?: string | null;
  categoria_id?: number;
  categoria_nombre?: string | null;
};

type Props = {
  producto: Producto;
  onAddToCart: (p: Producto) => void;
  isDisabled?: boolean;
};

export default function ProductCard({ producto, onAddToCart, isDisabled }: Props) {
  const agotado = (producto.stock ?? 0) <= 0;
  const lowStock = (producto.stock ?? 0) > 0 && (producto.stock ?? 0) <= 5;

  return (
    <motion.article
      className="card card-hover overflow-hidden group"
      initial={{ opacity: 0, y: 12 }}
      animate={{ opacity: 1, y: 0 }}
      whileHover={{ y: -4 }}
      transition={{ duration: 0.25, ease: [0.16, 1, 0.3, 1] }}
    >
      <div className="relative aspect-square overflow-hidden">
        <motion.img
          src={getImageSrc({ imagen: producto.imagen }, { width: 800 })}
          alt={producto.nombre}
          loading="lazy"
          className="w-full h-full object-cover transition-transform duration-500 group-hover:scale-105"
        />
        <div className="absolute top-3 left-3 flex flex-wrap items-center gap-2">
          {producto.destacado && (
            <Badge variant="accent" className="text-xs font-medium">
              Destacado
            </Badge>
          )}
          {lowStock && (
            <Badge variant="warning" className="text-xs">
              Quedan {producto.stock}
            </Badge>
          )}
          {agotado && (
            <Badge variant="danger" className="text-xs">
              Agotado
            </Badge>
          )}
        </div>
        {producto.categoria_nombre && (
          <div className="absolute top-3 right-3">
            <Badge className="bg-white/90 backdrop-blur-sm text-[var(--color-text-muted)] text-xs">
              {producto.categoria_nombre}
            </Badge>
          </div>
        )}
        <div
          className="pointer-events-none absolute inset-0 bg-gradient-to-t from-black/30 via-transparent to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300"
          aria-hidden
        />
      </div>

      <div className="p-4 sm:p-5">
        <div className="flex items-start justify-between gap-3 min-w-0">
          <h3 className="font-semibold text-lg leading-tight truncate text-[var(--color-text)]">
            {producto.nombre}
          </h3>
          <span className="text-[var(--color-secondary)] text-lg font-bold whitespace-nowrap">
            {formatPEN(Number(producto.precio || 0))}
          </span>
        </div>
        {producto.descripcion ? (
          <p
            className="text-sm text-[var(--color-text-muted)] mt-1 line-clamp-2"
            style={{
              display: "-webkit-box",
              WebkitLineClamp: 2,
              WebkitBoxOrient: "vertical",
              overflow: "hidden",
            }}
          >
            {producto.descripcion}
          </p>
        ) : null}

        <div className="mt-4 flex flex-wrap items-center gap-2">
          <motion.div
            whileTap={{ scale: 0.98 }}
            whileHover={{ scale: agotado || isDisabled ? 1 : 1.02 }}
            className="flex-1 min-w-[140px]"
          >
            <Button
              size="md"
              variant={agotado ? "ghost" : "primary"}
              disabled={agotado || isDisabled}
              aria-disabled={agotado || isDisabled}
              onClick={() => onAddToCart(producto)}
              className="w-full"
            >
              {agotado ? (
                "Agotado"
              ) : isDisabled ? (
                "Límite alcanzado"
              ) : (
                <span className="inline-flex items-center gap-2">
                  <ShoppingCart size={16} aria-hidden />
                  Agregar al carrito
                </span>
              )}
            </Button>
          </motion.div>
          <Button
            asChild
            size="md"
            variant="outline"
            className="hidden sm:inline-flex flex-1 min-w-[120px]"
          >
            <a
              href={`/product/${producto.id}`}
              aria-label={`Ver detalles de ${producto.nombre}`}
              className="inline-flex items-center gap-2 justify-center w-full"
            >
              <Eye size={16} aria-hidden />
              Ver detalle
            </a>
          </Button>
        </div>
      </div>
    </motion.article>
  );
}
