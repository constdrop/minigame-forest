# 01. 【準備】開発環境を作ろう

この講座では、コードエディタとして **VS Code (Visual Studio Code)** を使用し、モダンなフロントエンドビルドツール **Vite (バイト)** と、Rubyをブラウザで動かすための **Opal (オパール)** を組み合わせて開発環境を構築します。

---

## 💻 0. コードエディタ (VS Code) の準備

プログラムを書くために、Microsoftが提供している無料の人気エディタ **VS Code** を準備します。

### ① VS Code のインストール
1. [VS Code 公式サイト](https://code.visualstudio.com/) にアクセスします。
2. お使いのOS（Windows または macOS）に合わせたインストーラーをダウンロードします。
3. ダウンロードしたファイルをダブルクリックして、画面の指示に従ってインストールを完了させます。

### ② 便利な拡張機能（プラグイン）のインストール
VS Codeの機能を拡張して、日本語化やコードの読みやすさを改善しましょう。
VS Codeの左メニューにある **「拡張機能」アイコン（田の字のようなマーク）** をクリックし、検索窓に以下の名前を入力して **「インストール」** ボタンを押してください。

1. **Japanese Language Pack for VS Code**:
   - VS Codeのメニューなどの表示を日本語にするプラグインです。
2. **Ruby LSP** (または **Ruby**):
   - `.rb`（Rubyファイル）のコードに色をつけて見やすくします。今回のまるばつやみかん開発でとても役立ちます。
3. **Error Lens**:
   - プログラムの書き間違い（エラー）がある場所に、エディタの画面上で直接赤い文字でエラー内容を表示してくれます。タイポ（誤字）にすぐ気づけるため、初心者には特におすすめです。
4. **Prettier - Code formatter**:
   - 保存時にプログラムのインデント（ズレ）やカッコをきれいに自動で揃えてくれます。コードの見た目が崩れてエラーになるのを防ぎます。
5. **Git Graph**:
   - Gitのブランチの枝分かれや合体（マージ）の流れを、VS Code上でカラフルな路線図のように視覚的に表示してくれます。Gitの合体・コンフリクトを学ぶ際に非常に役立ちます。
6. **Path Intellisense**:
   - `main.js` や `index.html` で他のファイルを読み込む際（例：`import './janken.rb'` など）、ファイル名を自動で予測して補完してくれます。タイポによる読み込みエラーを防ぎます。

---

## 📁 1. プロジェクトの作成とインストール

ターミナルを開き、以下の手順でプロジェクトフォルダの作成と初期設定を行います。

### ① フォルダ作成とnpmの初期化
```bash
# プロジェクトフォルダを作成して移動
mkdir mini-game-portal
cd mini-game-portal

# npm（JavaScriptのパッケージ管理）を初期化
npm init -y
```

### ② 必要なnpmパッケージのインストール
Opal を Vite で動かすためのプラグイン `vite-plugin-opal` と `vite`、およびゲームエンジンの `phaser` をインストールします。
```bash
npm install -D vite vite-plugin-opal
npm install phaser
```

### ③ Ruby/Opal環境のセットアップ (Gemfile)
プロジェクトフォルダの直下に `Gemfile` という名前のファイルを作成し、以下の内容を記述します。

```ruby
# Gemfile
source 'https://rubygems.org'

gem 'opal', '>= 1.8.0'
gem 'opal-vite'
```

保存したら、ターミナルで以下のコマンドを実行して Ruby のパッケージをインストールします。（※あらかじめパソコンに Ruby がインストールされている必要があります）
```bash
bundle install
```

---

## 🏗️ 2. フォルダ構成とファイルの準備

プロジェクトフォルダの中身が以下の構成になるように、ファイルを作成してください。

```text
mini-game-portal/
  ├── Gemfile          (Rubyライブラリの設定)
  ├── Gemfile.lock
  ├── package.json
  ├── vite.config.js   (Viteの設定ファイル)
  ├── index.html       (ポータルサイトのメイン画面)
  ├── style.css        (デザイン用ファイル)
  ├── main.js          (すべてのプログラムを合体させるファイル)
  ├── block.js         (ブロックくずし用 - JavaScript)
  ├── janken.rb        (じゃんけん用 - Ruby)
  ├── marubatsu.rb     (まるばつ用 - Ruby)
  └── mikan.rb         (みかん育成用 - Ruby)
```

### ⚙️ Viteの設定ファイルを作る
プロジェクトの直下に `vite.config.js` を作成し、Opalが動くように設定を書き込みます。

```javascript
// vite.config.js
import { defineConfig } from 'vite';
import opal from 'vite-plugin-opal';

export default defineConfig({
  plugins: [
    opal()
  ],
  // GitHub Pagesで公開するためのベースパス設定（後で変更します）
  base: './'
});
```

---

## 🖥️ 3. 土台となる HTML を書く

`index.html` を開き、ポータルサイトの骨組みを書きます。

```html
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>ミニゲームポータル</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <h1>🎮 2人のミニゲームポータル</h1>

    <!-- ゲーム切り替えボタン -->
    <div class="menu">
        <button onclick="showGame('block')">ブロックくずし</button>
        <button onclick="showGame('janken')">じゃんけん</button>
        <button onclick="showGame('marubatsu')">まるばつ</button>
        <button onclick="showGame('mikan')">みかん育成</button>
    </div>

    <hr>

    <!-- 各ゲームが表示されるエリア -->
    <div id="game-area">
        <p>遊びたいゲームを選んでね！</p>
    </div>

    <!-- 全体のエントリーポイント -->
    <script type="module" src="/main.js"></script>

    <script>
        // ゲームエリアの中身を切り替える関数
        function showGame(gameId) {
            // 他のゲームに移る前に、もしPhaserの終了処理（クリーンアップ）があれば実行する
            if (window.destroyBlockGame && typeof window.destroyBlockGame === 'function') {
                window.destroyBlockGame();
            }

            const area = document.getElementById('game-area');
            
            if (gameId === 'block') {
                area.innerHTML = '<h2>ブロックくずし中...</h2><div id="block-ui"></div>';
                if (typeof initBlock === 'function') initBlock(); 
            } else if (gameId === 'janken') {
                area.innerHTML = '<h2>じゃんけん中...</h2><div id="janken-ui"></div>';
                // Opal（Ruby）で実装した関数を呼び出す
                if (Opal && Opal.Object) Opal.Object.$init_janken();
            } else if (gameId === 'marubatsu') {
                area.innerHTML = '<h2>まるばつゲーム中...</h2><div id="marubatsu-ui"></div>';
                // Opal（Ruby）で実装した関数を呼び出す
                if (Opal && Opal.Object) Opal.Object.$render_board();
            } else if (gameId === 'mikan') {
                area.innerHTML = '<h2>みかん育成中...</h2><div id="mikan-ui"></div>';
                // Opal（Ruby）で実装した関数を呼び出す
                if (Opal && Opal.Object) Opal.Object.$render_mikan();
            }
        }
    </script>
</body>
</html>
```

---

## 🛠️ 4. main.js でファイルを連結する

`main.js` は、すべてのゲームプログラムを1つに合体させる役割を持ちます。

```javascript
// main.js
import './style.css';
import './block.js';
import './janken.rb';
import './marubatsu.rb';
import './mikan.rb';

// HTMLのボタン（onclick）からJavaScriptの関数を呼べるようにグローバル登録
window.showGame = showGame; 
```

---

## 🚀 5. 開発サーバーを起動する

以下のコマンドを実行して、ローカル開発サーバーを起動します。

```bash
npx vite
```
表示されたURL（`http://localhost:5173` など）をブラウザで開いてみましょう。

### ✅ チェックポイント
- [ ] ブラウザに「2人のミニゲームポータル」というタイトルと4つのボタンが表示されていますか？
- [ ] ターミナルにエラーメッセージが表示されていませんか？

---
[次へ：じゃんけんゲームを作ろう](./02_janken_ruby.md)

