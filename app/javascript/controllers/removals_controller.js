import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="removals"
export default class extends Controller {
  static targets = [ "times" ]

  connect() {
    let times = 30
    const timer = setInterval(() => {
      this.timesTarget.textContent = `${times -= 1}s`
      if (times == 0) {
        this.remove()
        clearInterval(timer)
      }
    }, 1000)
  }

  remove() {
    this.element.remove()
  }
}
