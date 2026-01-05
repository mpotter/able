import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "Able | Accelerating AI Automation",
  description:
    "Able helps companies discover, prioritize, and deliver AI automation opportunities with our Optic platform and expert consulting.",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body className="bg-white text-neutral-900 antialiased">{children}</body>
    </html>
  );
}
