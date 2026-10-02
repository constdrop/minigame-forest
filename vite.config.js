import { defineConfig } from 'vite';
import opal from 'vite-plugin-opal';

export default defineConfig({
  plugins: [
    opal({
      includeConcerns: false,
      debug: true
    })
  ],
  // GitHub Pagesで公開するためのベースパス設定（後で変更します）
  base: './'
});
