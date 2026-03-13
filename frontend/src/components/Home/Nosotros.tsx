"use client";
import React from "react";
import { motion } from "framer-motion";
import Image from "next/image";
import { CheckCircle2 } from "lucide-react";

const puntos = [
  "Ingredientes seleccionados y de calidad",
  "Recetas tradicionales con toques modernos",
  "Horneado diario para asegurar frescura",
  "Hecho con cariño por nuestro equipo",
];

export default function Nosotros() {
  return (
    <section
      id="nosotros"
      className="py-16 sm:py-24 bg-[var(--color-surface-muted)]/50"
      aria-labelledby="nosotros-title"
    >
      <div className="container">
        <div className="grid lg:grid-cols-2 gap-12 lg:gap-16 items-center">
          <motion.div
            initial={{ opacity: 0, x: -24 }}
            whileInView={{ opacity: 1, x: 0 }}
            viewport={{ once: true, margin: "-80px" }}
            transition={{ duration: 0.6 }}
            className="space-y-6 order-2 lg:order-1"
          >
            <h2
              id="nosotros-title"
              className="text-2xl sm:text-3xl lg:text-4xl font-bold text-[var(--color-secondary)]"
            >
              Nosotros
            </h2>
            <p className="subheadline text-lg leading-relaxed">
              En Delicias, horneamos cada día con dedicación y cariño. Nuestros
              productos combinan ingredientes naturales, recetas de familia y
              procesos artesanales para ofrecerte sabores auténticos.
            </p>

            <ul className="grid sm:grid-cols-2 gap-3" role="list">
              {puntos.map((t, i) => (
                <motion.li
                  key={t}
                  initial={{ opacity: 0, y: 8 }}
                  whileInView={{ opacity: 1, y: 0 }}
                  viewport={{ once: true }}
                  transition={{ delay: i * 0.05 }}
                  className="flex items-start gap-3 text-sm text-[var(--color-text)]"
                >
                  <CheckCircle2
                    size={20}
                    className="text-[var(--color-primary)] shrink-0 mt-0.5"
                    aria-hidden
                  />
                  <span>{t}</span>
                </motion.li>
              ))}
            </ul>

            <div className="flex flex-wrap gap-4 pt-2">
              <a href="/products" className="btn btn-outline-secondary">
                Ver el menú
              </a>
              <a href="#contacto" className="btn btn-primary">
                Contacto
              </a>
            </div>
          </motion.div>

          <motion.div
            initial={{ opacity: 0, x: 24 }}
            whileInView={{ opacity: 1, x: 0 }}
            viewport={{ once: true, margin: "-80px" }}
            transition={{ duration: 0.6, delay: 0.1 }}
            className="relative overflow-hidden rounded-2xl shadow-lg order-1 lg:order-2"
          >
            <div className="aspect-[4/3] relative">
              <Image
                src="/images/illustrations/illustrations.png"
                alt="Interior de la panadería Delicias"
                fill
                className="object-cover"
                sizes="(max-width: 1024px) 100vw, 50vw"
              />
            </div>
          </motion.div>
        </div>
      </div>
    </section>
  );
}
