import { tool } from "ai";
import { z } from "zod";

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

export const knowledgeTool = tool({
  description:
    "Get information about Able, our services, platform (Optic), approach to AI automation, and company beliefs. Use this when users ask about what Able does, our services, pricing approach, or company philosophy.",
  parameters: z.object({
    query: z
      .string()
      .describe("The question or topic the user is asking about"),
  }),
  execute: async ({ query }) => {
    // In a real implementation, this would use vector search/RAG
    // For now, return the full knowledge base
    return {
      content: COMPANY_KNOWLEDGE,
      relevantTo: query,
    };
  },
});
