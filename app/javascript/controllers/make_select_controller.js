import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modelSelect", "makeSelect"]

  connect() {
    const makeSelect = this.makeSelectTarget || this.element.querySelector('select[name*="[make_id]"]')
    if (makeSelect && makeSelect.value) {
      this.loadModels(makeSelect.value)
    }
  }

  handleChange(event) {
    const makeId = event.target.value
    this.loadModels(makeId)
  }

  async loadModels(makeId) {
    if (!makeId) {
      this.resetModelSelect()
      return
    }

    try {
      if (this.hasModelSelectTarget) {
        this.modelSelectTarget.disabled = true
        this.modelSelectTarget.innerHTML = '<option value="">Loading models...</option>'
      }

      const response = await fetch(`/admin/makes/${makeId}/models`, {
        headers: { "Accept": "application/json" }
      })
      if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`)

      const models = await response.json()

      if (this.hasModelSelectTarget) {
        const currentValue = this.modelSelectTarget.value
        this.modelSelectTarget.innerHTML = '<option value="">Select Model</option>'
        models.forEach(model => {
          const option = document.createElement('option')
          option.value = model.id
          option.textContent = model.name
          if (currentValue == model.id) option.selected = true
          this.modelSelectTarget.appendChild(option)
        })
        this.modelSelectTarget.disabled = false
      }
    } catch (error) {
      console.error("Error fetching models:", error)
      this.modelSelectTarget.innerHTML = '<option value="">Error loading models</option>'
      this.modelSelectTarget.disabled = false
    }
  }

  resetModelSelect() {
    if (this.hasModelSelectTarget) {
      this.modelSelectTarget.innerHTML = '<option value="">Select Model</option>'
      this.modelSelectTarget.disabled = false
    }
  }
}
