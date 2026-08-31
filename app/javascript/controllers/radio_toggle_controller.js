import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  toggle(event) {
    // クリックされた親要素内のラジオボタンを取得
    const radio = event.currentTarget.querySelector('input[type="radio"]')
    if (!radio) return

    // ブラウザ標準の自動チェック挙動を一旦ストップ
    event.preventDefault()

    if (radio.checked) {
      // すでに選択されていたら解除する
      radio.checked = false
    } else {
      // 未選択だった場合、同じグループの他のラジオボタンをすべて解除してこれを選択
      const form = radio.form || document
      const groupRadios = form.querySelectorAll(`input[type="radio"][name="${radio.name}"]`)
      groupRadios.forEach(r => r.checked = false)
      radio.checked = true
    }

    // CSSの peer-checked や変更検知を発火させる
    radio.dispatchEvent(new Event('change', { bubbles: true }))
  }
}