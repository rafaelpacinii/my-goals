import { isApiReady } from '@/lib/api/health';

export async function GET() {
  const ready = await isApiReady();

  return Response.json(
    { status: ready ? 'UP' : 'DOWN' },
    { status: ready ? 200 : 503 },
  );
}
