import type { NextConfig } from "next";

const API_BASE = "http://localhost:6002";

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
      {
        protocol: "http",
        hostname: "localhost",
        port: "6002",
        pathname: "/uploads/**",
      },
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
