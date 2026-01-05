import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "Able | Accelerating AI Automation",
  description:
    "Able helps companies discover, prioritize, and deliver AI automation opportunities with our Optic platform and expert consulting.",
  icons: {
    icon: [
      {
        url: "/a-black.png",
        media: "(prefers-color-scheme: light)",
      },
      {
        url: "/a-white.png",
        media: "(prefers-color-scheme: dark)",
      },
    ],
  },
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body className="bg-white text-neutral-900 antialiased dark:bg-neutral-900 dark:text-white">
        {children}
      </body>
    </html>
  );
}
