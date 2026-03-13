"use client";
import React, { useEffect, useState } from "react";
import axios from "axios";
import { motion } from "framer-motion";
import ProductCard, { type Producto } from "@/components/Product/ProductCard";
import { useCart } from "@/context/CartContext";
import Skeleton from "@/components/ui/Skeleton";
import { toast } from "react-hot-toast";

export default function ProductGallery() {
  const { addToCart, canAddToCart, openCart } = useCart();
  const [productos, setProductos] = useState<Producto[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchDestacados = async () => {
      try {
        const res = await axios.get("/api/productos?destacado=true&limite=8");
        const items = res.data?.productos || res.data || [];
        setProductos(Array.isArray(items) ? items : []);
      } catch {
        // Fallback: productos estáticos si la API falla
        setProductos([
          { id: 101, nombre: "Alfajores", descripcion: "Dulces tradicionales con manjar", precio: 3.5, stock: 25, destacado: true, imagen: "/images/products/alfajores.jpg", categoria_nombre: "Dulces" },
          { id: 102, nombre: "Delikeik clásico", descripcion: "Bizcochuelo esponjoso con crema suave", precio: 18.9, stock: 12, destacado: true, imagen: "/images/products/delikeik.jpg", categoria_nombre: "Tortas" },
          { id: 103, nombre: "Karamanduka artesanal", descripcion: "Nuestra especialidad con toques de caramelo", precio: 22, stock: 8, imagen: "/images/products/karamanduka.jpg", categoria_nombre: "Tortas" },
          { id: 104, nombre: "Pionono", descripcion: "Rollo suave relleno de manjar", precio: 9.9, stock: 20, imagen: "/images/products/pionono.jpg", categoria_nombre: "Dulces" },
          { id: 105, nombre: "Tostadas", descripcion: "Crujientes y doradas", precio: 6.5, stock: 30, imagen: "/images/products/tostadas.jpg", categoria_nombre: "Panes" },
        ]);
      } finally {
        setLoading(false);
      }
    };
    fetchDestacados();
  }, []);

  const handleAdd = (p: Producto) => {
    if (canAddToCart?.(p)) {
      addToCart(p, 1);
      openCart?.();
      toast.success(`${p.nombre} añadido al carrito`);
    } else {
      toast.error("Stock insuficiente para agregar al carrito");
    }
  };

  return (
    <section id="destacados" className="py-16 sm:py-24" aria-labelledby="destacados-title">
      <div className="container">
        <motion.div
          initial={{ opacity: 0, y: 16 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          className="max-w-2xl mb-12"
        >
          <h2 id="destacados-title" className="text-2xl sm:text-3xl lg:text-4xl font-bold text-[var(--color-secondary)]">
            Productos destacados
          </h2>
          <p className="subheadline mt-3 text-lg">Una selección de nuestros favoritos para que empieces a disfrutar.</p>
        </motion.div>

        {loading ? (
          <div className="grid sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 2xl:grid-cols-5 gap-6">
            {Array.from({ length: 5 }).map((_, i) => (
              <div key={i} className="rounded-2xl border border-[var(--color-border)] overflow-hidden">
                <Skeleton className="aspect-square" rounded="xl" />
                <div className="p-4 space-y-2">
                  <Skeleton className="h-5 w-3/4" />
                  <Skeleton className="h-4 w-1/2" />
                  <Skeleton className="h-10 w-full mt-4" rounded="xl" />
                </div>
              </div>
            ))}
          </div>
        ) : productos.length === 0 ? (
          <p className="text-[var(--color-text-muted)] text-center py-12">No hay productos destacados por el momento.</p>
        ) : (
          <div className="grid sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 2xl:grid-cols-5 gap-6">
            {productos.map((p) => (
              <ProductCard key={p.id} producto={p} onAddToCart={handleAdd} />
            ))}
          </div>
        )}
      </div>
    </section>
  );
}
