# Guía de Estilos - Panadería Delicias

## 1. Identidad de Marca

### Filosofía visual
- **Cálido y acogedor**: Tonos que evocan pan recién horneado, miel y trigo
- **Artesanal y premium**: Bordes redondeados, sombras sutiles, tipografía clara
- **Contemporáneo**: Espaciado generoso, jerarquía visual clara

---

## 2. Paleta de Colores

### Colores primarios (Brand)
| Token | Hex | Uso |
|-------|-----|-----|
| `--color-primary-400` | #D8A25E | Acento principal, iconos |
| `--color-primary-500` | #C4893D | Hover, estados activos |
| `--color-primary-600` | #A15C38 | Secundario, títulos |
| `--color-primary-700` | #8B4A2E | Texto destacado |

### Colores de acento (CTAs)
| Token | Hex | Uso |
|-------|-----|-----|
| `--color-accent-500` | #B87333 | Botones primarios |
| `--color-accent-hover` | #A75E2B | Hover de botones |

### Neutros
| Token | Uso |
|-------|-----|
| `--color-text` | Texto principal |
| `--color-text-muted` | Texto secundario |
| `--color-surface` | Fondos de tarjetas |
| `--color-surface-muted` | Fondos alternativos |
| `--color-border` | Bordes sutiles |

### Semánticos
| Token | Uso |
|-------|-----|
| `--color-success` | Confirmaciones, stock disponible |
| `--color-warning` | Alertas, stock bajo |
| `--color-error` | Errores, agotado |

---

## 3. Tipografía

### Familias
- **Poppins** (variable `--font-poppins`): Títulos, headlines
- **Inter** (variable `--font-inter`): Cuerpo, UI

### Escala
| Clase | Tamaño | Peso | Uso |
|-------|--------|------|-----|
| `.headline` | 2.25rem - 3rem | 800 | Hero, secciones |
| `h2` | 1.5rem - 2.25rem | 700 | Títulos de sección |
| `h3` | 1.25rem | 600 | Subtítulos |
| `body` | 1rem | 400 | Texto normal |
| `.subheadline` | 1rem - 1.125rem | 400 | Descripciones |

---

## 4. Espaciado

### Sistema base: 4px
- `gap-2` = 8px
- `gap-4` = 16px
- `gap-6` = 24px
- `gap-8` = 32px
- `py-12` = 48px (secciones)
- `py-16` = 64px (secciones grandes)

### Container
- `max-w-7xl` con padding responsive: `px-4 sm:px-6 lg:px-8 xl:px-10`

---

## 5. Componentes

### Botones
- **Primario** (`.btn-primary`): Fondo acento, texto blanco, sombra sutil
- **Secundario** (`.btn-outline-secondary`): Borde, texto secundario
- **Estados**: Hover con `translateY(-1px)`, focus-visible con outline 2px

### Tarjetas
- **Base** (`.card`): `rounded-2xl`, `border`, `shadow-sm`
- **Hover** (`.card-hover`): `translateY(-4px)`, sombra media

### Inputs
- **Base** (`.input-base`): `rounded-xl`, borde, focus con ring primario

---

## 6. Animaciones

### Transiciones
- **Rápida**: 150ms
- **Base**: 200ms
- **Lenta**: 300ms
- **Easing**: `cubic-bezier(0.16, 1, 0.3, 1)` (ease-out-expo)

### Microinteracciones
- Botones: `scale(1.02)` hover, `scale(0.98)` tap
- Tarjetas: `translateY(-4px)` hover
- Imágenes: `scale(1.05)` hover en cards

### Reducir movimiento
- `@media (prefers-reduced-motion: reduce)` desactiva animaciones

---

## 7. Accesibilidad (WCAG 2.1)

- **Contraste**: Mínimo 4.5:1 para texto normal
- **Focus visible**: Outline 2px en `:focus-visible`
- **Skip link**: "Saltar al contenido principal" para navegación por teclado
- **Labels**: Todos los inputs con `id` y `htmlFor` asociados
- **Roles**: `role="alert"` en mensajes de error, `aria-label` en iconos decorativos

---

## 8. Responsive

### Breakpoints (Tailwind)
- `sm`: 640px
- `md`: 768px
- `lg`: 1024px
- `xl`: 1280px
- `2xl`: 1536px

### Patrones
- Grid: `grid-cols-1 sm:grid-cols-2 lg:grid-cols-3`
- Hero: `min-h-[85vh] sm:min-h-[90vh]`
- Navbar: Menú hamburguesa en móvil, barra completa en desktop

---

## 9. Dark Mode

Variables CSS adaptadas en `.dark`:
- Fondos más oscuros
- Texto claro
- Bordes con opacidad invertida
