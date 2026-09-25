import { cpSync, existsSync, mkdirSync, rmSync } from 'node:fs';
import { join } from 'node:path';
rmSync('dist', { recursive: true, force: true });
mkdirSync('dist', { recursive: true });
for (const file of ['index.html','styles.css','app.js','editor.html','editor.js','admin.html','admin.css','admin.js','README.md']) cpSync(file, join('dist', file));
if (existsSync('assets')) cpSync('assets', join('dist','assets'), { recursive: true });
