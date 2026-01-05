import { ChatWidget } from "@able/ui/chat";

export default function Home() {
  return (
    <main className="min-h-screen">
      {/* Hero */}
      <section className="mx-auto max-w-4xl px-6 py-24">
        <h1 className="text-5xl font-medium tracking-tight">
          Accelerating AI Automation
        </h1>
        <p className="mt-6 text-xl text-neutral-600">
          We help companies discover what's possible with AI, identify where to
          start, and deliver results that matter.
        </p>
        <div className="mt-8 flex gap-4">
          <a
            href="#contact"
            className="rounded-lg bg-neutral-900 px-6 py-3 text-white transition-colors hover:bg-neutral-800"
          >
            Get Started
          </a>
          <a
            href="#services"
            className="rounded-lg border border-neutral-200 px-6 py-3 transition-colors hover:bg-neutral-50"
          >
            Learn More
          </a>
        </div>
      </section>

      {/* Problem/Solution */}
      <section id="services" className="border-t border-neutral-100 bg-neutral-50 py-24">
        <div className="mx-auto max-w-4xl px-6">
          <h2 className="text-3xl font-medium">What We Do</h2>
          <div className="mt-12 grid gap-12 md:grid-cols-3">
            <div>
              <div className="text-sm font-medium text-neutral-400">01</div>
              <h3 className="mt-2 text-xl font-medium">Discover</h3>
              <p className="mt-3 text-neutral-600">
                Most companies don't know what's possible with AI. We walk you
                through the possibilities and train your team.
              </p>
            </div>
            <div>
              <div className="text-sm font-medium text-neutral-400">02</div>
              <h3 className="mt-2 text-xl font-medium">Prioritize</h3>
              <p className="mt-3 text-neutral-600">
                We map your workflows and baseline costs using Optic, our
                proprietary platform for identifying AI opportunities.
              </p>
            </div>
            <div>
              <div className="text-sm font-medium text-neutral-400">03</div>
              <h3 className="mt-2 text-xl font-medium">Deliver</h3>
              <p className="mt-3 text-neutral-600">
                We design, develop, and maintain AI systems with embedded
                engineers who work alongside your domain experts.
              </p>
            </div>
          </div>
        </div>
      </section>

      {/* Optic */}
      <section className="border-t border-neutral-100 py-24">
        <div className="mx-auto max-w-4xl px-6">
          <div className="text-sm font-medium text-neutral-400">
            The Optic Platform
          </div>
          <h2 className="mt-2 text-3xl font-medium">
            AI opportunity identification, prioritized by ROI
          </h2>
          <p className="mt-6 text-lg text-neutral-600">
            As many as 95% of AI projects fail to deliver a positive ROI. The
            reason is rarely the technology—it's that AI is dropped into systems
            built for human-centric work.
          </p>
          <div className="mt-8 grid gap-6 md:grid-cols-3">
            <div className="rounded-lg border border-neutral-200 p-6">
              <h3 className="font-medium">Process Mapping</h3>
              <p className="mt-2 text-sm text-neutral-600">
                Map how work gets done and how it should change given the latest
                AI capabilities.
              </p>
            </div>
            <div className="rounded-lg border border-neutral-200 p-6">
              <h3 className="font-medium">ROI Tracking</h3>
              <p className="mt-2 text-sm text-neutral-600">
                Translate understanding into AI opportunities prioritized by
                return on investment.
              </p>
            </div>
            <div className="rounded-lg border border-neutral-200 p-6">
              <h3 className="font-medium">Continuous Improvement</h3>
              <p className="mt-2 text-sm text-neutral-600">
                Measure performance and revise opportunity sets as capabilities
                evolve.
              </p>
            </div>
          </div>
        </div>
      </section>

      {/* Beliefs */}
      <section className="border-t border-neutral-100 bg-neutral-50 py-24">
        <div className="mx-auto max-w-4xl px-6">
          <h2 className="text-3xl font-medium">What We Believe</h2>
          <div className="mt-8 space-y-4 text-neutral-600">
            <p>
              We're technologists eager to shape the future of work. We believe
              human capital is better spent on creative and emotionally
              rewarding efforts.
            </p>
            <p>
              Within 18 months, less than half of new code will be written by
              humans. Within 5 years, practically none. The result will be
              massive change across nearly every industry.
            </p>
            <p>
              Current workflows and tools are unsuited for this reality. People
              and teams will need to work differently, with new tools built from
              the ground up.
            </p>
          </div>
        </div>
      </section>

      {/* Contact */}
      <section id="contact" className="border-t border-neutral-100 py-24">
        <div className="mx-auto max-w-4xl px-6">
          <h2 className="text-3xl font-medium">Get in Touch</h2>
          <p className="mt-4 text-neutral-600">
            Ready to accelerate AI automation? Start a conversation using the
            chat widget or reach out directly.
          </p>
          <div className="mt-8 text-neutral-600">
            <p>
              Use the chat widget in the bottom right to learn more about our
              services and schedule a demo.
            </p>
          </div>
        </div>
      </section>

      {/* Footer */}
      <footer className="border-t border-neutral-100 py-12">
        <div className="mx-auto max-w-4xl px-6">
          <div className="text-sm text-neutral-400">
            © {new Date().getFullYear()} Able. All rights reserved.
          </div>
        </div>
      </footer>

      {/* Chat Widget */}
      <ChatWidget />
    </main>
  );
}
