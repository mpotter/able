import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  output: "standalone",
  transpilePackages: ["@able/ui", "@able/ai", "@able/db"],
};

export default nextConfig;
