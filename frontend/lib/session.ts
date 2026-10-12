// lib/session.ts
import { MockUser } from "./mockData";

export const SESSION_COOKIE_KEY = "edunexa_session_token";
export const ROLE_COOKIE_KEY = "edunexa_role";
export const TENANT_COOKIE_KEY = "edunexa_tenant_id";

export const LOCAL_STORAGE_TOKEN = "edunexa_token";
export const LOCAL_STORAGE_USER = "edunexa_user";
export const LOCAL_STORAGE_TENANT = "edunexa_tenant_id";

/**
 * Cookie helper to set secure cookies accessible to both client and Next.js Edge Middleware
 */
export function setCookie(name: string, value: string, maxAgeSeconds: number = 86400) {
  if (typeof document === "undefined") return;
  const isSecure = typeof window !== "undefined" && window.location.protocol === "https:";
  const secureFlag = isSecure ? "; Secure" : "";
  document.cookie = `${name}=${encodeURIComponent(value)}; path=/; max-age=${maxAgeSeconds}; SameSite=Lax${secureFlag}`;
}

/**
 * Cookie helper to delete a cookie by expiring it in the past
 */
export function deleteCookie(name: string) {
  if (typeof document === "undefined") return;
  document.cookie = `${name}=; path=/; max-age=0; expires=Thu, 01 Jan 1970 00:00:00 GMT; SameSite=Lax`;
}

/**
 * Read cookie value by name synchronously in the browser
 */
export function getCookie(name: string): string | null {
  if (typeof document === "undefined") return null;
  const matches = document.cookie.match(new RegExp(`(?:^|; )${name.replace(/([.$?*|{}()[\]\\/+^])/g, "\\$1")}=([^;]*)`));
  return matches ? decodeURIComponent(matches[1]) : null;
}

/**
 * Store user authentication session across both Cookies and localStorage
 */
export function setAuthSession(token: string, user: MockUser) {
  if (typeof window === "undefined") return;

  // Set Cookies for Next.js Middleware route guards
  setCookie(SESSION_COOKIE_KEY, token, 86400); // 24 hours
  setCookie(ROLE_COOKIE_KEY, user.role, 86400);
  if (user.college_id) {
    setCookie(TENANT_COOKIE_KEY, user.college_id, 86400);
  }

  // Set LocalStorage for API Client Authorization header injection
  localStorage.setItem(LOCAL_STORAGE_TOKEN, token);
  localStorage.setItem(LOCAL_STORAGE_USER, JSON.stringify(user));
  if (user.college_id) {
    localStorage.setItem(LOCAL_STORAGE_TENANT, user.college_id);
  }
}

/**
 * Completely purge user authentication session from all client storage mechanisms
 */
export function clearAuthSession() {
  if (typeof window === "undefined") return;

  // Clear Cookies
  deleteCookie(SESSION_COOKIE_KEY);
  deleteCookie(ROLE_COOKIE_KEY);
  deleteCookie(TENANT_COOKIE_KEY);

  // Clear LocalStorage
  localStorage.removeItem(LOCAL_STORAGE_TOKEN);
  localStorage.removeItem(LOCAL_STORAGE_USER);
  localStorage.removeItem(LOCAL_STORAGE_TENANT);

  // Clear SessionStorage & Cache markers
  try {
    sessionStorage.clear();
  } catch {
    // Ignore sandbox errors
  }
}

/**
 * Synchronous check to verify whether an active authentication session exists
 */
export function isSessionActive(): boolean {
  if (typeof window === "undefined") return false;

  const cookieToken = getCookie(SESSION_COOKIE_KEY);
  const localToken = localStorage.getItem(LOCAL_STORAGE_TOKEN);

  const activeToken = cookieToken || localToken;
  if (!activeToken) return false;

  // Ensure token is not an empty or revoked stub
  if (activeToken === "undefined" || activeToken === "null" || activeToken.trim() === "") {
    return false;
  }

  return true;
}

/**
 * Retrieve current active session token
 */
export function getSessionToken(): string | null {
  if (typeof window === "undefined") return null;
  return getCookie(SESSION_COOKIE_KEY) || localStorage.getItem(LOCAL_STORAGE_TOKEN);
}

/**
 * Retrieve current user role
 */
export function getSessionRole(): string | null {
  if (typeof window === "undefined") return null;
  return getCookie(ROLE_COOKIE_KEY);
}
