import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="highlight"
export default class extends Controller {
  static targets = [ "code" ]

  connect() {
  }

  copy() {
    const text = this.codeTarget.textContent
    navigator.clipboard.writeText(text)
  }
}
