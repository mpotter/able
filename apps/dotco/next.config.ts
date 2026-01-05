import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  output: "standalone",
  transpilePackages: ["@able/ui", "@able/ai", "@able/db"],
  // Configure turbopack for monorepo structure
  turbopack: {
    root: "../..",
  },
};

export default nextConfig;
