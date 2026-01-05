import { drizzle } from "drizzle-orm/postgres-js";
import postgres from "postgres";
import * as schema from "./schema";

let db: ReturnType<typeof drizzle<typeof schema>> | null = null;

export function createDb(connectionString?: string) {
  if (db) return db;

  // Build connection string from environment if not provided
  const connString =
    connectionString ||
    process.env.DATABASE_URL ||
    buildConnectionString();

  if (!connString) {
    throw new Error("No database connection string available");
  }

  const client = postgres(connString, {
    max: 10,
    idle_timeout: 20,
    connect_timeout: 10,
  });

  db = drizzle(client, { schema });
  return db;
}

function buildConnectionString(): string | undefined {
  const host = process.env.DATABASE_HOST;
  const user = process.env.DATABASE_USERNAME;
  const password = process.env.DATABASE_PASSWORD;
  const name = process.env.DATABASE_NAME || "able";

  if (!host || !user || !password) return undefined;

  return `postgresql://${user}:${encodeURIComponent(password)}@${host}:5432/${name}?sslmode=require`;
}

export * from "./schema";
export type Database = ReturnType<typeof createDb>;
