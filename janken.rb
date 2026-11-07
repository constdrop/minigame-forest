# janken.rb
require 'opal'

class JankenGame
  def init
    # document.getElementById で要素を取得し、確実にボタンを描画する
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

# インスタンス作成
game = JankenGame.new

# JavaScriptの window オブジェクトに関数を登録
%x{
  window.initJanken = function() {
    #{game}.$init();
  };
  window.playJanken = function(hand) {
    #{game}.$play(hand);
  };
}
