// app/javascript/controllers/your_custom_controller.js
import { Controller } from "stimulus";

export default class extends Controller {
  connect() {
    console.log("Stimulus controller connected!");
  }

  handleClick() {
    alert("You clicked the button!");
  }
}
/* import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["question", "options", "summary"];
  
  connect() {
    this.loadScenario(1);
    this.selectedChoices = [];
  }

  async loadScenario(id) {
    const response = await fetch("/decision_tree");
    this.scenarios = await response.json();
    
    const scenario = this.scenarios.find(s => s.id === id);
    
    if (scenario) {
      this.questionTarget.textContent = scenario.question;
      this.optionsTarget.innerHTML = "";
      scenario.options.forEach(option => {
        let button = document.createElement("button");
        button.textContent = option.text;
        button.classList.add("btn", "btn-primary", "m-2");
        button.addEventListener("click", () => this.handleChoice(option, id));
        this.optionsTarget.appendChild(button);
      });
    } else {
      this.showSummary();
    }
  }

  handleChoice(option, previousId) {
    this.selectedChoices.push({ questionId: previousId, choice: option });
    
    if (option.next_id === "end") {
      this.showSummary();
    } else {
      this.loadScenario(option.next_id);
    }
  }

  showSummary() {
    this.questionTarget.textContent = "Your Investigation Results";
    this.optionsTarget.innerHTML = "";
    this.selectedChoices.forEach(choice => {
      let explanation = document.createElement("p");
      explanation.textContent = `Choice: "${choice.choice.text}" - ${choice.choice.explanation}`;
      this.optionsTarget.appendChild(explanation);
    });
  }
} */
