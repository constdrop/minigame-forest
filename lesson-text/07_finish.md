# 07. 【完成】見た目を整えて世界に公開！

最後の仕上げとして、CSSを使ってサイトのデザインをカッコよくし、インターネット上に公開して誰でも遊べるようにしましょう！

---

## 🎨 1. 見た目を整える (style.css)

`style.css` を開き、以下の内容に書き換えて全体のデザインを整えましょう。

```css
/* style.css */

body {
    background-color: #f0f4f8;
    font-family: 'Helvetica Neue', Arial, 'Hiragino Kaku Gothic ProN', Meiryo, sans-serif;
    text-align: center;
    color: #2c3e50;
    margin: 0;
    padding: 20px;
}

h1 {
    font-size: 2.2rem;
    color: #34495e;
    margin-bottom: 20px;
}

/* メニューボタンのスタイル */
.menu {
    margin-bottom: 30px;
}

button {
    background-color: #3498db;
    color: white;
    border: none;
    padding: 12px 24px;
    font-size: 16px;
    font-weight: bold;
    border-radius: 8px;
    cursor: pointer;
    margin: 6px;
    transition: background-color 0.2s, transform 0.1s;
    box-shadow: 0 4px 6px rgba(50, 50, 93, 0.11);
}

button:hover {
    background-color: #2980b9;
    transform: translateY(-1px);
}

button:active {
    transform: translateY(1px);
}

/* ゲーム表示エリア */
#game-area {
    background-color: white;
    border-radius: 12px;
    padding: 30px;
    margin: 20px auto;
    max-width: 600px;
    min-height: 350px;
    box-shadow: 0 10px 25px rgba(0,0,0,0.05);
    border: 1px solid #e2e8f0;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
}

/* ゲームエリア内のボタンのスタイル調整 */
#game-area button {
    background-color: #e67e22;
}

#game-area button:hover {
    background-color: #d35400;
}
```

---

## 🌐 2. GitHub Pagesで世界に公開する

Viteで作成したプロジェクトを一番簡単にGitHub Pagesで公開するため、`gh-pages` というツールを使います。

### ① デプロイ用ツールのインストール
ターミナルで以下のコマンドを実行します。
```bash
npm install -D gh-pages
```

### ② 設定ファイル (vite.config.js) の変更
GitHub Pagesで公開すると、URLが `https://<ユーザー名>.github.io/<リポジトリ名>/` になります。
画像やプログラムの読み込みパスがずれないように、`vite.config.js` を開き、`base` 設定を**自分のリポジトリ名**に変更します。

```javascript
// vite.config.js
import { defineConfig } from 'vite';
import opal from 'vite-plugin-opal';

export default defineConfig({
  plugins: [
    opal()
  ],
  // baseの値を 「/リポジトリ名/」 に変更します！
  // （例：リポジトリ名が mini-game-portal の場合）
  base: '/mini-game-portal/'
});
```

> [!IMPORTANT]
> `/mini-game-portal/` の部分は、各自のGitHubリポジトリ名に合わせて書き換えてください。前後のスラッシュ `/` を忘れないようにしましょう。

### ③ package.json にコマンドを追加する
`package.json` の `"scripts"` の部分に、デプロイ用のコマンド（`predeploy` と `deploy`）を追記します。

```json
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview",
    "predeploy": "npm run build",
    "deploy": "gh-pages -d dist"
  }
```

### ④ 公開コマンドを実行する
設定が完了したら、ターミナルで以下のコマンドを実行します。
```bash
npm run deploy
```

自動的にビルド（本番用ファイルへの変換）が行われ、GitHubに公開専用のデータがアップロードされます。ターミナルに `Published` と表示されれば成功です！

### ⑤ GitHubの設定を確認する
1. GitHubのリポジトリページを開き、**Settings > Pages** に進みます。
2. Build and deploymentの Source が `Deploy from a branch` になっており、Branch が `gh-pages` に設定されていることを確認します（自動的に設定されているはずです）。
3. ページ上部に表示されるURL（数分後に有効になります）にアクセスして、世界中から遊べることを確認しましょう！

---

## 🎉 おめでとうございます！！

これで、2人が協力して作った「ミニゲーム・ポータルサイト」の完成です！
* **じゃんけん (Ruby/Opal)**
* **ブロックくずし (JavaScript)**
* **まるばつ (Ruby/Opal - 対コンピュータ)**
* **みかん育成 (Ruby/Opal)**

すべてが1つのポータルサイト上で、しかもインターネットを通じて誰でも遊べるようになりました。
Gitを使ったチーム開発の第一歩をクリアしたあなたは、もう立派な開発チームの一員です。

**さらに挑戦してみるなら：**
* 自分で新しいミニゲームを作って、さらに追加してみましょう！
* CSSのデザインや色を自由に変えて、オリジナルのポータルサイトにしてみましょう！

プログラミングとチーム開発の世界へようこそ！これからも楽しんでね！🚀
