// Tour of Caffeine - Interactive language tour with CodeMirror
import { createCaffeineEditor, getContent, setContent } from './caffeine-editor.js';
import { debounce, setupCompileOutput } from './caffeine-shared.js';
import { marked } from 'https://esm.sh/marked@15';

// ─── Lesson Definitions ─────────────────────────────────────────────────────
// Each lesson maps to a folder in /tour/{id}/ containing:
//   - lesson.html (body content)
//   - blueprints.caffeine (left editor)
//   - expectations.caffeine (right editor)

const lessonFolders = [
  { id: '01-welcome', title: 'Welcome to Caffeine' },
  { id: '02-blueprints', title: 'Blueprints: Reusable Templates' },
  { id: '03-type-system', title: 'The Type System' },
  { id: '04-interpolation', title: 'String Interpolation' },
  { id: '05-putting-it-together', title: 'Putting It All Together' },
];

// ─── Lesson Loading ─────────────────────────────────────────────────────────

async function fetchLesson(folder) {
  const [bodyMd, blueprints, expectations] = await Promise.all([
    fetch(`/tour/${folder.id}/lesson.md`).then(r => r.text()),
    fetch(`/tour/${folder.id}/blueprints.caffeine`).then(r => r.text()),
    fetch(`/tour/${folder.id}/expectations.caffeine`).then(r => r.text()),
  ]);
  return {
    title: folder.title,
    body: marked.parse(bodyMd),
    blueprints,
    expectations,
  };
}

// Cache loaded lessons to avoid re-fetching
const lessonCache = new Map();

async function getLesson(index) {
  const folder = lessonFolders[index];
  if (!lessonCache.has(folder.id)) {
    lessonCache.set(folder.id, await fetchLesson(folder));
  }
  return lessonCache.get(folder.id);
}

// ─── State ──────────────────────────────────────────────────────────────────

let currentLesson = 0;

const saved = localStorage.getItem('caffeine-tour-lesson');
if (saved !== null) {
  const parsed = parseInt(saved, 10);
  if (!isNaN(parsed) && parsed >= 0 && parsed < lessonFolders.length) {
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
  async function loadLesson(index) {
    const lesson = await getLesson(index);
    currentLesson = index;

    localStorage.setItem('caffeine-tour-lesson', index.toString());

    lessonTitle.textContent = lesson.title;
    lessonBody.innerHTML = lesson.body;

    setContent(blueprintsEditor, lesson.blueprints);
    setContent(expectationsEditor, lesson.expectations);

    const progress = ((index + 1) / lessonFolders.length) * 100;
    progressFill.style.width = progress + '%';
    progressText.textContent = `${index + 1} / ${lessonFolders.length}`;

    btnPrev.disabled = index === 0;
    btnNext.textContent = index === lessonFolders.length - 1 ? 'Back Home >' : 'Next >';

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
    if (currentLesson < lessonFolders.length - 1) {
      loadLesson(currentLesson + 1);
    } else {
      localStorage.removeItem('caffeine-tour-lesson');
      window.location.href = '/';
    }
  });

  // Table of contents
  function buildToc() {
    tocList.innerHTML = '';
    lessonFolders.forEach((folder, i) => {
      const li = document.createElement('li');
      const btn = document.createElement('button');
      btn.className = 'tour-toc-item' + (i === currentLesson ? ' active' : '');
      btn.textContent = `${i + 1}. ${folder.title}`;
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
      if (currentLesson < lessonFolders.length - 1) {
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
    if (!isNaN(lessonNum) && lessonNum >= 1 && lessonNum <= lessonFolders.length) {
      currentLesson = lessonNum - 1;
    }
  }

  loadLesson(currentLesson);
}

// ES modules are deferred by default, so DOM is ready
init();
