# 02. 【実践1】じゃんけんゲームを作ろう（Ruby）

ここでは、**Ruby (Opal)** を使って、ブラウザで動く「じゃんけんゲーム」を作ります。
JavaScript ではなく Ruby でブラウザのHTMLを操作する方法を学びましょう！

---

## 🏗️ Step1：画面にボタンを表示する

`janken.rb` を作成し、以下のコードを書きます。

```ruby
# janken.rb
require 'opal'
require 'native'

# じゃんけん画面の初期化
def init_janken
  ui = $$.document.getElementById('janken-ui')
  return if ui.nil?

  # HTMLを流し込んでボタンを作る
  # ボタンがクリックされたら、Rubyのplay_janken関数を呼び出す
  ui.innerHTML = "
    <p>出す手を選んでね：</p>
    <button onclick='Opal.Object.$play_janken(0)'>✊ グー</button>
    <button onclick='Opal.Object.$play_janken(1)'>✌ チョキ</button>
    <button onclick='Opal.Object.$play_janken(2)'>🖐 パー</button>
    <div id='janken-result'></div>
  "
end

# はじめにじゃんけん画面を表示する
init_janken
```

### 💡 OpalでHTMLを操作するコツ
* **`$$`**: JavaScriptのグローバルオブジェクト（`window` や `document` など）にアクセスするための特別な書き方です。
* **`Opal.Object.$play_janken(0)`**: JavaScript（HTMLの `onclick`）から、Rubyで書いた `play_janken` 関数を呼び出すためのOpalのルールです。関数の前に `$` がつく点に注目してください。

---

## 🧠 Step2：勝敗を決めるロジックを作る

次に、同じ `janken.rb` の下に、勝敗を決める `play_janken` 関数を追加します。

```ruby
# 勝敗の判定と結果表示
def play_janken(player_hand)
  hands = ['グー', 'チョキ', 'パー']
  
  # 0から2までのランダムな数を作る (0:グー, 1:チョキ, 2:パー)
  computer_hand = rand(3)

  # 勝敗の判定
  result = ''
  if player_hand == computer_hand
    result = 'あいこ！'
  elsif (player_hand == 0 && computer_hand == 1) ||
        (player_hand == 1 && computer_hand == 2) ||
        (player_hand == 2 && computer_hand == 0)
    result = 'あなたの勝ち！✨'
  else
    result = 'コンピューターの勝ち...😢'
  end

  # 結果を画面に表示する
  result_area = $$.document.getElementById('janken-result')
  return if result_area.nil?

  result_area.innerHTML = "
    <hr>
    <p>あなた：#{hands[player_hand]}</p>
    <p>相手：#{hands[computer_hand]}</p>
    <h3>結果：#{result}</h3>
  "
end
```

---

## ✅ チェックポイント
* [ ] ポータルサイトで「じゃんけん」ボタンを押したとき、グー・チョキ・パーのボタンが表示されますか？
* [ ] ボタンを押したとき、自分と相手の手、そして勝敗が正しく表示されますか？
* [ ] 何回か遊んでみて、相手の手がランダムに変わりますか？

---

## 🛠️ つまずきポイント
* **「ボタンを押しても反応しない」**
  * `index.html` または `janken.rb` で `Opal.Object.$play_janken` のスペルが間違っていないか確認しましょう。
  * `main.js` で `import './janken.rb';` を忘れていないか確認しましょう。
* **「Syntax Error が出る」**
  * Rubyではダブルクォーテーション `"` の中に `#{変数}` を入れることで、変数の中身を文字の中に表示（展開）できます。シングルクォーテーション `'` では展開されないため注意してください。

---
[次へ：ブロックくずしを移植しよう](./03_block_js.md)
