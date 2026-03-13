"use client";
import React from "react";
import { motion } from "framer-motion";
import Image from "next/image";
import { ArrowRight, Sparkles } from "lucide-react";

export default function Hero() {
  return (
    <section
      id="inicio"
      className="relative min-h-[85vh] sm:min-h-[90vh] flex items-center overflow-hidden"
      aria-labelledby="hero-title"
    >
      {/* Fondo con imagen y overlay */}
      <div className="absolute inset-0 -z-10">
        <Image
          src="/images/banners/baners 1.jpg"
          alt=""
          fill
          className="object-cover"
          priority
          sizes="100vw"
          quality={85}
        />
        <div
          className="absolute inset-0 bg-gradient-to-r from-white/95 via-white/80 to-white/60"
          aria-hidden
        />
        <div
          className="absolute inset-0 bg-gradient-to-t from-[var(--color-bg)]/30 via-transparent to-transparent"
          aria-hidden
        />
      </div>

      <div className="container py-16 sm:py-24">
        <motion.div
          initial={{ opacity: 0, y: 24 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.7, ease: [0.16, 1, 0.3, 1] }}
          className="max-w-2xl"
        >
          <motion.span
            initial={{ opacity: 0, x: -12 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ delay: 0.2, duration: 0.5 }}
            className="inline-flex items-center gap-2 px-3 py-1.5 rounded-full bg-[var(--color-primary)]/15 text-[var(--color-secondary)] text-sm font-medium mb-6"
          >
            <Sparkles size={16} aria-hidden />
            Panadería artesanal desde Huancayo
          </motion.span>

          <h1
            id="hero-title"
            className="headline text-[var(--color-secondary)] leading-tight"
          >
            Recién horneado,
            <br />
            <span className="text-[var(--color-primary-700)]">hecho para ti</span>
          </h1>

          <p className="subheadline mt-4 max-w-xl text-lg">
            Panadería artesanal con ingredientes de primera calidad y recetas
            tradicionales. Descubre panes crujientes, dulces irresistibles y
            tortas personalizadas.
          </p>

          <div className="mt-8 flex flex-wrap items-center gap-4">
            <motion.a
              href="/checkout"
              className="btn btn-primary inline-flex items-center gap-2 text-base px-6 py-3"
              whileHover={{ scale: 1.02 }}
              whileTap={{ scale: 0.98 }}
            >
              Ordenar Ahora
              <ArrowRight size={18} aria-hidden />
            </motion.a>
            <motion.a
              href="/products"
              className="btn btn-outline-secondary inline-flex items-center gap-2 text-base px-6 py-3"
              whileHover={{ scale: 1.02 }}
              whileTap={{ scale: 0.98 }}
            >
              Ver Menú
            </motion.a>
          </div>

          {/* Trust badges */}
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ delay: 0.6, duration: 0.5 }}
            className="mt-10 flex flex-wrap gap-6 text-sm text-[var(--color-text-muted)]"
          >
            <span className="flex items-center gap-2">
              <span className="w-2 h-2 rounded-full bg-[var(--color-success)]" aria-hidden />
              Envío gratis desde S/ 80
            </span>
            <span className="flex items-center gap-2">
              <span className="w-2 h-2 rounded-full bg-[var(--color-success)]" aria-hidden />
              Horneado diario
            </span>
            <span className="flex items-center gap-2">
              <span className="w-2 h-2 rounded-full bg-[var(--color-success)]" aria-hidden />
              Ingredientes naturales
            </span>
          </motion.div>
        </motion.div>
      </div>
    </section>
  );
}
