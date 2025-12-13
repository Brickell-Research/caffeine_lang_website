// The Cafe JavaScript - Real Caffeine compiler
import { compile_from_strings } from './caffeine-browser.js';

// Example blueprints JSON
const defaultBlueprints = {
  "blueprints": [
    {
      "name": "Availability_SLO",
      "artifact_ref": "SLO",
      "params": {
        "service_name": "String",
        "environment": "String"
      },
      "inputs": {
        "vendor": "datadog",
        "queries": {
          "numerator": "sum:requests.success{$$service_name->service_name$$, $$environment->environment$$}.as_count()",
          "denominator": "sum:requests.total{$$service_name->service_name$$, $$environment->environment$$}.as_count()"
        },
        "value": "numerator / denominator"
      }
    }
  ]
};

// Example expectations JSON
const defaultExpectations = {
  "expectations": [
    {
      "name": "API Gateway Availability",
      "blueprint_ref": "Availability_SLO",
      "inputs": {
        "service_name": "api-gateway",
        "environment": "production",
        "threshold": 99.9,
        "window_in_days": 30
      }
    }
  ]
};

// Debounce helper
function debounce(fn, delay) {
  let timeoutId;
  return (...args) => {
    clearTimeout(timeoutId);
    timeoutId = setTimeout(() => fn(...args), delay);
  };
}

// Create simple textarea editor
function createEditor(containerId, initialContent) {
  const container = document.getElementById(containerId);
  if (!container) return null;

  const textarea = document.createElement('textarea');
  textarea.className = 'editor-textarea';
  textarea.spellcheck = false;
  textarea.value = typeof initialContent === 'string'
    ? initialContent
    : JSON.stringify(initialContent, null, 2);

  container.appendChild(textarea);
  return textarea;
}

// Compile function using real Caffeine compiler
function compile(blueprintsJson, expectationsJson) {
  const result = compile_from_strings(
    blueprintsJson,
    expectationsJson,
    "cafe/demo/service.json"
  );

  if (result.isOk()) {
    return result[0];
  } else {
    throw new Error(result[0]);
  }
}

// Initialize the cafe
function init() {
  const blueprintsEditor = createEditor('blueprints-editor', defaultBlueprints);
  const expectationsEditor = createEditor('expectations-editor', defaultExpectations);
  const outputDisplay = document.getElementById('output-display');

  if (!blueprintsEditor || !expectationsEditor || !outputDisplay) {
    console.error('The Cafe: Missing required elements');
    return;
  }

  // Compile and update output
  function runCompile() {
    const outputCode = outputDisplay.querySelector('code') || outputDisplay;

    try {
      const result = compile(
        blueprintsEditor.value,
        expectationsEditor.value
      );

      outputCode.textContent = result;
      outputCode.className = 'language-hcl';

      if (typeof Prism !== 'undefined') {
        Prism.highlightElement(outputCode);
      }
    } catch (error) {
      outputCode.textContent = `Error: ${error.message}`;
      outputCode.className = 'language-plaintext error-output';
    }
  }

  // Debounced auto-compile (500ms delay)
  const debouncedCompile = debounce(runCompile, 500);

  // Auto-compile on edit
  blueprintsEditor.addEventListener('input', debouncedCompile);
  expectationsEditor.addEventListener('input', debouncedCompile);

  // Initial compile
  runCompile();
}

// ES modules are deferred by default, so DOM is ready
init();
