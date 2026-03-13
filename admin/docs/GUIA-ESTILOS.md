# Guía de estilos - Panel Admin Delicias

## 1. Esquema de colores corporativo

### Colores principales

```
Primary:    #b87333  (ámbar/cobre - acciones principales)
Secondary:  #a15c38  (marrón - acentos)
Accent:     #d8a25e  (dorado - highlights)
```

### Colores semánticos

| Estado | Color | Uso |
|--------|-------|-----|
| Success | `#059669` | Activo, completado, stock OK |
| Warning | `#d97706` | Stock bajo, pendiente |
| Danger | `#dc2626` | Error, eliminar, agotado |
| Info | `#0284c7` | Información, cargando |

### Superficies

- **Fondo general**: `#fff9f3` (crema muy suave)
- **Cards/surface**: `#ffffff`
- **Hover**: `#f7f3ed`
- **Bordes**: `#e5e0d8`

---

## 2. Tipografía

### Jerarquía

| Elemento | Tamaño | Peso | Uso |
|---------|--------|------|-----|
| H1 | 1.25rem | 700 | Títulos de página |
| H2 | 1rem | 600 | Subtítulos, secciones |
| Body | 0.9375rem | 400 | Texto general |
| Small | 0.75rem | 400 | Labels, hints |
| Caption | 0.6875rem | 500 | Badges, etiquetas |

### Contraste (WCAG 2.1 AA)

- Texto normal: contraste mínimo 4.5:1
- Texto grande (≥18px o 14px bold): 3:1
- Elementos interactivos: contraste suficiente para distinguibilidad

---

## 3. Espaciado

| Token | Valor | Uso |
|-------|-------|-----|
| space-1 | 4px | Gaps mínimos |
| space-2 | 8px | Padding interno pequeño |
| space-3 | 12px | Gaps entre elementos |
| space-4 | 16px | Padding estándar |
| space-5 | 20px | Secciones |
| space-6 | 24px | Separación de bloques |
| space-8 | 32px | Margen entre secciones |

---

## 4. Bordes y radios

- **sm**: 6px — inputs, badges
- **md**: 8px — botones, cards pequeñas
- **lg**: 12px — cards, modales
- **xl**: 16px — login card, contenedores destacados

---

## 5. Sombras

- **sm**: `0 1px 2px rgba(0,0,0,0.05)` — bordes sutiles
- **md**: `0 4px 6px -1px rgba(0,0,0,0.08)` — cards
- **lg**: `0 10px 15px -3px rgba(0,0,0,0.08)` — modales, dropdowns

---

## 6. Componentes

### Botones

- **Primary**: fondo `--admin-primary`, texto blanco
- **Outline**: borde, fondo transparente, hover con fondo
- **Danger**: fondo rojo para acciones destructivas
- **Tamaño mínimo táctil**: 44px de altura en móvil

### Badges

- **Success**: verde para activo/OK
- **Warning**: ámbar para pendiente/bajo stock
- **Danger**: rojo para error/agotado
- **Muted**: gris para información neutra

### Cards

- Fondo blanco, borde sutil, `border-radius` 12px
- Hover: sombra ligeramente mayor
- Padding interno: 16–20px

### Tablas

- Cabecera: fondo `--admin-surface-hover`, texto uppercase, tracking
- Filas: hover con fondo sutil
- Celdas: padding 12px 16px

---

## 7. Responsividad

| Breakpoint | Comportamiento |
|------------|----------------|
| < 768px | Sidebar como drawer, búsqueda oculta |
| 768px+ | Sidebar fijo 256px, búsqueda visible |
| 1024px+ | Grid de 4 columnas en dashboard |
| 1280px+ | Contenedor max-w-7xl centrado |

---

## 8. Accesibilidad (WCAG 2.1 AA)

- `:focus-visible` con anillo de 2px en color primary
- `aria-label` en botones de icono
- `aria-current="page"` en enlace activo del sidebar
- `role="alert"` en mensajes de error
- `min-height: 44px` en botones principales
- Respeto a `prefers-reduced-motion`

---

## 9. Tema oscuro

Variables en `.dark`:

- Primary: `#d8a25e`
- Surface: `#24221f`
- Text: `#eae7e2`
- Bordes y fondos adaptados para contraste
