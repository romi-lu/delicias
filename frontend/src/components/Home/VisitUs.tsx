"use client";
import React from "react";
import { motion } from "framer-motion";
import Image from "next/image";
import { Phone, Mail } from "lucide-react";

const gallery = [
  "/images/products/alfajores.jpg",
  "/images/products/delikeik.jpg",
  "/images/products/karamanduka.jpg",
  "/images/products/pionono.jpg",
  "/images/products/tostadas.jpg",
];

export default function VisitUs() {
  return (
    <section
      id="visitanos"
      className="py-16 sm:py-24"
      aria-labelledby="visitanos-title"
    >
      <div className="container">
        <div className="grid lg:grid-cols-2 gap-12 lg:gap-16 items-start">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ duration: 0.5 }}
            className="space-y-6"
          >
            <h2
              id="visitanos-title"
              className="text-2xl sm:text-3xl lg:text-4xl font-bold text-[var(--color-secondary)]"
            >
              Visítanos hoy
            </h2>
            <p className="subheadline text-lg">
              Panadería Delicias — Jr. Parra del Riego #164, El Tambo, Huancayo.
              Atención: Lunes a Domingo, 7:00 AM – 9:00 PM.
            </p>
            <ul className="space-y-3 text-sm text-[var(--color-text-muted)]">
              <li className="flex items-center gap-3">
                <Phone size={18} className="shrink-0" aria-hidden />
                <strong className="text-[var(--color-text)]">Celular:</strong>{" "}
                993560096
              </li>
              <li className="flex items-center gap-3">
                <Mail size={18} className="shrink-0" aria-hidden />
                <strong className="text-[var(--color-text)]">Correo:</strong>{" "}
                contacto@delicias.com
              </li>
            </ul>
            <div className="flex flex-wrap gap-4">
              <a href="/products" className="btn btn-outline-secondary">
                Ver el menú
              </a>
              <a href="#mapa" className="btn btn-primary">
                Cómo llegar
              </a>
            </div>
            <div
              id="mapa"
              className="mt-6 card overflow-hidden"
              aria-label="Mapa de ubicación"
            >
              <iframe
                title="Ubicación Panadería Delicias en Google Maps"
                src="https://www.google.com/maps?q=Jr.+Parra+del+Riego+164,+El+Tambo,+Huancayo&output=embed"
                width="100%"
                height="280"
                style={{ border: 0 }}
                loading="lazy"
                referrerPolicy="no-referrer-when-downgrade"
              />
            </div>
          </motion.div>

          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ duration: 0.5, delay: 0.1 }}
            className="grid grid-cols-2 sm:grid-cols-3 gap-3"
          >
            {gallery.map((src, i) => (
              <motion.div
                key={src}
                initial={{ opacity: 0, scale: 0.95 }}
                whileInView={{ opacity: 1, scale: 1 }}
                viewport={{ once: true }}
                transition={{ delay: i * 0.05 }}
                className="relative aspect-square rounded-2xl overflow-hidden shadow-md group"
              >
                <Image
                  src={src}
                  alt="Producto de la panadería Delicias"
                  fill
                  className="object-cover transition-transform duration-500 group-hover:scale-110"
                  sizes="(max-width: 640px) 50vw, 33vw"
                />
              </motion.div>
            ))}
          </motion.div>
        </div>
      </div>
    </section>
  );
}
