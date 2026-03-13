# Evidencia de pruebas visuales - Panel Admin Delicias

## Checklist de verificación

### Navegadores

| Navegador | Versión | Desktop | Tablet | Móvil |
|-----------|---------|---------|--------|-------|
| Chrome | 120+ | ☐ | ☐ | ☐ |
| Firefox | 120+ | ☐ | ☐ | ☐ |
| Safari | 17+ | ☐ | ☐ | ☐ |
| Edge | 120+ | ☐ | ☐ | ☐ |

### Resoluciones

| Dispositivo | Resolución | Estado |
|-------------|------------|--------|
| Desktop HD | 1920×1080 | ☐ |
| Desktop | 1366×768 | ☐ |
| Laptop | 1280×720 | ☐ |
| Tablet | 768×1024 | ☐ |
| Móvil | 375×667 | ☐ |
| Móvil pequeño | 320×568 | ☐ |

### Páginas a verificar

- [ ] `/login` — formulario centrado, responsive, tema claro/oscuro
- [ ] `/` (Dashboard) — métricas, gráficos, grid responsivo
- [ ] `/productos` — tabla, filtros, paginación
- [ ] `/categorias` — listado y formularios
- [ ] `/usuarios` — tabla de usuarios
- [ ] `/pedidos` — listado de pedidos
- [ ] `/comprobantes` — comprobantes
- [ ] `/reportes` — reportes
- [ ] `/configuracion` — configuración

### Funcionalidades visuales

- [ ] Sidebar: fijo en desktop, drawer en móvil
- [ ] Header: búsqueda visible en desktop, oculta en móvil
- [ ] Menú usuario: dropdown funcional
- [ ] Toggle tema: cambio correcto entre claro/oscuro
- [ ] Animaciones: entrada de páginas y cards
- [ ] Focus visible: anillo en elementos enfocados
- [ ] Contraste: texto legible en todos los fondos

### Accesibilidad

- [ ] Navegación por teclado (Tab, Enter, Escape)
- [ ] Screen reader: labels y roles correctos
- [ ] Contraste WCAG AA en texto
- [ ] `prefers-reduced-motion`: animaciones reducidas

### Cómo ejecutar pruebas

```bash
# Desarrollo
npm run dev

# Producción (build + start)
npm run build
npm run start
```

Abrir `http://localhost:6003` y verificar manualmente cada ítem.

---

## Notas

- Las pruebas automatizadas (Playwright, Cypress) pueden añadirse en el futuro.
- Para Lighthouse: ejecutar en modo incógnito sin extensiones.
- Objetivos: Performance > 90, Accessibility > 95, Best Practices > 90.
