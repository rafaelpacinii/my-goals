import { Card, CardContent } from '@/components/ui/card';

export function HomePage({ apiReady }: { apiReady: boolean }) {
  return (
    <main className="mx-auto flex min-h-dvh w-full max-w-2xl flex-col justify-center px-6 py-12">
      <h1 className="text-4xl font-semibold tracking-tight">My Goals</h1>
      <p className="mt-4 text-lg text-muted-foreground">
        Plataforma de gestão de metas e objetivos.
      </p>
      <Card className="mt-8 py-4">
        <CardContent className="px-4">
          <p>{apiReady ? 'API disponível' : 'API indisponível'}</p>
        </CardContent>
      </Card>
    </main>
  );
}
