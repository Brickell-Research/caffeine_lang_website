// Shared utilities for Caffeine playground pages (Cafe + Tour)
import { compile_from_strings } from './caffeine-browser.js';

export function debounce(fn, delay) {
  let timeoutId;
  return (...args) => {
    clearTimeout(timeoutId);
    timeoutId = setTimeout(() => fn(...args), delay);
  };
}

export function compile(measurementsText, expectationsText, configPath) {
  const result = compile_from_strings(
    measurementsText,
    expectationsText,
    configPath,
    "datadog"
  );

  if (result.isOk()) {
    return result[0].terraform;
  } else {
    throw new Error(result[0].msg);
  }
}

export function setupCompileOutput(outputDisplay, getMeasurements, getExpectations, configPath) {
  function runCompile() {
    // Skip compilation if editors are disabled (tour mode)
    const outputPanel = outputDisplay.closest('.tour-output-panel');
    if (outputPanel && outputPanel.classList.contains('editors-disabled')) {
      return;
    }

    const outputCode = outputDisplay.querySelector('code') || outputDisplay;

    try {
      const result = compile(getMeasurements(), getExpectations(), configPath, "datadog");

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

  return runCompile;
}
