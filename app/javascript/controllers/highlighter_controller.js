import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  //id of selected item
  //selector for all selectable items
  static values = {
    selectedItem: String,
    itemSelector: String
  };

  static classes = ['highlight'];
  
  connect() {
    this.allItems.forEach(item => item.classList.remove(...this.highlightClasses))
    if(this.selectedItem) {
      this.selectedItem.classList.add(...this.highlightClasses);
    }
    this.element.remove();
  }

  get selectedItem() {
    return document.getElementById(this.selectedItemValue);
  }

  get allItems() {
    return new Array(...this.element.querySelectorAll(this.itemSelectorValue));
  }
}
