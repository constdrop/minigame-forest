# 02. 【実践1】じゃんけんゲームを作ろう（Ruby）

ここでは、**Ruby (Opal)** を使って、ブラウザで動く「じゃんけんゲーム」を作ります。
JavaScript ではなく Ruby でブラウザのHTMLを操作する方法を学びましょう！

---

## 🏗️ Step1：じゃんけんゲームのクラスと画面初期化を作る

`janken.rb` を作成し、クラス `JankenGame` と画面を初期化する `init` メソッドを書きます。

```ruby
# janken.rb
require 'opal'

class JankenGame
  # じゃんけん画面の初期化
  def init
    %x{
      var ui = document.getElementById('janken-ui');
      if (ui) {
        ui.innerHTML = `
          <p>出す手を選んでね：</p>
          <button onclick="window.playJanken(0)">✊ グー</button>
          <button onclick="window.playJanken(1)">✌ チョキ</button>
          <button onclick="window.playJanken(2)">🖐 パー</button>
          <div id="janken-result"></div>
        `;
      }
    }
  end
end
```

### 💡 OpalでHTMLを操作するコツ
* **`%x{ ... }`**: Rubyの中に直接 JavaScript のコードを埋め込んで安全に実行できる便利機能です（インラインJavaScript）。

---

## 🧠 Step2：勝敗を決めるロジックと関数の公開

次に、同じ `janken.rb` 内に勝敗を決める `play` メソッドを追加し、JavaScript側に安全に呼び出せるよう関数を登録します。

```ruby
# janken.rb
require 'opal'

class JankenGame
  # じゃんけん画面の初期化
  def init
    %x{
      var ui = document.getElementById('janken-ui');
      if (ui) {
        ui.innerHTML = `
          <p>出す手を選んでね：</p>
          <button onclick="window.playJanken(0)">✊ グー</button>
          <button onclick="window.playJanken(1)">✌ チョキ</button>
          <button onclick="window.playJanken(2)">🖐 パー</button>
          <div id="janken-result"></div>
        `;
      }
    }
  end

  # 勝敗の判定と結果表示
  def play(player_hand)
    hands = ['グー', 'チョキ', 'パー']
    computer_hand = rand(3)

    result = if player_hand == computer_hand
               'あいこ！'
             elsif (player_hand == 0 && computer_hand == 1) ||
                   (player_hand == 1 && computer_hand == 2) ||
                   (player_hand == 2 && computer_hand == 0)
               'あなたの勝ち！✨'
             else
               'コンピューターの勝ち...😢'
             end

    result_text = "
      <hr>
      <p>あなた：#{hands[player_hand]}</p>
      <p>相手：#{hands[computer_hand]}</p>
      <h3>結果：#{result}</h3>
    "

    %x{
      var resultArea = document.getElementById('janken-result');
      if (resultArea) {
        resultArea.innerHTML = #{result_text};
      }
    }
  end
end

# じゃんけんゲームのインスタンスを作成
game = JankenGame.new

# 💡 JavaScriptのwindowオブジェクトに関数を安全に登録する
%x{
  window.initJanken = function() {
    #{game}.$init();
  };
  window.playJanken = function(hand) {
    #{game}.$play(hand);
  };
}
```

### 💡 RubyメソッドをJavaScriptから呼ぶコツ
* Opalでは、RubyクラスのメソッドはJavaScriptに変換される際、メソッド名の先頭に `$` が付きます（例: `init` メソッド ➡️ `$init()`）。
* `#{game}.$init()` や `#{game}.$play(hand)` のように JavaScript関数定義の中で呼び出すことで、画面のボタンクリック時やゲーム切り替え時に安全にRubyの処理が実行されます。

---

## ✅ チェックポイント
* [ ] ポータルサイトで「じゃんけん」ボタンを押したとき、グー・チョキ・パーのボタンが表示されますか？
* [ ] ボタンを押したとき、自分と相手の手、そして勝敗が正しく表示されますか？
* [ ] 何回か遊んでみて、相手の手がランダムに変わりますか？

---

## 🛠️ つまずきポイント
* **「Opal Compiler Output Parse Error が出る」**
  * `janken.rb` 内で `def` や `class` に対応する `end` や引用符 `"` の閉じ忘れなどの文法エラーがないか確認してください。ターミナルで `ruby -c janken.rb` を実行すると文法をチェックできます。
* **「ボタンを押しても反応しない」**
  * `main.js` で `import './janken.rb';` を忘れていないか確認しましょう。

---
[次へ：ブロックくずしを移植しよう](./03_block_js.md)
