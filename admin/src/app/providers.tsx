"use client";

import React from "react";
import { ThemeProvider } from "next-themes";
import { Toaster } from "react-hot-toast";
import { AuthProvider } from "@/context/AuthContext";

export default function Providers({ children }: { children: React.ReactNode }) {
  return (
    <ThemeProvider attribute="class" defaultTheme="light" enableSystem={false}>
      <AuthProvider>
        {children}
        <Toaster position="top-right" />
      </AuthProvider>
    </ThemeProvider>
  );
}

