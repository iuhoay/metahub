import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="removals"
export default class extends Controller {
  static targets = [ "times" ]

  static values = {
    timer: { type: Number, default: 5 }
  }

  connect() {
    const timer = setInterval(() => {
      this.timesTarget.textContent = `${this.timerValue -= 1}s`
      if (this.timerValue == 0) {
        this.remove()
        clearInterval(timer)
      }
    }, 1000)
  }

  remove() {
    this.element.remove()
  }
}
