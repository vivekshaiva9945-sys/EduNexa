"use client";

import React from "react";

interface AnimatedListProps {
  children: React.ReactNode[];
  className?: string;
}

export const AnimatedList: React.FC<AnimatedListProps> = ({ children, className = "" }) => {
  return (
    <div className={`space-y-3 ${className}`}>
      {React.Children.map(children, (child, index) => (
        <div
          key={index}
          className="transition-all duration-300 ease-out transform"
          style={{
            animation: `fadeInUp 0.35s ease-out ${index * 0.06}s both`,
          }}
        >
          {child}
        </div>
      ))}
    </div>
  );
};
