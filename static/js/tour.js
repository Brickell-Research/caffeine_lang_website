// Tour of Caffeine - Interactive language tour with CodeMirror
import { createCaffeineEditor, getContent, setContent } from './caffeine-editor.js';
import { debounce, setupCompileOutput } from './caffeine-shared.js';

// ─── Lesson Data ────────────────────────────────────────────────────────────

const lessons = [
  {
    title: "Welcome to Caffeine",
    body: `
      <p><strong>Caffeine</strong> is a configuration language for generating reliability infrastructure from simple declarations.</p>
      <p>You write <em>Blueprints</em> (reusable templates) and <em>Expectations</em> (per-service config), and Caffeine compiles them into Terraform.</p>
      <p>This tour will walk you through the language step by step. The editors below are <strong>live</strong> &mdash; try editing them and watch the output update.</p>
      <p class="lesson-hint">Hit <strong>Next</strong> to begin.</p>
    `,
    blueprints: `Blueprints for "SLO"
  * "Simple_SLO":
    Requires { service_name: String }
    Provides {
      vendor: "datadog",
      queries: {
        numerator: "sum:requests.success{service:example}.as_count()",
        denominator: "sum:requests.total{service:example}.as_count()"
      },
      value: "numerator / denominator"
    }
`,
    expectations: `Expectations for "Simple_SLO"
  * "My First SLO":
    Provides {
      service_name: "hello-world",
      threshold: 99.9,
      window_in_days: 30
    }
`,
  },
  {
    title: "Blueprints: Reusable Templates",
    body: `
      <p>A <strong>Blueprint</strong> defines a reusable pattern for a reliability artifact. It starts with:</p>
      <pre class="lesson-code">Blueprints for "ArtifactName"</pre>
      <p>This tells Caffeine which artifact from the standard library you're targeting (currently <code>SLO</code>).</p>
      <p>Each blueprint within the file is declared with a bullet:</p>
      <pre class="lesson-code">  * "Blueprint_Name":
    Requires { ... }
    Provides { ... }</pre>
      <p>The <code>Requires</code> block declares what parameters service owners must provide. The <code>Provides</code> block supplies the artifact's configuration.</p>
      <p class="lesson-hint">Try changing the blueprint name from <code>"Availability_SLO"</code> to something else and watch the output update.</p>
    `,
    blueprints: `Blueprints for "SLO"
  * "Availability_SLO":
    Requires { service_name: String, environment: String }
    Provides {
      vendor: "datadog",
      queries: {
        numerator: "sum:requests.success{service:example}.as_count()",
        denominator: "sum:requests.total{service:example}.as_count()"
      },
      value: "numerator / denominator"
    }
`,
    expectations: `Expectations for "Availability_SLO"
  * "API Gateway Availability":
    Provides {
      service_name: "api-gateway",
      environment: "production",
      threshold: 99.9,
      window_in_days: 30
    }
`,
  },
  {
    title: "The Type System",
    body: `
      <p>Caffeine has a simple but strict type system. The <code>Requires</code> block uses type annotations:</p>
      <pre class="lesson-code">Requires {
  service_name: String,
  environment: String,
  threshold: Float,
  window_in_days: Integer
}</pre>
      <p>Available types:</p>
      <ul class="lesson-list">
        <li><code>String</code> &mdash; text values</li>
        <li><code>Float</code> &mdash; decimal numbers</li>
        <li><code>Integer</code> &mdash; whole numbers</li>
        <li><code>Boolean</code> &mdash; true or false</li>
      </ul>
      <p>The compiler enforces these at compile time. If an expectation provides a String where an Integer is required, you get a clear error.</p>
      <p class="lesson-hint">Try changing <code>threshold: 99.9</code> to <code>threshold: "high"</code> in the expectations to see a type error.</p>
    `,
    blueprints: `Blueprints for "SLO"
  * "Typed_SLO":
    Requires {
      service_name: String,
      threshold: Float,
      window_in_days: Integer
    }
    Provides {
      vendor: "datadog",
      queries: {
        numerator: "sum:requests.success{service:example}.as_count()",
        denominator: "sum:requests.total{service:example}.as_count()"
      },
      value: "numerator / denominator"
    }
`,
    expectations: `Expectations for "Typed_SLO"
  * "Typed Example":
    Provides {
      service_name: "payments",
      threshold: 99.9,
      window_in_days: 30
    }
`,
  },
  {
    title: "String Interpolation",
    body: `
      <p>Blueprints become powerful when you use <strong>string interpolation</strong> to inject parameters into queries.</p>
      <p>The syntax is:</p>
      <pre class="lesson-code">$parameter_name->field_name$</pre>
      <p>This tells Caffeine to substitute the value of <code>field_name</code> from the parameter named <code>parameter_name</code> at compile time.</p>
      <p>In the example below, the queries use <code>$service_name->service_name$</code> to inject the service name into the Datadog query string.</p>
      <p>When the expectation provides <code>service_name: "api-gateway"</code>, the compiled output will contain the literal string <code>api-gateway</code> in the query.</p>
      <p class="lesson-hint">Try changing the <code>service_name</code> value in expectations and observe how it flows into the output.</p>
    `,
    blueprints: `Blueprints for "SLO"
  * "Interpolated_SLO":
    Requires { service_name: String, environment: String }
    Provides {
      vendor: "datadog",
      queries: {
        numerator: "sum:requests.success{$service_name->service_name$, $environment->environment$}.as_count()",
        denominator: "sum:requests.total{$service_name->service_name$, $environment->environment$}.as_count()"
      },
      value: "numerator / denominator"
    }
`,
    expectations: `Expectations for "Interpolated_SLO"
  * "API Gateway Availability":
    Provides {
      service_name: "api-gateway",
      environment: "production",
      threshold: 99.9,
      window_in_days: 30
    }
`,
  },
  {
    title: "Putting It All Together",
    body: `
      <p>Now you've seen the full picture:</p>
      <ol class="lesson-list">
        <li><strong>Blueprints</strong> define reusable patterns with typed parameters</li>
        <li><strong>String interpolation</strong> (<code>$param->field$</code>) makes queries dynamic</li>
        <li><strong>Expectations</strong> provide concrete values per service</li>
        <li>Caffeine <strong>compiles</strong> everything into Terraform HCL</li>
      </ol>
      <p>This means your observability team writes blueprints once, and every service team just fills in their expectations &mdash; no copy-pasting Terraform, no drift.</p>
      <p class="lesson-hint">Experiment freely with the editors below! This is your sandbox.</p>
    `,
    blueprints: `Blueprints for "SLO"
  * "Latency_SLO":
    Requires {
      service_name: String,
      environment: String,
      p99_threshold_seconds: Float
    }
    Provides {
      vendor: "datadog",
      queries: {
        numerator: "sum:trace.requests{$service_name->service_name$, $environment->environment$, duration<$p99_threshold_seconds->p99_threshold_seconds$}.as_count()",
        denominator: "sum:trace.requests{$service_name->service_name$, $environment->environment$}.as_count()"
      },
      value: "numerator / denominator"
    }
`,
    expectations: `Expectations for "Latency_SLO"
  * "Checkout Latency P99":
    Provides {
      service_name: "checkout-service",
      environment: "production",
      p99_threshold_seconds: 2.5,
      threshold: 99.0,
      window_in_days: 30
    }
`,
  },
];

// ─── State ──────────────────────────────────────────────────────────────────

let currentLesson = 0;

const saved = localStorage.getItem('caffeine-tour-lesson');
if (saved !== null) {
  const parsed = parseInt(saved, 10);
  if (!isNaN(parsed) && parsed >= 0 && parsed < lessons.length) {
    currentLesson = parsed;
  }
}

// ─── Scroll Fade ────────────────────────────────────────────────────────────

function setupScrollFade(panel, scroller) {
  if (!panel || !scroller) return () => {};
  function update() {
    const atBottom = scroller.scrollTop + scroller.clientHeight >= scroller.scrollHeight - 5;
    const noOverflow = scroller.scrollHeight <= scroller.clientHeight;
    panel.classList.toggle('scrolled-end', atBottom || noOverflow);
  }
  scroller.addEventListener('scroll', update, { passive: true });
  new MutationObserver(update).observe(scroller, { childList: true, subtree: true, characterData: true });
  setTimeout(update, 100);
  return update;
}

// ─── Tour Logic ─────────────────────────────────────────────────────────────

function init() {
  const outputDisplay = document.getElementById('tour-output-display');
  const lessonTitle = document.getElementById('lesson-title');
  const lessonBody = document.getElementById('lesson-body');
  const progressFill = document.getElementById('progress-fill');
  const progressText = document.getElementById('progress-text');
  const btnPrev = document.getElementById('btn-prev');
  const btnNext = document.getElementById('btn-next');
  const btnToc = document.getElementById('btn-toc');
  const tocOverlay = document.getElementById('toc-overlay');
  const tocList = document.getElementById('toc-list');
  const btnTocClose = document.getElementById('btn-toc-close');

  if (!outputDisplay) {
    console.error('Tour: Missing required elements');
    return;
  }

  // Create CodeMirror editors
  const bpContainer = document.getElementById('tour-blueprints-editor');
  const expContainer = document.getElementById('tour-expectations-editor');

  if (!bpContainer || !expContainer) {
    console.error('Tour: Missing editor containers');
    return;
  }

  let blueprintsEditor, expectationsEditor;

  const runCompile = setupCompileOutput(
    outputDisplay,
    () => getContent(blueprintsEditor),
    () => getContent(expectationsEditor),
    "tour/demo/service.caffeine"
  );

  const debouncedCompile = debounce(runCompile, 500);

  blueprintsEditor = createCaffeineEditor(bpContainer, '', debouncedCompile);
  expectationsEditor = createCaffeineEditor(expContainer, '', debouncedCompile);

  // Scroll fades for lesson panel
  const lessonPanel = document.querySelector('.tour-lesson');
  const lessonContent = document.querySelector('.tour-lesson-content');
  const updateLessonFade = setupScrollFade(lessonPanel, lessonContent);

  // Scroll fades for editor and output panels
  const bpPanel = bpContainer.closest('.tour-editor-panel');
  const expPanel = expContainer.closest('.tour-editor-panel');
  const outPanel = document.querySelector('.tour-output-panel');
  const outScroller = outPanel?.querySelector('.output-content');

  const updateBpFade = setupScrollFade(bpPanel, bpContainer.querySelector('.cm-scroller'));
  const updateExpFade = setupScrollFade(expPanel, expContainer.querySelector('.cm-scroller'));
  const updateOutFade = setupScrollFade(outPanel, outScroller);

  // Load a lesson
  function loadLesson(index) {
    const lesson = lessons[index];
    currentLesson = index;

    localStorage.setItem('caffeine-tour-lesson', index.toString());

    lessonTitle.textContent = lesson.title;
    lessonBody.innerHTML = lesson.body;

    setContent(blueprintsEditor, lesson.blueprints);
    setContent(expectationsEditor, lesson.expectations);

    const progress = ((index + 1) / lessons.length) * 100;
    progressFill.style.width = progress + '%';
    progressText.textContent = `${index + 1} / ${lessons.length}`;

    btnPrev.disabled = index === 0;
    btnNext.textContent = index === lessons.length - 1 ? 'Back Home >' : 'Next >';

    runCompile();

    // Re-check scroll fades after content changes
    setTimeout(() => {
      updateLessonFade();
      updateBpFade();
      updateExpFade();
      updateOutFade();
    }, 50);

    window.location.hash = `#${index + 1}`;
  }

  // Navigation
  btnPrev.addEventListener('click', () => {
    if (currentLesson > 0) {
      loadLesson(currentLesson - 1);
    }
  });

  btnNext.addEventListener('click', () => {
    if (currentLesson < lessons.length - 1) {
      loadLesson(currentLesson + 1);
    } else {
      localStorage.removeItem('caffeine-tour-lesson');
      window.location.href = '/';
    }
  });

  // Table of contents
  function buildToc() {
    tocList.innerHTML = '';
    lessons.forEach((lesson, i) => {
      const li = document.createElement('li');
      const btn = document.createElement('button');
      btn.className = 'tour-toc-item' + (i === currentLesson ? ' active' : '');
      btn.textContent = `${i + 1}. ${lesson.title}`;
      btn.addEventListener('click', () => {
        loadLesson(i);
        tocOverlay.classList.add('hidden');
      });
      li.appendChild(btn);
      tocList.appendChild(li);
    });
  }

  btnToc.addEventListener('click', () => {
    buildToc();
    tocOverlay.classList.remove('hidden');
  });

  btnTocClose.addEventListener('click', () => {
    tocOverlay.classList.add('hidden');
  });

  tocOverlay.addEventListener('click', (e) => {
    if (e.target === tocOverlay) {
      tocOverlay.classList.add('hidden');
    }
  });

  // Keyboard navigation (only when not focused in an editor)
  document.addEventListener('keydown', (e) => {
    const active = document.activeElement;
    const inEditor = active && active.closest('.cm-editor');
    if (inEditor) return;

    if (e.key === 'ArrowRight' || e.key === 'ArrowDown') {
      e.preventDefault();
      if (currentLesson < lessons.length - 1) {
        loadLesson(currentLesson + 1);
      }
    } else if (e.key === 'ArrowLeft' || e.key === 'ArrowUp') {
      e.preventDefault();
      if (currentLesson > 0) {
        loadLesson(currentLesson - 1);
      }
    } else if (e.key === 'Escape') {
      tocOverlay.classList.add('hidden');
    }
  });

  // Check URL hash for direct lesson link
  const hash = window.location.hash;
  if (hash) {
    const lessonNum = parseInt(hash.slice(1), 10);
    if (!isNaN(lessonNum) && lessonNum >= 1 && lessonNum <= lessons.length) {
      currentLesson = lessonNum - 1;
    }
  }

  loadLesson(currentLesson);
}

// ES modules are deferred by default, so DOM is ready
init();
