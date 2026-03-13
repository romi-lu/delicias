# Documentación Técnica - Rediseño Frontend Delicias

## 1. Arquitectura del Rediseño

### Stack tecnológico
- **Framework**: Next.js 15 (App Router)
- **Estilos**: Tailwind CSS v4
- **Animaciones**: Framer Motion
- **Iconos**: Lucide React

### Estructura de archivos clave
```
src/
├── styles/
│   ├── globals.css          # Estilos globales, utilidades
│   └── design-tokens.css    # Variables de diseño
├── components/
│   ├── Home/                # Secciones landing
│   ├── Layout/              # Navbar, Footer
│   ├── Product/             # ProductCard, SearchSuggest
│   ├── Cart/                # CartSidebar
│   └── ui/                  # Button, Badge, Skeleton
├── context/
│   ├── ABTestContext.tsx    # Infraestructura A/B
│   └── ...
└── app/
```

---

## 2. Sistema de Diseño

### Design Tokens (`design-tokens.css`)
- Variables CSS para colores, sombras, radios, transiciones
- Compatibilidad con dark mode vía clase `.dark`
- Variables legacy (`--color-primary`, etc.) para compatibilidad

### Uso en componentes
```css
/* En lugar de valores fijos */
color: var(--color-secondary);
background: var(--color-surface);
border-radius: var(--radius-lg);
box-shadow: var(--shadow-md);
```

---

## 3. Optimizaciones de Performance

### Imágenes
- **Next/Image**: `priority` en Hero, `loading="lazy"` en resto
- **Formatos**: AVIF y WebP configurados en `next.config.ts`
- **Sizes**: Atributo `sizes` para responsive images

### Animaciones
- `whileInView` con `viewport={{ once: true }}` para animar solo al entrar
- `prefers-reduced-motion` respetado para usuarios sensibles

### Código
- Componentes client solo donde se necesita (`"use client"`)
- Lazy loading implícito con Next.js

---

## 4. Accesibilidad Implementada

| Requisito WCAG | Implementación |
|----------------|----------------|
| 1.3.1 Info y relaciones | Labels, roles ARIA |
| 2.1.1 Teclado | Skip link, focus visible |
| 2.4.7 Focus visible | Outline en :focus-visible |
| 2.5.3 Label in name | Botones con texto/aria-label |
| 4.1.2 Name, role, value | Formularios con id/aria-invalid |

---

## 5. Infraestructura A/B

### Uso
```tsx
import { useABTest } from "@/context/ABTestContext";

function Component() {
  const { variant, isVariantB } = useABTest();
  return isVariantB ? <VariantB /> : <VariantA />;
}
```

### Persistencia
- Variante asignada en `localStorage` (`delicias_ab_variant`)
- Asignación aleatoria 50/50 en primera visita

### Extensión
- Añadir eventos de analytics para conversión
- Integrar con herramienta de A/B (Optimizely, VWO, etc.)

---

## 6. Responsive y Breakpoints

- **Mobile first**: Estilos base para móvil, `sm:` y superiores para desktop
- **Container**: `max-w-7xl` con padding adaptativo
- **Navbar**: Top bar + nav principal + categorías; menú colapsable en móvil

---

## 7. Dark Mode

- `next-themes` con `attribute="class"`
- Variables en `design-tokens.css` bajo `.dark`
- ThemeToggle en Navbar

---

## 8. Próximos Pasos Sugeridos

1. **Analytics**: Eventos de conversión por variante A/B
2. **Core Web Vitals**: Monitoreo LCP, FID, CLS
3. **Tests E2E**: Playwright/Cypress para flujos críticos
4. **PWA**: Service worker para offline básico
