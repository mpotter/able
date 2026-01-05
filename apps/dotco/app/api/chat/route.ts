import { anthropic } from "@ai-sdk/anthropic";
import { streamText, tool } from "ai";
import { z } from "zod";
import { createDb, leads } from "@/lib/db";

export const maxDuration = 30;

const systemPrompt = `You are a helpful assistant for Able, a company that accelerates AI automation for businesses.

## Your Role
You help potential customers learn about Able's services and capture their interest for follow-up.

## Guidelines

### Be Helpful and Informative
- Answer questions about Able's services, approach, and the Optic platform
- Use the knowledge tool to get accurate information about the company
- Be conversational but professional

### Capture Leads Naturally
- When someone shows interest, gently ask for their contact information
- Use the captureLeadInfo tool when they provide name and email
- Use the scheduleDemoTool when they express interest in a demo
- Don't be pushy—let the conversation flow naturally

### What You Can Help With
- Explaining what Able does and how we help companies with AI
- Describing the Optic platform and how it works
- Discussing our training programs and consulting services
- Answering questions about our approach to AI automation
- Collecting contact information from interested parties
- Scheduling demo requests

### What You Should Avoid
- Making up specific pricing (direct them to speak with our team)
- Promising specific results or timelines
- Discussing competitor companies
- Sharing internal company information not in the knowledge base

### Tone
- Friendly and approachable
- Knowledgeable but not condescending
- Concise—don't overwhelm with information
- Genuine interest in helping

Remember: Your goal is to be helpful first. If someone just wants information, give it to them. If they seem interested in learning more, that's when you can offer to connect them with our team.`;

const COMPANY_KNOWLEDGE = `
# About Able

Able accelerates AI automation for companies ranging from Series A startups to Fortune 500s.

## What We Do

### Problem 1: Most companies don't know what's possible with AI
We walk you through what's possible and train you how to take advantage. We offer introductory demos and bespoke training programs for teams at all levels—from executives to software engineers—conducted onsite, offsite, or virtually.

### Problem 2: Companies don't know where to start
We map your workflows and baseline their costs to enable AI experimentation and continuous improvement using our proprietary Optic platform.

Optic is an analytics tool that:
1. Maps how work gets done and how it should change given the latest AI capabilities
2. Translates that understanding into AI opportunities prioritized by ROI
3. Continuously measures performance and revises opportunity sets

### Problem 3: Most companies lack capacity to deliver
We use a partnership approach between domain experts across industries (marketing, legal, healthcare, finance) and Able's embedded AI engineers.

## Our Services

### Professional Services
- Platform customization (Optic integration, configuration, training)
- Custom AI application and system development
- Retainers for continuous improvement and maintenance
- Training bootcamps (technical and non-technical, onsite/offsite/virtual)

### Platform Subscriptions
Access to our platforms via hosted cloud or on-premise, including support, maintenance, upgrades, and infrastructure operations.

## Our Beliefs
1. Humans will write a decreasing amount of code over time
2. Within 18 months, less than half of new code will be written by humans
3. Within 5 years, practically no new code will be written by humans
4. The result will be massive change across nearly every industry
5. Effective design, translating requirements, reviewing code, and accepting accountability will be the leading inhibitors
6. Current workflows and tools are unsuited for this reality
7. People and teams will need to work differently with new tools built from the ground up

## Our Mission
We want to shape the future of work to be more human. We believe human capital is better spent on creative and emotionally rewarding efforts.
`;

export async function POST(req: Request) {
  const { messages } = await req.json();

  const db = process.env.DATABASE_URL
    ? createDb(process.env.DATABASE_URL)
    : null;

  const result = streamText({
    model: anthropic("claude-sonnet-4-20250514"),
    system: systemPrompt,
    messages,
    tools: {
      getCompanyInfo: tool({
        description:
          "Get information about Able, our services, platform (Optic), approach to AI automation, and company beliefs.",
        parameters: z.object({
          query: z.string().describe("The topic the user is asking about"),
        }),
        execute: async ({ query }) => ({
          content: COMPANY_KNOWLEDGE,
          relevantTo: query,
        }),
      }),
      captureLeadInfo: tool({
        description:
          "Capture contact information from a potential customer interested in Able's services.",
        parameters: z.object({
          name: z.string().describe("The person's full name"),
          email: z.string().email().describe("The person's email address"),
          company: z.string().optional().describe("The person's company name"),
          interest: z.string().optional().describe("What they're interested in"),
        }),
        execute: async ({ name, email, company, interest }) => {
          if (db) {
            try {
              await db.insert(leads).values({
                name,
                email,
                company: company ?? null,
                interest: interest ?? null,
                source: "chat",
              });
            } catch (error) {
              console.error("Failed to save lead:", error);
            }
          }
          return {
            success: true,
            message: `Thank you, ${name}! We've captured your information and someone from our team will reach out to ${email} soon.`,
          };
        },
      }),
      scheduleDemo: tool({
        description:
          "Express interest in scheduling a demo of Able's services or the Optic platform.",
        parameters: z.object({
          name: z.string().describe("The person's full name"),
          email: z.string().email().describe("The person's email address"),
          company: z.string().optional().describe("The person's company name"),
          preferredTime: z.string().optional().describe("Preferred timing for the demo"),
          focusArea: z.string().optional().describe("What to focus on in the demo"),
        }),
        execute: async ({ name, email, company, preferredTime, focusArea }) => {
          if (db) {
            try {
              await db.insert(leads).values({
                name,
                email,
                company: company ?? null,
                interest: `Demo request: ${focusArea ?? "General"}${preferredTime ? ` (Preferred: ${preferredTime})` : ""}`,
                source: "demo_request",
              });
            } catch (error) {
              console.error("Failed to save demo request:", error);
            }
          }
          return {
            success: true,
            message: `Great, ${name}! We've noted your interest in a demo. Our team will reach out to ${email} to schedule a time.`,
          };
        },
      }),
    },
    maxSteps: 5,
  });

  return result.toDataStreamResponse();
}
