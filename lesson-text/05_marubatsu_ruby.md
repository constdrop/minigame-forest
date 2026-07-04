# 05. 【実践3】まるばつゲームを作ろう（Ruby・対コンピュータ）

ここでは、**Ruby (Opal)** を使用して、コンピュータと対戦する「まるばつゲーム（三目並べ）」を作ります。
配列や条件分岐を活用して、ゲームのルール（勝敗判定）と簡単なコンピュータのAI（自動で打つ処理）をプログラミングしましょう！

---

## 🏗️ Step1：盤面を描画し、基本設定を作る

`marubatsu.rb` を作成し、以下のコードを書きます。

```ruby
# marubatsu.rb
require 'opal'
require 'native'

# 盤面（9マス）の状態を保存する配列
$board = Array.new(9, nil)
$game_over = false
$message = "あなたの番です（○）"

# 勝利する並び順のパターン（インデックス）
WIN_PATTERNS = [
  [0, 1, 2], [3, 4, 5], [6, 7, 8], # 横の列
  [0, 3, 6], [1, 4, 7], [2, 5, 8], # 縦の列
  [0, 4, 8], [2, 4, 6]             # 斜めの列
]

# 盤面の描画処理
def render_board
  ui = $$.document.getElementById('marubatsu-ui')
  return if ui.nil?

  # 3x3のテーブル（表）を作る
  html = "<table border='1' style='border-collapse: collapse; font-size: 30px; margin: 0 auto;'>"
  3.times do |row|
    html += "<tr>"
    3.times do |col|
      idx = row * 3 + col
      val = $board[idx] || " "
      
      # マスがクリックされたら、Rubyのmark(idx)関数を呼び出す
      html += "<td style='width: 60px; height: 60px; text-align: center; cursor: pointer;' onclick='Opal.Object.$mark(#{idx})'>#{val}</td>"
    end
    html += "</tr>"
  end
  html += "</table>"
  html += "<p><strong>#{$message}</strong></p>"
  
  # ゲームオーバーのときはリセットボタンを表示する
  if $game_over
    html += "<button onclick='Opal.Object.$reset_game()'>もう一度遊ぶ</button>"
  end
  
  ui.innerHTML = html
end

# 最初に画面を描画しておく
render_board
```

---

## 🧠 Step2：プレイヤーが打った後にコンピュータが自動で打つ

次に、クリックしたときにプレイヤーの印（○）をつけ、その後にコンピュータが自動で印（×）をつける処理を追加します。

```ruby
# プレイヤーがマスをクリックしたときの処理
def mark(idx)
  # ゲーム終了後、またはすでに埋まっているマスは何もしない
  return if $game_over || $board[idx]

  # 1. プレイヤー（○）が打つ
  $board[idx] = "○"
  
  # 勝敗判定
  if check_winner("○")
    $message = "あなたの勝ち！🎉"
    $game_over = true
    render_board
    return
  elsif board_full?
    $message = "引き分けです！"
    $game_over = true
    render_board
    return
  end

  # 2. コンピュータ（×）が自動で打つ
  computer_move

  # 勝敗判定
  if check_winner("×")
    $message = "コンピュータの勝ち...😢"
    $game_over = true
  elsif board_full?
    $message = "引き分けです！"
    $game_over = true
  else
    $message = "あなたの番です（○）"
  end

  # 画面を更新する
  render_board
end

# コンピュータの打鍵処理
def computer_move
  # 空いているマスのインデックスを探す
  empty_indices = []
  $board.each_with_index do |val, idx|
    empty_indices << idx if val.nil?
  end

  # 空いているマスがあれば、ランダムに1つ選んで「×」を置く
  if empty_indices.any?
    chosen_idx = empty_indices.sample
    $board[chosen_idx] = "×"
  end
end
```

---

## 🏆 Step3：勝敗と引き分けを判定する

最後に、勝敗判定（3つ揃ったか）と、引き分け判定（全部埋まったか）、およびリセット処理を追加します。

```ruby
# 指定したプレイヤー（"○" または "×"）が勝利したか判定する
def check_winner(player)
  WIN_PATTERNS.any? do |pattern|
    # パターン（例：[0,1,2]）のすべてのマスが指定したプレイヤーの印かチェック
    pattern.all? { |idx| $board[idx] == player }
  end
end

# 盤面がすべて埋まっているか判定する
def board_full?
  $board.all? { |val| !val.nil? }
end

# ゲームのリセット（初期化）
def reset_game
  $board = Array.new(9, nil)
  $game_over = false
  $message = "あなたの番です（○）"
  render_board
end
```

---

## ✅ チェックポイント
* [ ] マスをクリックすると、自分のマーク「○」が表示され、その直後にコンピュータのマーク「×」が自動的に表示されますか？
* [ ] 縦・横・斜めのいずれかに「○」が3つ揃ったときに「あなたの勝ち！🎉」と表示されますか？
* [ ] 勝敗が決まった後、マスをクリックしてもマークがつかない（ゲームが停止する）ようになっていますか？

---

## 🛠️ つまずきポイント
* **「コンピュータが打たずにフリーズする」**
  * `computer_move` 関数で、`$board.each_with_index` や `empty_indices.sample`（配列からランダムに1個選ぶRubyの便利な機能）が正しく書かれているか確認してください。
* **「テーブルが崩れる」**
  * `render_board` 関数内の `html += ...` で HTML タグの閉じ忘れ（`</td>` や `</tr>`）がないか確認しましょう。

---
[次へ：みかん育成ゲームを作ろう](./06_mikan_ruby.md)
