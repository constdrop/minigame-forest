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
