import { defineConfig, globalIgnores } from 'eslint/config';
import nextVitals from 'eslint-config-next/core-web-vitals';
import nextTypescript from 'eslint-config-next/typescript';

export default defineConfig([
  ...nextVitals,
  ...nextTypescript,
  {
    files: ['src/**/*.{ts,tsx}'],
    rules: { '@typescript-eslint/no-explicit-any': 'error' },
  },
  {
    files: ['src/**/*.tsx'],
    rules: {
      'max-lines': [
        'error',
        { max: 70, skipBlankLines: false, skipComments: false },
      ],
    },
  },
  {
    files: ['src/app/**/page.tsx'],
    rules: {
      'no-restricted-syntax': [
        'error',
        {
          selector: 'JSXOpeningElement[name.type="JSXIdentifier"][name.name=/^[a-z]/]',
          message: 'Mova o HTML de page.tsx para um componente da rota.',
        },
        {
          selector: 'JSXOpeningElement[name.type="JSXNamespacedName"]',
          message: 'Mova os elementos com namespace para um componente da rota.',
        },
      ],
    },
  },
  globalIgnores(['.next/**', 'next-env.d.ts']),
]);
