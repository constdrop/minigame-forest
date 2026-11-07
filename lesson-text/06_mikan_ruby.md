# 06. 【実践4】みかん育成ゲームを作ろう（Ruby）

ここでは、**Ruby (Opal)** を使用して、みかんを育てる育成シミュレーションゲームを作ります。
「水分」や「栄養」のバランスによって、みかんの運命（結末）が変わるマルチエンディング仕様にします。

---

## 🏗️ Step1：みかんの状態を決めるクラスを作る

`mikan.rb` というファイルを作成し、`MikanGame` クラスと画面描画の処理を書きましょう。

```ruby
# mikan.rb
require 'opal'

class MikanGame
  def initialize
    reset
  end

  # ゲームのリセット（初期化）
  def reset
    @age = 0      # 成長度
    @water = 5    # 水分
    @food = 5     # 栄養
    @message = "苗木を植えました。育ててね！"
    render
  end

  # 画面を描くメソッド
  def render
    %x{
      var ui = document.getElementById('mikan-ui');
      if (!ui) return;
    }

    # 成長度に合わせて見た目（絵文字）を変える
    icon = "🌱"
    icon = "🌿" if @age > 5
    icon = "🌳" if @age > 10
    icon = "🍊" if @age > 15

    # HTMLを組み立てる
    html = "
      <div style='font-size: 50px;'>#{icon}</div>
      <p>成長度: #{@age} | 水分: #{@water} | 栄養: #{@food}</p>
      <p><strong>#{@message}</strong></p>
      <button onclick='window.giveMikanWater()'>水をあげる</button>
      <button onclick='window.giveMikanFood()'>肥料をあげる</button>
    "

    # ゲーム終了条件を満たしたら「もう一度育てる」ボタンを追加
    if @age >= 20 || @water > 10 || @food > 10
      html += "<br><button onclick='window.resetMikan()'>もう一度育てる</button>"
    end

    %x{
      var ui = document.getElementById('mikan-ui');
      if (ui) ui.innerHTML = #{html};
    }
  end
end
```

---

## 🧠 Step2：お世話する機能と条件分岐・関数登録（全体コード）

次に、ボタンを押したときの処理（お世話）と状態変化の判定を追加し、インスタンスの生成と JavaScript への関数登録を行います。

```ruby
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

    @water += 2
    @age += 1
    @food -= 1 # 水をあげると栄養が少し薄まる
    check_status("水をあげたよ！")
  end

  # 肥料をあげる処理
  def give_food
    return if @age >= 20 || @water > 10 || @food > 10

    @food += 2
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
```

---

## ✅ チェックポイント
* [ ] 「水をあげる」「肥料をあげる」ボタンを押したとき、成長度や水分などの数値が変わりますか？
* [ ] 成長度が上がるにつれて、見た目が苗木（🌱）からみかん（🍊）に変わりますか？
* [ ] 水や肥料をあげすぎて `10` を超えたとき、根腐れや枯れメッセージが表示され、「もう一度育てる」ボタンが表示されますか？

---

## 🛠️ つ持つきポイント
* **「文字が表示されなくなって画面が真っ白になる」**
  * `html = " ... "` 内で、ダブルクォーテーションの閉じ忘れがないか確認しましょう。また、表示したい文字の中にダブルクォーテーションを使いたい場合は、シングルクォーテーション `'` を使うように書き分けてください。

---
[次へ：見た目を整えて世界に公開！](./07_finish.md)
