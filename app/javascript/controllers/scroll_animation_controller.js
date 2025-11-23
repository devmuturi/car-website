import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["element"]
  static values = {
    threshold: { type: Number, default: 0.1 },
    rootMargin: { type: String, default: "0px 0px -100px 0px" }
  }

  connect() {
    this.observer = new IntersectionObserver(
      this.handleIntersection.bind(this),
      {
        threshold: this.thresholdValue,
        rootMargin: this.rootMarginValue
      }
    )

    this.elementTargets.forEach((element) => {
      this.observer.observe(element)
    })
  }

  disconnect() {
    if (this.observer) {
      this.observer.disconnect()
    }
  }

  handleIntersection(entries) {
    entries.forEach((entry) => {
      if (entry.isIntersecting) {
        entry.target.classList.add("animate-in")
        this.observer.unobserve(entry.target)
      }
    })
  }
}

