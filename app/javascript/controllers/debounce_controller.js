import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    // throttle rate in ms
    rate: { type: Number, default: 300 }
  }
  
  submit() {
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
      this.element.requestSubmit()
    }, this.rateValue)
  }
}
