import type { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.royalvoice.app',
  appName: 'Royal Voice',
  webDir: 'public',
  bundledWebRuntime: false,
  android: { allowMixedContent: false },
};

export default config;
