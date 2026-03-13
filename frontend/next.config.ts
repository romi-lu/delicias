import type { NextConfig } from "next";

// Backend NestJS en puerto 6002 (ver backend/.env)
const API_BASE = "http://localhost:6002";

const nextConfig: NextConfig = {
  eslint: { ignoreDuringBuilds: true },
  typescript: { ignoreBuildErrors: true },
  async rewrites() {
    return [
      {
        source: "/api/:path*",
        destination: `${API_BASE}/api/:path*`,
      },
      {
        source: "/uploads/:path*",
        destination: `${API_BASE}/uploads/:path*`,
      },
    ];
  },
  images: {
    formats: ["image/avif", "image/webp"],
    deviceSizes: [640, 750, 828, 1080, 1200, 1920, 2048],
    imageSizes: [16, 32, 48, 64, 96, 128, 256],
    qualities: [75, 80, 85, 90],
    remotePatterns: [
      {
        protocol: "http",
        hostname: "localhost",
        port: "6002",
        pathname: "/uploads/**",
      },
      // Permitir imágenes de Unsplash usadas como fallback en productos
      {
        protocol: "https",
        hostname: "images.unsplash.com",
        pathname: "/**",
      },
      // Permitir placeholders remotos si existen en datos (p.ej. via.placeholder.com)
      {
        protocol: "https",
        hostname: "via.placeholder.com",
        pathname: "/**",
      },
    ],
  },
};

export default nextConfig;
