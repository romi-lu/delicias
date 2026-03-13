import { NextResponse } from "next/server";
import type { NextRequest } from "next/server";

// Rutas públicas (sin requerir sesión admin)
const PUBLIC_PATHS = ["/login"];
const isPublic = (pathname: string) =>
  PUBLIC_PATHS.some((p) => pathname === p || pathname.startsWith(p + "/"));

// Rutas estáticas / de Next
const isStatic = (pathname: string) =>
  pathname.startsWith("/_next") ||
  pathname.startsWith("/api/") ||
  pathname.startsWith("/uploads/") ||
  pathname.includes(".");

export function middleware(request: NextRequest) {
  const { pathname } = request.nextUrl;

  if (isStatic(pathname)) return NextResponse.next();
  if (isPublic(pathname)) return NextResponse.next();

  // Panel: exigir cookie de sesión (AuthContext la establece en login)
  const token = request.cookies.get("token")?.value;
  if (!token) {
    const loginUrl = new URL("/login", request.url);
    loginUrl.searchParams.set("from", pathname);
    return NextResponse.redirect(loginUrl);
  }

  return NextResponse.next();
}

export const config = {
  matcher: ["/((?!_next/static|_next/image|favicon.ico).*)"],
};
