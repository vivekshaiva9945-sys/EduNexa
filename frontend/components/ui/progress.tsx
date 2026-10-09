"use client";

import * as React from "react";
import { cn } from "@/lib/utils";

interface ProgressProps extends React.HTMLAttributes<HTMLDivElement> {
  value?: number;
  indicatorColor?: string;
}

export const Progress: React.FC<ProgressProps> = ({
  className,
  value = 0,
  indicatorColor = "bg-blue-600",
  ...props
}) => {
  const percentage = Math.min(Math.max(value, 0), 100);

  return (
    <div
      className={cn(
        "relative h-2.5 w-full overflow-hidden rounded-full bg-slate-100 dark:bg-slate-800",
        className
      )}
      {...props}
    >
      <div
        className={cn("h-full transition-all duration-500 ease-out", indicatorColor)}
        style={{ width: `${percentage}%` }}
      />
    </div>
  );
};
