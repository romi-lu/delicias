"use client";
import React from "react";
import Link from "next/link";
import Image from "next/image";
import { useCart } from "@/context/CartContext";
import { AnimatePresence, motion } from "framer-motion";
import { X, Trash2, Minus, Plus, ShoppingCart, CreditCard } from "lucide-react";
import getImageSrc from "@/utils/image";
import { toast } from "react-hot-toast";

export default function CartSidebar() {
  const {
    cartItems,
    isOpen,
    closeCart,
    clearCart,
    updateQuantity,
    removeFromCart,
    getCartTotal,
  } = useCart();
  type CartItem = {
    id: number;
    nombre: string;
    precio: number | string;
    cantidad: number;
    stock: number;
    imagen?: string | null;
  };
  const cartItemsTyped = cartItems as CartItem[];

  const formatPrice = (price: number) =>
    new Intl.NumberFormat("es-PE", { style: "currency", currency: "PEN" }).format(price);

  return (
    <>
      <AnimatePresence>
        {isOpen && (
          <motion.div
            className="fixed inset-0 bg-black/50 backdrop-blur-sm z-40"
            onClick={closeCart}
            aria-hidden="true"
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            transition={{ duration: 0.2 }}
          />
        )}
      </AnimatePresence>

      <AnimatePresence>
        {isOpen && (
          <motion.aside
            className="fixed top-0 right-0 h-full w-full sm:w-[400px] md:w-[420px] xl:w-[440px] bg-[var(--color-surface)] shadow-xl z-50 flex flex-col"
            role="dialog"
            aria-modal="true"
            aria-label="Carrito de compras"
            onClick={(e) => e.stopPropagation()}
            initial={{ x: "100%" }}
            animate={{ x: 0 }}
            exit={{ x: "100%" }}
            transition={{ type: "tween", ease: [0.16, 1, 0.3, 1], duration: 0.3 }}
          >
            <div className="flex items-center justify-between px-5 py-4 border-b border-[var(--color-border)]">
              <div className="flex items-center gap-3">
                <h2 className="text-lg font-bold text-[var(--color-text)] inline-flex items-center gap-2">
                  <ShoppingCart size={20} aria-hidden />
                  Tu Carrito
                </h2>
                <span className="inline-flex items-center px-2.5 py-0.5 text-xs rounded-full bg-[var(--color-primary)]/15 text-[var(--color-secondary)] font-medium">
                  {cartItemsTyped.length}{" "}
                  {cartItemsTyped.length === 1 ? "producto" : "productos"}
                </span>
              </div>
              <motion.button
                type="button"
                className="p-2.5 rounded-xl hover:bg-[var(--color-surface-muted)] text-[var(--color-text-muted)] hover:text-[var(--color-text)] transition-colors"
                onClick={closeCart}
                aria-label="Cerrar carrito"
                whileTap={{ scale: 0.95 }}
              >
                <X size={20} />
              </motion.button>
            </div>

            <div className="flex-1 overflow-y-auto px-5 py-4">
              {cartItems.length === 0 ? (
                <div className="text-center py-12">
                  <div className="w-16 h-16 mx-auto mb-4 rounded-2xl bg-[var(--color-surface-muted)] flex items-center justify-center">
                    <ShoppingCart size={32} className="text-[var(--color-text-muted)]" aria-hidden />
                  </div>
                  <p className="text-[var(--color-text-muted)]">Tu carrito está vacío.</p>
                  <Link href="/products" className="btn btn-primary mt-4 inline-flex">
                    Ir a productos
                  </Link>
                </div>
              ) : (
                <ul className="space-y-4" role="list">
                  <AnimatePresence initial={false}>
                    {cartItemsTyped.map((item) => (
                      <motion.li
                        key={item.id}
                        className="flex gap-4 p-4 rounded-xl border border-[var(--color-border)] bg-[var(--color-surface-muted)]/50"
                        initial={{ opacity: 0, y: 8 }}
                        animate={{ opacity: 1, y: 0 }}
                        exit={{ opacity: 0, x: -20 }}
                        transition={{ duration: 0.2 }}
                      >
                        <Image
                          src={getImageSrc({ imagen: item.imagen }, { width: 160 })}
                          alt={item.nombre}
                          width={72}
                          height={72}
                          className="w-[72px] h-[72px] rounded-xl object-cover border border-[var(--color-border)] shrink-0"
                        />
                        <div className="flex-1 min-w-0">
                          <div className="flex items-start justify-between gap-2">
                            <div>
                              <p className="font-semibold text-[var(--color-text)] truncate">
                                {item.nombre}
                              </p>
                              <p className="text-sm text-[var(--color-text-muted)]">
                                {formatPrice(parseFloat(String(item.precio)))}
                              </p>
                            </div>
                            <motion.button
                              type="button"
                              className="inline-flex items-center gap-1.5 text-sm text-[var(--color-error)] hover:text-red-700 shrink-0"
                              onClick={() => {
                                removeFromCart(item.id);
                                toast.success("Producto eliminado del carrito");
                              }}
                              whileTap={{ scale: 0.97 }}
                              aria-label={`Eliminar ${item.nombre} del carrito`}
                            >
                              <Trash2 size={16} />
                              Eliminar
                            </motion.button>
                          </div>
                          <div className="mt-3 flex items-center gap-2">
                            <motion.button
                              type="button"
                              className="p-2 rounded-lg border border-[var(--color-border)] bg-[var(--color-surface)] hover:bg-[var(--color-surface-muted)] transition-colors disabled:opacity-50"
                              onClick={() =>
                                updateQuantity(item.id, Math.max(1, item.cantidad - 1))
                              }
                              disabled={item.cantidad <= 1}
                              aria-label="Disminuir cantidad"
                              whileTap={{ scale: 0.95 }}
                            >
                              <Minus size={16} />
                            </motion.button>
                            <input
                              type="number"
                              className="w-14 text-center rounded-lg border border-[var(--color-border)] bg-[var(--color-surface)] px-2 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-[var(--color-primary)]/40"
                              value={item.cantidad}
                              min={1}
                              max={item.stock}
                              onChange={(e) => {
                                const nueva = parseInt(e.target.value || "1", 10);
                                if (!Number.isNaN(nueva)) {
                                  updateQuantity(
                                    item.id,
                                    Math.min(item.stock, Math.max(1, nueva))
                                  );
                                }
                              }}
                              aria-label={`Cantidad de ${item.nombre}`}
                            />
                            <motion.button
                              type="button"
                              className="p-2 rounded-lg border border-[var(--color-border)] bg-[var(--color-surface)] hover:bg-[var(--color-surface-muted)] transition-colors disabled:opacity-50"
                              onClick={() => {
                                if (item.cantidad >= item.stock) {
                                  toast.error("No hay más stock disponible");
                                  return;
                                }
                                updateQuantity(
                                  item.id,
                                  Math.min(item.stock, item.cantidad + 1)
                                );
                              }}
                              disabled={item.cantidad >= item.stock}
                              aria-label="Aumentar cantidad"
                              whileTap={{ scale: 0.95 }}
                            >
                              <Plus size={16} />
                            </motion.button>
                          </div>
                        </div>
                      </motion.li>
                    ))}
                  </AnimatePresence>
                </ul>
              )}
            </div>

            <div className="border-t border-[var(--color-border)] px-5 py-4 bg-[var(--color-surface-muted)]/30">
              <div className="flex items-center justify-between mb-2">
                <span className="font-medium text-[var(--color-text)]">Total</span>
                <span className="font-bold text-lg text-[var(--color-secondary)]">
                  {formatPrice(getCartTotal())}
                </span>
              </div>
              <p className="text-xs text-[var(--color-text-muted)] mb-4">
                Comprobante: Boleta (sin IGV)
              </p>
              <div className="flex gap-3">
                <motion.button
                  type="button"
                  className="btn btn-outline-secondary flex-1 inline-flex items-center justify-center gap-2"
                  onClick={() => {
                    clearCart();
                    toast.success("Carrito vaciado");
                  }}
                  disabled={cartItems.length === 0}
                  whileTap={{ scale: 0.98 }}
                  aria-label="Vaciar carrito"
                >
                  <Trash2 size={16} />
                  Vaciar
                </motion.button>
                <Link
                  href="/checkout"
                  className={`btn btn-primary flex-1 inline-flex items-center justify-center gap-2 ${
                    cartItems.length === 0 ? "opacity-50 pointer-events-none" : ""
                  }`}
                >
                  <CreditCard size={16} />
                  Ir a pagar
                </Link>
              </div>
            </div>
          </motion.aside>
        )}
      </AnimatePresence>
    </>
  );
}
