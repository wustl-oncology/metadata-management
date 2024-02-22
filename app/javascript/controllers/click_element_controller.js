import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["click"];

  connect() {}

  click() {
    this.clickTargets.forEach((target) => target.click());
  }
}
