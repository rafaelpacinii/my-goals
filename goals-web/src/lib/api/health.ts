import 'server-only';
import { z } from 'zod';

const readinessSchema = z.object({ status: z.literal('UP') });

export async function isApiReady(): Promise<boolean> {
  const apiUrl = process.env.API_INTERNAL_URL ?? 'http://localhost:8080';

  try {
    const response = await fetch(new URL('/q/health/ready', apiUrl), {
      cache: 'no-store',
      signal: AbortSignal.timeout(2500),
    });

    return response.ok && readinessSchema.safeParse(await response.json()).success;
  } catch {
    return false;
  }
}
