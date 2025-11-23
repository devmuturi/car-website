import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    speed: { type: Number, default: 0.5 }
  }

  connect() {
    this.handleScroll = this.handleScroll.bind(this)
    window.addEventListener("scroll", this.handleScroll, { passive: true })
    this.handleScroll()
  }

  disconnect() {
    window.removeEventListener("scroll", this.handleScroll)
  }

  handleScroll() {
    const scrolled = window.pageYOffset
    const rate = scrolled * this.speedValue
    if (this.element) {
      this.element.style.transform = `translateY(${rate}px)`
    }
  }
}

