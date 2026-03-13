"use client";
import React, { createContext, useContext, useEffect, useState } from "react";

type Variant = "A" | "B";

type ABTestContextType = {
  variant: Variant;
  isVariantB: boolean;
};

const ABTestContext = createContext<ABTestContextType | null>(null);

const STORAGE_KEY = "delicias_ab_variant";

export function ABTestProvider({ children }: { children: React.ReactNode }) {
  const [variant, setVariant] = useState<Variant>("A");

  useEffect(() => {
    if (typeof window === "undefined") return;
    const stored = localStorage.getItem(STORAGE_KEY) as Variant | null;
    if (stored === "A" || stored === "B") {
      setVariant(stored);
    } else {
      const assigned: Variant = Math.random() < 0.5 ? "A" : "B";
      localStorage.setItem(STORAGE_KEY, assigned);
      setVariant(assigned);
    }
  }, []);

  return (
    <ABTestContext.Provider value={{ variant, isVariantB: variant === "B" }}>
      {children}
    </ABTestContext.Provider>
  );
}

export function useABTest() {
  const ctx = useContext(ABTestContext);
  return ctx ?? { variant: "A" as Variant, isVariantB: false };
}
