import { tool } from "ai";
import { z } from "zod";

export const captureLeadTool = tool({
  description:
    "Capture contact information from a potential customer who is interested in learning more about Able's services. Use this when someone provides their name, email, company, or expresses interest in being contacted.",
  parameters: z.object({
    name: z.string().describe("The person's full name"),
    email: z.string().email().describe("The person's email address"),
    company: z.string().optional().describe("The person's company name"),
    interest: z
      .string()
      .optional()
      .describe(
        "What they're interested in (e.g., training, Optic platform, custom development)"
      ),
  }),
  execute: async ({ name, email, company, interest }) => {
    // This will be wired up to the database in the API route
    return {
      success: true,
      message: `Thank you, ${name}! We've captured your information and someone from our team will reach out to ${email} soon.`,
      data: { name, email, company, interest },
    };
  },
});

export const scheduleDemoTool = tool({
  description:
    "Express interest in scheduling a demo of Able's services or the Optic platform. Use this when someone wants to see a demo or learn more through a live presentation.",
  parameters: z.object({
    name: z.string().describe("The person's full name"),
    email: z.string().email().describe("The person's email address"),
    company: z.string().optional().describe("The person's company name"),
    preferredTime: z
      .string()
      .optional()
      .describe("Any preferred timing for the demo"),
    focusArea: z
      .string()
      .optional()
      .describe(
        "What they want to focus on in the demo (e.g., Optic, training, specific use case)"
      ),
  }),
  execute: async ({ name, email, company, preferredTime, focusArea }) => {
    return {
      success: true,
      message: `Great, ${name}! We've noted your interest in a demo. Our team will reach out to ${email} to schedule a time that works for you.`,
      data: { name, email, company, preferredTime, focusArea },
    };
  },
});
