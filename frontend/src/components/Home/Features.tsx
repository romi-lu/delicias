"use client";
import React from "react";
import { motion } from "framer-motion";
import Image from "next/image";
import { ArrowRight, Wheat, Cake, Gift } from "lucide-react";

const items = [
  {
    title: "Panes artesanales",
    description: "Recetas con masa madre, horneado diario y máxima frescura.",
    src: "/images/categories/pan.png",
    href: "/products",
    icon: Wheat,
  },
  {
    title: "Dulces y pasteles",
    description: "Croissants, bollería y dulces con mantequilla real.",
    src: "/images/categories/pasteles.png",
    href: "/products",
    icon: Cake,
  },
  {
    title: "Tortas personalizadas",
    description: "Diseños únicos para tus celebraciones: sabores y decoración a medida.",
    src: "/images/categories/tortas.jpg",
    href: "/#contacto",
    icon: Gift,
  },
];

export default function Features() {
  return (
    <section id="categorias" className="py-16 sm:py-24">
      <div className="container">
        <motion.div
          initial={{ opacity: 0, y: 16 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true, margin: "-50px" }}
          transition={{ duration: 0.5 }}
          className="max-w-2xl mb-12"
        >
          <h2 className="text-2xl sm:text-3xl lg:text-4xl font-bold text-[var(--color-secondary)]">
            ¿Por qué elegirnos?
          </h2>
          <p className="subheadline mt-3 text-lg">
            Tres clásicos de la casa para empezar: panes artesanales, dulces
            irresistibles y tortas personalizadas.
          </p>
        </motion.div>

        <div className="grid sm:grid-cols-2 lg:grid-cols-3 gap-6 lg:gap-8">
          {items.map((item, idx) => (
            <motion.article
              key={item.title}
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true, margin: "-60px" }}
              transition={{ duration: 0.5, delay: idx * 0.1 }}
              className="card card-hover overflow-hidden group"
            >
              <div className="relative aspect-[4/3] overflow-hidden">
                <Image
                  src={item.src}
                  alt={item.title}
                  fill
                  className="object-cover transition-transform duration-500 group-hover:scale-105"
                  sizes="(max-width: 640px) 100vw, (max-width: 1024px) 50vw, 33vw"
                />
                <div
                  className="absolute inset-0 bg-gradient-to-t from-black/60 via-black/20 to-transparent"
                  aria-hidden
                />
                <div className="absolute bottom-4 left-4 right-4 flex items-center justify-between">
                  <span className="inline-flex items-center gap-2 rounded-full bg-white/90 px-3 py-1.5 text-sm font-medium text-[var(--color-secondary)] backdrop-blur-sm">
                    <item.icon size={18} aria-hidden />
                    {item.title}
                  </span>
                </div>
              </div>
              <div className="p-5">
                <p className="text-sm text-[var(--color-text-muted)]">
                  {item.description}
                </p>
                <a
                  href={item.href}
                  className="mt-4 inline-flex items-center gap-2 text-sm font-semibold text-[var(--color-secondary)] hover:text-[var(--color-primary-700)] transition-colors group/link"
                >
                  Ver más
                  <ArrowRight
                    size={16}
                    className="transition-transform group-hover/link:translate-x-1"
                    aria-hidden
                  />
                </a>
              </div>
            </motion.article>
          ))}
        </div>
      </div>
    </section>
  );
}
