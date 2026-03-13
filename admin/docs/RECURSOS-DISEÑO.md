# Recursos de diseño - Panel Admin Delicias

## Resumen

Este documento describe todos los recursos empleados en el rediseño del panel de administración, integrando elementos de la plantilla `main-files` y adaptándolos al ecosistema Next.js/React.

---

## 1. Esquema de colores (de main-files y globals.css)

| Variable | Valor light | Uso |
|----------|-------------|-----|
| `--admin-primary` | `#b87333` | Botones principales, enlaces activos, acentos |
| `--admin-primary-hover` | `#a15c38` | Hover de botones primarios |
| `--admin-primary-light` | `#f7f3ed` | Fondos sutiles, sidebar activo |
| `--admin-secondary` | `#a15c38` | Gradientes, acentos secundarios |
| `--admin-accent` | `#d8a25e` | Acentos decorativos |
| `--admin-success` | `#059669` | Estados exitosos, badges |
| `--admin-warning` | `#d97706` | Alertas, stock bajo |
| `--admin-danger` | `#dc2626` | Errores, eliminar |
| `--admin-info` | `#0284c7` | Información |
| `--admin-surface` | `#ffffff` | Fondos de cards, header |
| `--admin-bg-subtle` | `#fff9f3` | Fondo general del panel |

---

## 2. Tipografía

- **Principal**: Noto Sans (Google Fonts) — pesos 300, 400, 500, 600, 700
- **Fallback**: Geist Sans, system-ui, -apple-system, sans-serif
- **Tamaño base**: 15px (0.9375rem)
- **Line-height**: 1.5

---

## 3. Iconografía

- **lucide-react** (v0.577.0): iconos SVG consistentes
  - LayoutDashboard, FileText, ShoppingBag, Folder, Users, Settings
  - Cake (logo/brand), Eye, EyeOff, Loader2, DollarSign, Package
  - ClipboardList, BarChart3, Menu, Search, Bell, Sun, Moon, ChevronDown
  - Settings, LogOut, X

---

## 4. Componentes reutilizables

| Componente | Ubicación | Descripción |
|------------|-----------|-------------|
| Shell | `design/admin/components/Shell.tsx` | Layout principal (Header + Sidebar + main) |
| Sidebar | `design/admin/components/Sidebar.tsx` | Navegación lateral, drawer en móvil |
| Header | `design/admin/components/Header.tsx` | Barra superior con búsqueda y menú usuario |
| Button | `design/admin/components/Button.tsx` | Botones con variantes (primary, outline, etc.) |
| Badge | `design/admin/components/Badge.tsx` | Etiquetas de estado |
| MetricCard | `design/admin/components/MetricCard.tsx` | Tarjetas de métricas del dashboard |
| Table | `design/admin/components/Table.tsx` | Tabla con THead, TBody, Tr, Td |
| Alert | `design/admin/components/Alert.tsx` | Alertas (info, danger, warning, success) |
| StatusBadge | `design/admin/components/StatusBadge.tsx` | Activo/Inactivo |

---

## 5. Animaciones (framer-motion)

- **Entrada de páginas**: `opacity` + `y` (slide-up)
- **Sidebar móvil**: overlay fade + drawer slide desde izquierda
- **MetricCards**: entrada escalonada
- **Gráficos**: fade-in con delay
- **Respeto a prefers-reduced-motion**: animaciones deshabilitadas si el usuario lo prefiere

---

## 6. Dependencias

```
next, react, react-dom
tailwindcss, @tailwindcss/postcss
framer-motion
lucide-react
clsx
next-themes
recharts
axios
react-hot-toast
```

---

## 7. Archivos CSS

| Archivo | Contenido |
|---------|-----------|
| `app/globals.css` | Tailwind, tokens, tipografía, skeleton, animaciones |
| `design/admin/styles/tokens.css` | Variables CSS (colores, espaciado, sombras) |

---

## 8. Estructura de carpetas relevante

```
admin/
├── src/
│   ├── app/
│   │   ├── globals.css
│   │   ├── layout.tsx
│   │   ├── login/page.tsx
│   │   └── (panel)/
│   │       ├── layout.tsx
│   │       ├── page.tsx (dashboard)
│   │       ├── productos/
│   │       ├── categorias/
│   │       └── ...
│   └── design/admin/
│       ├── components/
│       │   ├── Shell.tsx
│       │   ├── Sidebar.tsx
│       │   ├── Header.tsx
│       │   ├── Button.tsx
│       │   ├── Badge.tsx
│       │   ├── MetricCard.tsx
│       │   ├── Table.tsx
│       │   ├── Alert.tsx
│       │   └── StatusBadge.tsx
│       └── styles/
│           └── tokens.css
└── docs/
    ├── RECURSOS-DISEÑO.md
    ├── GUIA-ESTILOS.md
    └── PRUEBAS-VISUALES.md
```

---

## 9. Recursos de la plantilla main-files utilizados como referencia

- **auth-basic-login.html**: estructura de card centrada, borde superior con gradiente
- **main.scss**: variables de espaciado, utilidades (wh-42, separator)
- **blue-theme.scss**: variables de tema oscuro
- **responsive.scss**: breakpoints (1024px, 1199px, 1280px)
- **bootstrap-extended.css**: paleta de colores semánticos

No se copiaron archivos estáticos (imágenes, fuentes) de la plantilla; se usan fuentes de Google Fonts e iconos de lucide-react.
