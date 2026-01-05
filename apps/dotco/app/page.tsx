import { ChatHome } from "@/components/chat-home";

export default function Home() {
  return (
    <main className="flex min-h-screen flex-col items-center">
      {/* Logo */}
      <div className="pt-16 pb-8">
        <img
          src="/a-black.png"
          alt="Able"
          className="h-16 animate-logo-reveal dark:hidden"
        />
        <img
          src="/a-white.png"
          alt="Able"
          className="hidden h-16 animate-logo-reveal dark:block"
        />
      </div>

      {/* Chat */}
      <ChatHome />
    </main>
  );
}
