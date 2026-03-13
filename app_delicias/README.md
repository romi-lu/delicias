# Delicias - App Móvil

Aplicación móvil Flutter para Delicias Bakery. Permite realizar pedidos, seguimiento en tiempo real, gestión de perfil y más.

## Requisitos

- Flutter 3.9+
- Backend Delicias ejecutándose en `http://localhost:6002`

## Configuración

1. Asegúrate de que el backend esté corriendo:
   ```bash
   cd ../backend && npm run start:dev
   ```

2. Para dispositivos físicos o emuladores con IP diferente, edita `lib/config/api_config.dart` y cambia `baseUrl` a la IP de tu máquina (ej: `http://192.168.1.10:6002/api`).

## Ejecutar

```bash
flutter pub get
flutter run
```

## Estructura

- `lib/config/` - Configuración API
- `lib/core/theme/` - Tema corporativo
- `lib/models/` - Modelos de datos
- `lib/providers/` - Estado (Provider)
- `lib/screens/` - Pantallas
- `lib/services/` - Servicios API
- `lib/routes/` - Navegación (go_router)

## Funcionalidades

- **Autenticación**: Login, registro, admin
- **Productos**: Catálogo, categorías, detalle
- **Carrito**: Añadir, modificar, checkout
- **Pedidos**: Historial, detalle, seguimiento de estados
- **Perfil**: Datos de usuario, cerrar sesión
- **Ayuda**: Información y FAQ
- **Panel Admin**: Acceso a gestión (completo en web)

## Integración

La app consume la API REST del backend en `/api`. Los datos de usuarios, productos y pedidos se sincronizan con la base de datos compartida (PostgreSQL/Supabase).
