import { NextResponse } from "next/server";
import type { NextRequest } from "next/server";

export function middleware(request: NextRequest) {
  const sessionToken = request.cookies.get("edunexa_session_token")?.value;
  const userRole = request.cookies.get("edunexa_role")?.value?.toUpperCase();
  const { pathname } = request.nextUrl;

  const isProtectedRoute =
    pathname.startsWith("/admin") ||
    pathname.startsWith("/faculty") ||
    pathname.startsWith("/student");

  // 1. Strict Protection for Dashboard Routes
  if (isProtectedRoute) {
    // If unauthenticated, redirect immediately to login with anti-cache headers
    if (!sessionToken || sessionToken.trim() === "" || sessionToken === "null") {
      const loginUrl = new URL("/login", request.url);
      loginUrl.searchParams.set("redirect", pathname);
      const redirectResponse = NextResponse.redirect(loginUrl);

      // Enforce strict anti-caching so protected pages can never be restored
      redirectResponse.headers.set(
        "Cache-Control",
        "no-store, no-cache, must-revalidate, proxy-revalidate, max-age=0"
      );
      redirectResponse.headers.set("Pragma", "no-cache");
      redirectResponse.headers.set("Expires", "0");
      return redirectResponse;
    }

    // 2. Role-Based Access Control (RBAC) Guard
    if (pathname.startsWith("/admin") && userRole && userRole !== "ADMIN") {
      const dest = userRole === "FACULTY" ? "/faculty/dashboard" : "/student/dashboard";
      return NextResponse.redirect(new URL(dest, request.url));
    }

    if (pathname.startsWith("/faculty") && userRole && userRole !== "FACULTY") {
      const dest = userRole === "ADMIN" ? "/admin/dashboard" : "/student/dashboard";
      return NextResponse.redirect(new URL(dest, request.url));
    }

    if (pathname.startsWith("/student") && userRole && userRole !== "STUDENT") {
      const dest = userRole === "ADMIN" ? "/admin/dashboard" : "/faculty/dashboard";
      return NextResponse.redirect(new URL(dest, request.url));
    }

    // 3. Attach strict cache prevention headers to all authenticated responses
    const response = NextResponse.next();
    response.headers.set(
      "Cache-Control",
      "no-store, no-cache, must-revalidate, proxy-revalidate, max-age=0"
    );
    response.headers.set("Pragma", "no-cache");
    response.headers.set("Expires", "0");
    return response;
  }

  // 4. Redirect Authenticated Users from Login Page to Their Respective Dashboard
  if (pathname === "/login" && sessionToken && sessionToken.trim() !== "" && sessionToken !== "null") {
    let target = "/admin/dashboard";
    if (userRole === "FACULTY") target = "/faculty/dashboard";
    else if (userRole === "STUDENT") target = "/student/dashboard";

    return NextResponse.redirect(new URL(target, request.url));
  }

  return NextResponse.next();
}

export const config = {
  matcher: [
    "/admin/:path*",
    "/faculty/:path*",
    "/student/:path*",
    "/login",
  ],
};
