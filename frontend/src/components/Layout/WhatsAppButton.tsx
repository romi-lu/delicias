"use client";
import React from "react";
import { motion } from "framer-motion";
import { MessageCircle } from "lucide-react";

const PHONE = "993560096";
const DEFAULT_MESSAGE = "Hola, me gustaría hacer un pedido o consultar sobre sus productos.";

export default function WhatsAppButton() {
  const url = `https://wa.me/51${PHONE}?text=${encodeURIComponent(DEFAULT_MESSAGE)}`;

  return (
    <motion.a
      href={url}
      target="_blank"
      rel="noopener noreferrer"
      aria-label="Contactar por WhatsApp"
      className="fixed bottom-6 right-6 z-40 flex h-14 w-14 items-center justify-center rounded-full bg-[#25D366] text-white shadow-lg hover:bg-[#20BD5A] transition-colors"
      initial={{ scale: 0, opacity: 0 }}
      animate={{ scale: 1, opacity: 1 }}
      transition={{ delay: 1, type: "spring", stiffness: 200 }}
      whileHover={{ scale: 1.1 }}
      whileTap={{ scale: 0.95 }}
    >
      <MessageCircle size={28} strokeWidth={2} />
    </motion.a>
  );
}
