# Plan de Mejoras - Frontend Delicias

## Prioridad alta (impacto inmediato)

### 1. ProductGallery: datos dinámicos desde API
**Problema:** La sección "Productos destacados" en el home usa datos estáticos. No refleja el catálogo real ni el stock.

**Solución:** Consumir `/api/productos?destacado=1&limite=8` y mostrar productos reales con skeleton mientras carga.

### 2. Botón flotante de WhatsApp
**Problema:** Para negocios locales en Perú, WhatsApp es el canal principal de contacto.

**Solución:** Botón flotante fijo (esquina inferior derecha) que abre WhatsApp con mensaje predefinido. Número: 993560096.

### 3. Reemplazar `alert()` por toast
**Problema:** `ContactForm` y `ProductGallery` usan `alert()` para feedback. Rompe la experiencia moderna.

**Solución:** Usar `react-hot-toast` (ya instalado) en todos los flujos.

### 4. SEO y meta tags
**Problema:** Falta Open Graph, descripciones por página, JSON-LD para productos.

**Solución:** Meta dinámicos en layout y páginas clave. Schema.org para panadería y productos.

---

## Prioridad media (UX y conversión)

### 5. Carousel de banners en Hero
**Problema:** Un solo banner. Oportunidad de mostrar promociones rotativas.

**Solución:** Usar Swiper (ya instalado) para 2–3 banners con promociones, horarios, etc.

### 6. Breadcrumbs
**Problema:** En `/products` y `/product/[id]` no hay contexto de navegación.

**Solución:** Breadcrumbs: Inicio > Menú > [Categoría] > [Producto].

### 7. Scroll to top
**Problema:** En páginas largas (productos, checkout) volver arriba es incómodo.

**Solución:** Botón flotante que aparece al hacer scroll hacia abajo.

### 8. Placeholder blur en imágenes
**Problema:** Las imágenes cargan sin transición, sensación de “salto”.

**Solución:** `placeholder="blur"` con `blurDataURL` en Next/Image para productos.

### 9. Newsletter / captación de leads
**Problema:** No hay forma de captar emails para promociones.

**Solución:** Sección en footer o modal: “Recibe ofertas y novedades” con email.

---

## Prioridad baja (nice to have)

### 10. Productos vistos recientemente
**Solución:** Guardar IDs en `localStorage` y mostrar una fila “Vistos recientemente” en home o producto.

### 11. Favoritos / wishlist
**Solución:** Guardar productos favoritos en `localStorage` o en el usuario si está logueado.

### 12. Cookie consent
**Solución:** Banner básico de cookies con enlace a política de privacidad.

### 13. PWA básica
**Solución:** `manifest.json` y service worker para instalación en móvil.

### 14. Lazy load de secciones
**Solución:** Cargar componentes below-the-fold con `dynamic()` y `loading`.

---

## Resumen de implementación sugerida

| Mejora              | Esfuerzo | Impacto |
|---------------------|----------|---------|
| ProductGallery API  | Bajo     | Alto    |
| WhatsApp flotante   | Bajo     | Alto    |
| Toast en lugar de alert | Bajo | Medio   |
| SEO / meta          | Medio    | Alto    |
| Carousel Hero       | Medio    | Medio   |
| Breadcrumbs         | Bajo     | Medio   |
| Scroll to top       | Bajo     | Medio   |
