import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "source", "buttonText" ]

  copy() {
    navigator.clipboard.writeText(this.sourceTarget.value) 
    if (this.hasButtonTextTarget) {
      const existingText = this.buttonTextTarget.innerHTML
      this.buttonTextTarget.innerHTML = "Copied!"
      setTimeout(() => {
        this.buttonTextTarget.innerHTML = existingText
      }, 500);
    }
  }
}
