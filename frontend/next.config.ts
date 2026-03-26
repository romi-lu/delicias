import type { NextConfig } from "next";

// En Docker / Railway: BACKEND_URL (p. ej. https://api.tudominio.com o http://api:6002)
const API_BASE = (process.env.BACKEND_URL ?? "http://localhost:6002").replace(
  /\/$/,
  "",
);

function uploadsRemotePattern(): {
  protocol: "http" | "https";
  hostname: string;
  port?: string;
  pathname: string;
} | null {
  try {
    const u = new URL(API_BASE);
    const protocol = u.protocol.replace(":", "") as "http" | "https";
    const entry: {
      protocol: typeof protocol;
      hostname: string;
      port?: string;
      pathname: string;
    } = {
      protocol,
      hostname: u.hostname,
      pathname: "/uploads/**",
    };
    if (u.port) entry.port = u.port;
    return entry;
  } catch {
    return null;
  }
}

const uploadsPattern = uploadsRemotePattern();

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
      ...(uploadsPattern ? [uploadsPattern] : []),
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
