import { HomePage } from '@/components/home/home-page';
import { isApiReady } from '@/lib/api/health';

export default async function Page() {
  return <HomePage apiReady={await isApiReady()} />;
}
