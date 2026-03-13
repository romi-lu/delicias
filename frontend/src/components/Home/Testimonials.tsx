"use client";
import React from "react";
import { motion } from "framer-motion";
import { Star, Quote } from "lucide-react";

type Testimonio = {
  nombre: string;
  texto: string;
};

const testimonios: Testimonio[] = [
  {
    nombre: "María G.",
    texto: "Las tortas personalizadas son espectaculares. La decoración y el sabor superaron mis expectativas.",
  },
  {
    nombre: "Luis P.",
    texto: "El pan artesanal siempre está fresco y crujiente. Atención amable y rápida.",
  },
  {
    nombre: "Andrea R.",
    texto: "Los alfajores y piononos son mis favoritos. Perfectos para compartir en familia.",
  },
];

export default function Testimonials() {
  return (
    <section
      id="testimonios"
      className="py-16 sm:py-24 bg-[var(--color-surface-muted)]/50"
      aria-labelledby="testimonios-title"
    >
      <div className="container">
        <motion.div
          initial={{ opacity: 0, y: 16 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          className="max-w-2xl mb-12"
        >
          <h2
            id="testimonios-title"
            className="text-2xl sm:text-3xl lg:text-4xl font-bold text-[var(--color-secondary)]"
          >
            Testimonios
          </h2>
          <p className="subheadline mt-3 text-lg">
            Lo que dicen nuestros clientes sobre Delicias.
          </p>
        </motion.div>

        <div className="grid sm:grid-cols-2 lg:grid-cols-3 gap-6">
          {testimonios.map((t, idx) => (
            <motion.article
              key={t.nombre}
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true, margin: "-60px" }}
              transition={{ duration: 0.5, delay: idx * 0.08 }}
              className="card p-6 relative"
            >
              <Quote
                size={32}
                className="absolute top-4 right-4 text-[var(--color-primary)]/20"
                aria-hidden
              />
              <div className="flex gap-1 text-[var(--color-primary)] mb-3" role="img" aria-label="5 estrellas">
                {[...Array(5)].map((_, i) => (
                  <Star key={i} size={18} fill="currentColor" stroke="none" />
                ))}
              </div>
              <p className="text-[var(--color-text)] mt-2 leading-relaxed">
                &ldquo;{t.texto}&rdquo;
              </p>
              <p className="mt-4 text-sm font-semibold text-[var(--color-secondary)]">
                {t.nombre}
              </p>
            </motion.article>
          ))}
        </div>
      </div>
    </section>
  );
}
