import { loadEnv, defineConfig } from 'vite';
import reactRefresh from '@vitejs/plugin-react-refresh';
import { urbitPlugin } from '@urbit/vite-plugin-urbit';

// https://vitejs.dev/config/
export default ({ mode }) => {
  Object.assign(process.env, loadEnv(mode, process.cwd()));
  const SHIP_URL = process.env.SHIP_URL || process.env.VITE_SHIP_URL || 'http://localhost:8080';
  console.log(SHIP_URL);

  return defineConfig({
    plugins: [urbitPlugin({ base: 'bizbaz', target: SHIP_URL, secure: false }), reactRefresh()],
    build: {
      chunkSizeWarningLimit: 750,
      rollupOptions: {
        onwarn(warning, defaultHandler) {
          if (
            warning.code === "MODULE_LEVEL_DIRECTIVE" &&
            warning.message.includes("use client")
          ) {
            return;
          }
          if (userConfig.build?.rollupOptions?.onwarn) {
            userConfig.build.rollupOptions.onwarn(warning, defaultHandler);
          } else {
            defaultHandler(warning);
          }
        },
      },
    },
  });
};
