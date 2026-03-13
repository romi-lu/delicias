"use client";
import React from "react";
import { usePathname } from "next/navigation";
import Footer from "@/components/Layout/Footer";
import CartSidebar from "@/components/Cart/CartSidebar";
import Navbar from "@/components/Layout/Navbar";
import WhatsAppButton from "@/components/Layout/WhatsAppButton";
import ScrollToTop from "@/components/Layout/ScrollToTop";
import { AnimatePresence, motion } from "framer-motion";

export default function ClientShell({ children }: { children: React.ReactNode }) {
  const pathname = usePathname();
  const isAdminRoute = pathname?.startsWith("/admin");

  if (isAdminRoute) {
    return (
      <div>
        {children}
      </div>
    );
  }

  return (
    <div>
      <Navbar />
      <CartSidebar />
      <WhatsAppButton />
      <ScrollToTop />
      <main id="main-content" tabIndex={-1}>
        <AnimatePresence mode="wait">
          <motion.div
            key={pathname}
            initial={{ opacity: 0, y: 8 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0, y: -8 }}
            transition={{ duration: 0.25, ease: "easeOut" }}
          >
            {children}
          </motion.div>
        </AnimatePresence>
      </main>
      <Footer />
    </div>
  );
}