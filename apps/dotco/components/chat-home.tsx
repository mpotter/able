"use client";

import { useChat } from "@ai-sdk/react";
import { DefaultChatTransport } from "ai";
import { useRef, useEffect, useState, useCallback } from "react";
import { introMessages, introConfig } from "@/content/intro";

const suggestions = [
  "What does Able do?",
  "How can AI help my business?",
  "Tell me about the Optic platform",
  "Schedule a demo",
];

// Simple markdown parser for bold text
function renderMarkdown(text: string) {
  const parts = text.split(/(\*\*[^*]+\*\*)/g);
  return parts.map((part, i) => {
    if (part.startsWith("**") && part.endsWith("**")) {
      return <strong key={i}>{part.slice(2, -2)}</strong>;
    }
    return part;
  });
}

interface IntroMessage {
  id: string;
  content: string;
  isStreaming: boolean;
}

export function ChatHome() {
  const messagesEndRef = useRef<HTMLDivElement>(null);
  const [introState, setIntroState] = useState<IntroMessage[]>([]);
  const [introComplete, setIntroComplete] = useState(false);
  const [introStarted, setIntroStarted] = useState(false);
  const [input, setInput] = useState("");

  const { messages, sendMessage, status } =
    useChat({
      transport: new DefaultChatTransport({ api: "/api/chat" }),
    });

  const isLoading = status === "submitted" || status === "streaming";

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setInput(e.target.value);
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!input.trim()) return;
    sendMessage({ text: input });
    setInput("");
  };

  // Scroll to bottom when messages change
  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: "smooth" });
  }, [messages, introState]);

  // Stream a single message character by character
  const streamMessage = useCallback(
    (fullText: string, messageId: string): Promise<void> => {
      return new Promise((resolve) => {
        let charIndex = 0;

        const interval = setInterval(() => {
          charIndex++;
          const currentText = fullText.slice(0, charIndex);

          setIntroState((prev) =>
            prev.map((msg) =>
              msg.id === messageId
                ? { ...msg, content: currentText, isStreaming: charIndex < fullText.length }
                : msg
            )
          );

          if (charIndex >= fullText.length) {
            clearInterval(interval);
            resolve();
          }
        }, introConfig.charDelay);
      });
    },
    []
  );

  // Start intro sequence after logo animation
  useEffect(() => {
    if (introStarted) return;

    const logoAnimationDuration = 1200; // matches CSS animation
    const startDelay = logoAnimationDuration + introConfig.delayAfterAnimation;

    const timeout = setTimeout(async () => {
      setIntroStarted(true);

      for (let i = 0; i < introMessages.length; i++) {
        const messageId = `intro-${i}`;

        // Add empty message
        setIntroState((prev) => [
          ...prev,
          { id: messageId, content: "", isStreaming: true },
        ]);

        // Stream the message
        await streamMessage(introMessages[i], messageId);

        // Wait before next message (except for last one)
        if (i < introMessages.length - 1) {
          await new Promise((r) => setTimeout(r, introConfig.messageDelay));
        }
      }

      setIntroComplete(true);
    }, startDelay);

    return () => clearTimeout(timeout);
  }, [introStarted, streamMessage]);

  const handleSuggestionClick = (suggestion: string) => {
    sendMessage({ text: suggestion });
  };

  const hasRealMessages = messages.length > 0;
  const showIntro = introState.length > 0;
  const showSuggestions = introComplete && !hasRealMessages;

  return (
    <div className="flex flex-1 flex-col">
      {/* Messages area */}
      <div className="flex-1 overflow-y-auto px-4 pb-4">
        <div className="mx-auto max-w-2xl pt-4">
          {/* Intro messages */}
          {showIntro &&
            introState.map((msg) => (
              <div key={msg.id} className="mb-4 text-left">
                <div className="inline-block max-w-[85%] rounded-2xl bg-neutral-100 px-4 py-2 text-neutral-900 dark:bg-neutral-800 dark:text-white">
                  <p className="whitespace-pre-wrap text-sm">
                    {renderMarkdown(msg.content)}
                    {msg.isStreaming && (
                      <span className="ml-0.5 inline-block h-4 w-0.5 animate-pulse bg-current" />
                    )}
                  </p>
                </div>
              </div>
            ))}

          {/* Suggestions after intro */}
          {showSuggestions && (
            <div className="mt-6 flex flex-wrap justify-center gap-3">
              {suggestions.map((suggestion) => (
                <button
                  key={suggestion}
                  onClick={() => handleSuggestionClick(suggestion)}
                  className="rounded-full border border-neutral-200 px-4 py-2 text-sm text-neutral-600 transition-colors hover:border-neutral-400 hover:text-neutral-900 dark:border-neutral-700 dark:text-neutral-400 dark:hover:border-neutral-500 dark:hover:text-white"
                >
                  {suggestion}
                </button>
              ))}
            </div>
          )}

          {/* Real chat messages */}
          {messages.map((message) => (
            <div
              key={message.id}
              className={`mb-4 ${
                message.role === "user" ? "text-right" : "text-left"
              }`}
            >
              <div
                className={`inline-block max-w-[85%] rounded-2xl px-4 py-2 ${
                  message.role === "user"
                    ? "bg-neutral-900 text-white dark:bg-white dark:text-neutral-900"
                    : "bg-neutral-100 text-neutral-900 dark:bg-neutral-800 dark:text-white"
                }`}
              >
                <p className="whitespace-pre-wrap text-sm">
                  {message.parts
                    ?.filter((part): part is { type: "text"; text: string } => part.type === "text")
                    .map((part) => part.text)
                    .join("")}
                </p>
              </div>
            </div>
          ))}

          {/* Loading indicator */}
          {isLoading && (
            <div className="mb-4 text-left">
              <div className="inline-block rounded-2xl bg-neutral-100 px-4 py-2 dark:bg-neutral-800">
                <div className="flex space-x-1">
                  <div className="h-2 w-2 animate-bounce rounded-full bg-neutral-400" />
                  <div className="h-2 w-2 animate-bounce rounded-full bg-neutral-400 [animation-delay:0.1s]" />
                  <div className="h-2 w-2 animate-bounce rounded-full bg-neutral-400 [animation-delay:0.2s]" />
                </div>
              </div>
            </div>
          )}

          <div ref={messagesEndRef} />
        </div>
      </div>

      {/* Input */}
      <div className="border-t border-neutral-100 px-4 py-4 dark:border-neutral-800">
        <form onSubmit={handleSubmit} className="mx-auto max-w-2xl">
          <div className="flex gap-2">
            <input
              type="text"
              value={input}
              onChange={handleInputChange}
              placeholder="Type a message..."
              className="flex-1 rounded-xl border border-neutral-200 bg-white px-4 py-3 text-sm focus:border-neutral-400 focus:outline-none dark:border-neutral-700 dark:bg-neutral-800 dark:text-white dark:placeholder-neutral-500 dark:focus:border-neutral-500"
            />
            <button
              type="submit"
              disabled={isLoading || !input.trim()}
              className="rounded-xl bg-neutral-900 px-6 py-3 text-sm text-white transition-colors hover:bg-neutral-800 disabled:opacity-50 dark:bg-white dark:text-neutral-900 dark:hover:bg-neutral-200"
            >
              Send
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}
