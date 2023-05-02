import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="closeable"
export default class extends Controller {

  static values  = {
    exitClass: String
  }

  close() {
    if(this.hasExitClassValue) {
      this.element.classList.add(this.exitClassValue);
      this.element.addEventListener('animationend', () => {
        this.removeElement()
      });
    } else {
      this.removeElement()
    }
  }

  removeElement() {
    this.element.parentElement.removeAttribute("src")
    this.element.remove();
  }

  handleKeyup(e) {
    if (e.code == "Escape") {
      this.close()
    }
  }
}

