import type { NextConfig } from "next";

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
  reactCompiler: true,
  async rewrites() {
    return [
      { source: "/api/:path*", destination: `${API_BASE}/api/:path*` },
      { source: "/uploads/:path*", destination: `${API_BASE}/uploads/:path*` },
    ];
  },
  images: {
    qualities: [80],
    remotePatterns: [
      ...(uploadsPattern ? [uploadsPattern] : []),
      {
        protocol: "https",
        hostname: "images.unsplash.com",
        pathname: "/**",
      },
      {
        protocol: "https",
        hostname: "via.placeholder.com",
        pathname: "/**",
      },
    ],
  },
};

export default nextConfig;
