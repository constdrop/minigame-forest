# 03. 【実践2】ブロックくずしを移植しよう（JavaScript）

ここでは、昨年 **Phaser 3 (フェイザー3)** で作成した「ブロックくずし」のコードを、今回のポータルサイト向けに移植（組み込み）します。

---

## 🛠️ Phaser 3 をポータルに組み込む際の超重要ポイント

ポータルサイトのように、**「ボタンを押してゲーム画面を切り替える」** 仕組みの中で Phaser を動かす場合、非常に重要なルールがあります。

### ⚠️ ゲームインスタンスの破棄（クリーンアップ）
Phaser は `new Phaser.Game()` を実行すると、ゲーム画面（Canvas）や音楽、キーボードの操作イベントなどをメモリ上に作成します。
別のゲーム（じゃんけん等）に切り替えたときに、古いPhaserのデータを消さずに残しておくと、以下の問題が発生します。
1. **画面が重複する**: 再び「ブロックくずし」ボタンを押したときに、ゲーム画面が2個、3個と増えてしまう。
2. **キー入力がバグる**: 別のゲームをしている間も、Phaserがキーボードの操作を横取りしてしまう。
3. **裏で音が鳴り続ける / 重くなる**: メモリを消費し続け、パソコンが重くなる。

これを防ぐために、ゲームを切り替える際には **`game.destroy(true)`** を呼び出して、古いゲームのデータを完全に破棄（クリーンアップ）する必要があります。

---

## 🏗️ Step1：block.js の作成と移植

`block.js` という新しいファイルを作成し、以下のテンプレートコードを参考にしながら、昨年作成したブロックくずしのロジックを中に移植します。

このコードでは、画像ファイルがなくても動くように、プログラム上でボールやパドルの見た目を自動生成（描画）しています。

```javascript
// block.js
import Phaser from 'phaser';

// グローバル変数としてゲームのインスタンスを保持する
let blockGame = null;

// ポータルサイトのボタンから呼び出される初期化関数
window.initBlock = function() {
    // 1. すでに動いているゲームインスタンスがあれば、二重起動を防ぐために破棄する
    if (blockGame) {
        blockGame.destroy(true);
        blockGame = null;
    }

    const ui = document.getElementById('block-ui');
    
    // Phaser用のコンテナ（親要素）を用意する
    ui.innerHTML = `
        <div id="phaser-game-container" style="display: flex; justify-content: center;"></div>
        <p style="text-align: center; margin-top: 10px;">← → キーでパドルを動かしてね！</p>
    `;

    // 2. Phaserの設定
    const config = {
        type: Phaser.AUTO,
        width: 480,
        height: 320,
        parent: 'phaser-game-container', // HTMLのどの要素にゲーム画面を入れるか
        physics: {
            default: 'arcade',
            arcade: {
                gravity: { y: 0 },
                debug: false
            }
        },
        scene: {
            preload: preload,
            create: create,
            update: update
        }
    };

    // 3. ゲームの起動
    blockGame = new Phaser.Game(config);

    // シーン内で使う変数
    let ball;
    let paddle;
    let cursors;

    function preload() {
        // --- 💡 アセット画像を使わずにその場で丸と四角を描くテクニック ---
        // ボール(丸)のテクスチャを生成して「ball」という名前で登録
        let ballCanvas = this.textures.createCanvas('ball', 20, 20);
        let ballCtx = ballCanvas.context;
        ballCtx.fillStyle = '#0095DD';
        ballCtx.beginPath();
        ballCtx.arc(10, 10, 10, 0, Math.PI * 2);
        ballCtx.fill();
        ballCanvas.refresh();

        // パドル(長方形)のテクスチャを生成して「paddle」という名前で登録
        let paddleCanvas = this.textures.createCanvas('paddle', 80, 15);
        let paddleCtx = paddleCanvas.context;
        paddleCtx.fillStyle = '#0095DD';
        paddleCtx.fillRect(0, 0, 80, 15);
        paddleCanvas.refresh();
    }

    function create() {
        // 物理エンジンの境界を設定 (下だけすり抜けるようにしてゲームオーバーを判定)
        this.physics.world.setBoundsCollision(true, true, true, false);

        // ボールの作成
        ball = this.physics.add.image(240, 250, 'ball');
        ball.setCollideWorldBounds(true);
        ball.setBounce(1);
        ball.setVelocity(150, -150); // 初速度 (X方向, Y方向)

        // パドルの作成
        paddle = this.physics.add.image(240, 300, 'paddle');
        paddle.setCollideWorldBounds(true);
        paddle.setImmovable(true); // ボールが当たってもパドル自体は吹き飛ばないように固定

        // ボールとパドルが衝突したときの処理を設定
        this.physics.add.collider(ball, paddle, hitPaddle, null, this);

        // キーボード入力を取得する準備
        cursors = this.input.keyboard.createCursorKeys();
    }

    function update() {
        // パドルの移動操作
        if (cursors.left.isDown) {
            paddle.setVelocityX(-250);
        } else if (cursors.right.isDown) {
            paddle.setVelocityX(250);
        } else {
            paddle.setVelocityX(0);
        }

        // ゲームオーバー判定 (ボールが画面の下（Y=320）より落ちたとき)
        if (ball.y > 320) {
            this.physics.pause();
            ball.setVelocity(0, 0);
            alert('ゲームオーバー！他のゲームに切り替えてから戻ると再開できます。');
        }
    }

    // パドルに当たったときのバウンド角度変更処理
    function hitPaddle(ball, paddle) {
        let diff = 0;
        if (ball.x < paddle.x) {
            diff = paddle.x - ball.x;
            ball.setVelocityX(-5 * diff);
        } else if (ball.x > paddle.x) {
            diff = ball.x - paddle.x;
            ball.setVelocityX(5 * diff);
        } else {
            ball.setVelocityX(2 + Math.random() * 8);
        }
    }
};

// 4. 【ポータル連携用】他のゲームに切り替えたときに、安全にインスタンスを破棄する関数を登録
window.destroyBlockGame = function() {
    if (blockGame) {
        blockGame.destroy(true);
        blockGame = null;
    }
};
```

---

## ✅ チェックポイント
* [ ] ポータルサイトで「ブロックくずし」ボタンを押したとき、ゲーム画面が表示され、ボールが動き始めますか？
* [ ] 左右のキー（← →）でパドルがスムーズに動き、ボールを跳ね返せますか？
* [ ] 他のゲーム（じゃんけん等）に切り替えたあと、再び「ブロックくずし」に戻った際、画面が二重に表示されたりせず、正しくリセットされて起動しますか？

---

## 🛠️ つまずきポイント
* **「Phaser がインポートできないというエラーが出る」**
  * `01_preparation.md` の手順で、`npm install phaser` を実行したか確認してください。
* **「昨年作った画像アセット（`this.load.image` など）をロードさせたい」**
  * Vite では画像をロードする際、`src/assets` などに配置し、JavaScript側で `import imageFile from './assets/ball.png'` のようにインポートしたURLを指定するか、`public` フォルダ直下に配置して絶対パス（`/ball.png`）で読み込ませる必要があります。

---
[次へ：Gitで合体＆コンフリクト体験](./04_git_team.md)
