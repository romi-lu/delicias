"use client";
import React from "react";
import Link from "next/link";
import { motion } from "framer-motion";
import {
  Facebook,
  Instagram,
  Phone,
  Mail,
  MapPin,
  Heart,
} from "lucide-react";
import Image from "next/image";

const footerLinks = [
  { href: "/products", label: "Menú" },
  { href: "/#nosotros", label: "Nosotros" },
  { href: "/#contacto", label: "Contacto" },
  { href: "/checkout", label: "Ordenar" },
];

export default function Footer() {
  return (
    <footer className="footer" role="contentinfo">
      <div className="footer-inner">
        {/* Brand */}
        <div className="sm:col-span-2 lg:col-span-1">
          <motion.div
            initial={{ opacity: 0, y: 8 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            className="flex items-center gap-3 mb-4"
          >
            <Image
              src="/images/logos/logo 1.png"
              alt=""
              width={48}
              height={48}
              className="rounded-xl"
            />
            <h3 className="text-xl font-bold text-[var(--color-secondary)]">
              Panadería Delicias
            </h3>
          </motion.div>
          <p className="text-sm text-[var(--color-text-muted)] max-w-xs">
            Pan artesanal, dulces y tortas con ingredientes de primera calidad.
            Horneamos con cariño cada día.
          </p>
        </div>

        {/* Enlaces rápidos */}
        <div>
          <h4 className="font-semibold text-[var(--color-text)] mb-4">
            Enlaces
          </h4>
          <ul className="space-y-2">
            {footerLinks.map((link) => (
              <li key={link.href}>
                <Link
                  href={link.href}
                  className="text-sm text-[var(--color-text-muted)] hover:text-[var(--color-secondary)] transition-colors"
                >
                  {link.label}
                </Link>
              </li>
            ))}
          </ul>
        </div>

        {/* Contacto */}
        <div>
          <h4 className="font-semibold text-[var(--color-text)] mb-4">
            Contacto
          </h4>
          <ul className="space-y-3 text-sm text-[var(--color-text-muted)]">
            <li className="flex items-start gap-3">
              <MapPin size={18} className="mt-0.5 shrink-0" aria-hidden />
              <span>Jr. Parra del Riego #164, El Tambo, Huancayo</span>
            </li>
            <li>
              <a
                href="tel:993560096"
                className="inline-flex items-center gap-2 hover:text-[var(--color-secondary)] transition-colors"
              >
                <Phone size={18} aria-hidden />
                993560096
              </a>
            </li>
            <li>
              <a
                href="mailto:contacto@delicias.com"
                className="inline-flex items-center gap-2 hover:text-[var(--color-secondary)] transition-colors"
              >
                <Mail size={18} aria-hidden />
                contacto@delicias.com
              </a>
            </li>
            <li>Lunes a Domingo, 7:00 AM – 9:00 PM</li>
          </ul>
        </div>

        {/* Redes */}
        <div>
          <h4 className="font-semibold text-[var(--color-text)] mb-4">
            Síguenos
          </h4>
          <div className="flex gap-3">
            <a
              href="#"
              aria-label="Instagram de Delicias"
              className="inline-flex items-center justify-center w-10 h-10 rounded-xl bg-[var(--color-surface)] border border-[var(--color-border)] text-[var(--color-text-muted)] hover:text-[var(--color-secondary)] hover:border-[var(--color-primary)]/30 transition-all"
            >
              <Instagram size={20} />
            </a>
            <a
              href="#"
              aria-label="Facebook de Delicias"
              className="inline-flex items-center justify-center w-10 h-10 rounded-xl bg-[var(--color-surface)] border border-[var(--color-border)] text-[var(--color-text-muted)] hover:text-[var(--color-secondary)] hover:border-[var(--color-primary)]/30 transition-all"
            >
              <Facebook size={20} />
            </a>
          </div>
        </div>
      </div>

      {/* Bottom bar */}
      <div className="border-t border-[var(--color-border)]">
        <div className="container py-5 flex flex-col sm:flex-row items-center justify-between gap-4 text-sm text-[var(--color-text-muted)]">
          <p className="flex items-center gap-1">
            © {new Date().getFullYear()} Delicias. Hecho con
            <Heart size={14} className="text-[var(--color-primary)] inline" aria-hidden />
            en Huancayo
          </p>
          <div className="flex items-center gap-6">
            <Link
              href="/terms"
              className="hover:text-[var(--color-text)] transition-colors"
            >
              Términos
            </Link>
            <Link
              href="/privacy"
              className="hover:text-[var(--color-text)] transition-colors"
            >
              Privacidad
            </Link>
            <Link
              href="/#contacto"
              className="hover:text-[var(--color-text)] transition-colors"
            >
              Contacto
            </Link>
          </div>
        </div>
      </div>
    </footer>
  );
}
