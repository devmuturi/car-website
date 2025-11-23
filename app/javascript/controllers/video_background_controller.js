import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["video", "fallback"]

  connect() {
    if (this.hasVideoTarget) {
      this.videoTarget.play().catch(() => {
        // If autoplay fails, show fallback
        if (this.hasFallbackTarget) {
          this.fallbackTarget.classList.remove("hidden")
        }
      })
    }
  }

  disconnect() {
    if (this.hasVideoTarget) {
      this.videoTarget.pause()
    }
  }
}

