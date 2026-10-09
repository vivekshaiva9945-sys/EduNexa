// lib/queryClient.ts
import { QueryClient } from "@tanstack/react-query";

export const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 1000 * 60 * 3, // Data remains fresh for 3 minutes
      gcTime: 1000 * 60 * 15, // Unused data garbage-collected after 15 minutes
      refetchOnWindowFocus: true, // Auto-revalidate when switching back to tab
      retry: (failureCount, error: any) => {
        // Do not retry 401 Unauthorized or 403 Forbidden errors
        if (error?.response?.status === 401 || error?.response?.status === 403) return false;
        return failureCount < 2;
      },
    },
  },
});
