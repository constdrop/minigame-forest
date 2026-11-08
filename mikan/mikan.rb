# mikan.rb (全体コード)
require 'opal'

class MikanGame
  def initialize
    reset
  end

  def reset
    @age = 0      # 成長度
    @water = 5    # 水分
    @food = 5     # 栄養
    @message = "苗木を植えました。育ててね！"
    render
  end

  def render
    %x{
      var ui = document.getElementById('mikan-ui');
      if (!ui) return;
    }

    icon = "🌱"
    icon = "🌿" if @age > 5
    icon = "🌳" if @age > 10
    icon = "🍊" if @age > 15

    html = "
      <div style='font-size: 50px;'>#{icon}</div>
      <p>成長度: #{@age} | 水分: #{@water} | 栄養: #{@food}</p>
      <p><strong>#{@message}</strong></p>
      <button onclick='window.giveMikanWater()'>水をあげる</button>
      <button onclick='window.giveMikanFood()'>肥料をあげる</button>
    "

    if @age >= 20 || @water > 10 || @food > 10
      html += "<br><button onclick='window.resetMikan()'>もう一度育てる</button>"
    end

    %x{
      var ui = document.getElementById('mikan-ui');
      if (ui) ui.innerHTML = #{html};
    }
  end

  # 水をあげる処理
  def give_water
    return if @age >= 20 || @water > 10 || @food > 10

    @water += 1
    @age += 1
    @food -= 1 # 水をあげると栄養が少し薄まる
    check_status("水をあげたよ！")
  end

  # 肥料をあげる処理
  def give_food
    return if @age >= 20 || @water > 10 || @food > 10

    @food += 1
    @age += 1
    @water -= 1 # 肥料をあげると喉が渇く
    check_status("肥料をあげたよ！")
  end

  # 状態をチェックする処理
  def check_status(action_msg)
    # 水のあげすぎ判定
    if @water > 10
      @message = "水が多すぎて根腐れしちゃった...😢"
    # 肥料のあげすぎ判定
    elsif @food > 10
      @message = "肥料が多すぎて枯れちゃった...🍂"
    # クリア判定
    elsif @age >= 20
      @message = "立派なみかんが実ったよ！おめでとう！🍊✨"
    # 通常のお世話メッセージ
    else
      @message = action_msg
    end

    # 画面を書き直す
    render
  end
end

# インスタンス生成
game = MikanGame.new

# 💡 JavaScriptのwindowオブジェクトに関数を安全に登録する
%x{
  window.initMikan = function() {
    #{game}.$reset();
  };
  window.giveMikanWater = function() {
    #{game}.$give_water();
  };
  window.giveMikanFood = function() {
    #{game}.$give_food();
  };
  window.resetMikan = function() {
    #{game}.$reset();
  };
}