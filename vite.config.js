import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

// Configuration Vite simplifiée pour éviter les erreurs
export default defineConfig({
  plugins: [react()],
  server: {
    port: 3000,
    host: true
  },
  build: {
    outDir: 'dist',
    sourcemap: false,
    rollupOptions: {
      output: {
        manualChunks: undefined
      }
    }
  }
})
