# 06. 【実践4】みかん育成ゲームを作ろう（Ruby）

ここでは、**Ruby (Opal)** を使用して、みかんを育てる育成シミュレーションゲームを作ります。
「水分」や「栄養」のバランスによって、みかんの運命（結末）が変わるマルチエンディング仕様にします。

---

## 🏗️ Step1：みかんの状態を決める

`mikan.rb` というファイルを作成し、以下のコードを書きましょう。

```ruby
# mikan.rb
require 'opal'
require 'native'

# みかんの状態（グローバル変数で管理）
$mikan_age = 0      # 成長度
$mikan_water = 5    # 水分
$mikan_food = 5     # 栄養
$mikan_message = "苗木を植えました。育ててね！"

# 画面を描く関数
def render_mikan
  ui = $$.document.getElementById('mikan-ui')
  return if ui.nil?

  # 成長度に合わせて見た目（絵文字）を変える
  mikan_icon = "🌱"
  mikan_icon = "🌿" if $mikan_age > 5
  mikan_icon = "🌳" if $mikan_age > 10
  mikan_icon = "🍊" if $mikan_age > 15

  # HTMLを組み立てて流し込む
  ui.innerHTML = "
    <div style='font-size: 50px;'>#{mikan_icon}</div>
    <p>成長度: #{$mikan_age} | 水分: #{$mikan_water} | 栄養: #{$mikan_food}</p>
    <p><strong>#{$mikan_message}</strong></p>
    <button onclick='Opal.Object.$give_water()'>水をあげる</button>
    <button onclick='Opal.Object.$give_food()'>肥料をあげる</button>
  "
end

# 最初に画面を描画しておく
render_mikan
```

---

## 🧠 Step2：お世話する機能と条件分岐を作る

次に、ボタンを押したときの処理（お世話）と、状態変化によるゲームオーバー判定などを追加します。

```ruby
# 水をあげる処理
def give_water
  $mikan_water += 2
  $mikan_age += 1
  $mikan_food -= 1 # 水をあげると栄養が少し薄まる
  check_status("水をあげたよ！")
end

# 肥料をあげる処理
def give_food
  $mikan_food += 2
  $mikan_age += 1
  $mikan_water -= 1 # 肥料をあげると喉が渇く
  check_status("肥料をあげたよ！")
end

# 状態をチェックする処理
def check_status(action_msg)
  # 水のあげすぎ判定
  if $mikan_water > 10
    $mikan_message = "水が多すぎて根腐れしちゃった...😢"
    $mikan_age = 0
    $mikan_water = 5
    $mikan_food = 5
  # 肥料のあげすぎ判定
  elsif $mikan_food > 10
    $mikan_message = "肥料が多すぎて枯れちゃった...🍂"
    $mikan_age = 0
    $mikan_water = 5
    $mikan_food = 5
  # クリア判定
  elsif $mikan_age >= 20
    $mikan_message = "立派なみかんが実ったよ！おめでとう！🍊✨"
  # 通常のお世話メッセージ
  else
    $mikan_message = action_msg
  end

  # 画面を書き直す
  render_mikan
end
```

---

## ✅ チェックポイント
* [ ] 「水をあげる」「肥料をあげる」ボタンを押したとき、成長度や水分などの数値が変わりますか？
* [ ] 成長度が上がるにつれて、見た目が苗木（🌱）からみかん（🍊）に変わりますか？
* [ ] 水や肥料をあげすぎて `10` を超えたとき、ちゃんと枯れて初期状態に戻りますか？

---

## 🛠️ つまずきポイント
* **「文字が表示されなくなって画面が真っ白になる」**
  * `ui.innerHTML = " ... "` 内で、ダブルクォーテーションの閉じ忘れがないか確認しましょう。また、表示したい文字の中にダブルクォーテーションを使いたい場合は、シングルクォーテーション `'` を使うように書き分けてください。

---
[次へ：見た目を整えて世界に公開！](./07_finish.md)
