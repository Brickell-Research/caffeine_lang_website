// Caffeine Editor - Reusable CodeMirror component for Caffeine language
// Shared between the Tour and the Cafe

import { EditorView, keymap } from '@codemirror/view';
import { EditorState } from '@codemirror/state';
import { defaultKeymap, history, historyKeymap } from '@codemirror/commands';
import { StreamLanguage, syntaxHighlighting, defaultHighlightStyle, bracketMatching } from '@codemirror/language';
import { oneDark } from '@codemirror/theme-one-dark';

// ─── Caffeine Language Mode ─────────────────────────────────────────────────

const keywords = new Set([
  'Expectations', 'Unmeasured',
  'Requires', 'Provides',
  'measured', 'by', 'extends', 'in',
]);

const types = new Set([
  'String', 'Integer', 'Float', 'Boolean', 'URL',
  'List', 'Dict', 'Optional', 'Defaulted',
]);

const booleans = new Set(['true', 'false']);

const caffeineLang = StreamLanguage.define({
  token(stream) {
    // Whitespace
    if (stream.eatSpace()) return null;

    // Comments: ## section or # line
    if (stream.match('##')) {
      stream.skipToEnd();
      return 'comment';
    }
    if (stream.match('#')) {
      stream.skipToEnd();
      return 'comment';
    }

    // Strings with template interpolation
    if (stream.match('"')) {
      while (!stream.eol()) {
        if (stream.match('$$')) {
          while (!stream.eol() && !stream.match('$$', true)) {
            stream.next();
          }
          continue;
        }
        if (stream.match('\\"')) continue;
        if (stream.peek() === '"') {
          stream.next();
          return 'string';
        }
        stream.next();
      }
      return 'string';
    }

    // Numbers (float before integer)
    if (stream.match(/-?\d+\.\d+/)) return 'number';
    if (stream.match(/-?\d+/)) return 'number';

    // Range operator
    if (stream.match('..')) return 'operator';

    // Operators
    if (stream.match(/[|=+]/)) return 'operator';

    // Punctuation
    if (stream.match(/[{}()\[\]:,*]/)) return 'punctuation';

    // Words (keywords, types, booleans, identifiers)
    if (stream.match(/[a-zA-Z_][a-zA-Z0-9_]*/)) {
      const word = stream.current();
      if (word.startsWith('_')) return 'variableName.special';
      if (keywords.has(word)) return 'keyword';
      if (types.has(word)) return 'typeName';
      if (booleans.has(word)) return 'bool';
      return 'variableName';
    }

    stream.next();
    return null;
  },
});

// ─── Theme ──────────────────────────────────────────────────────────────────

const caffeineTheme = EditorView.theme({
  '&': {
    fontSize: '13px',
    height: '100%',
  },
  '.cm-content': {
    fontFamily: "'Monaco', 'Courier New', monospace",
    caretColor: '#ff8ed4',
    padding: '8px 0',
  },
  '.cm-cursor': {
    borderLeftColor: '#ff8ed4',
  },
  '&.cm-focused .cm-selectionBackground, .cm-selectionBackground': {
    backgroundColor: '#3a2a1a !important',
  },
  '.cm-gutters': {
    backgroundColor: '#1a1410',
    color: '#8b6f47',
    border: 'none',
    borderRight: '1px solid #8b6f47',
  },
  '.cm-activeLineGutter': {
    backgroundColor: '#2d1810',
  },
  '.cm-activeLine': {
    backgroundColor: '#1a141080',
  },
}, { dark: true });

// ─── Public API ─────────────────────────────────────────────────────────────

/**
 * Create a CodeMirror editor with Caffeine syntax highlighting.
 * @param {HTMLElement} container - DOM element to mount the editor in
 * @param {string} content - Initial editor content
 * @param {function} [onChange] - Callback fired on document changes
 * @returns {EditorView}
 */
export function createCaffeineEditor(container, content, onChange) {
  const extensions = [
    keymap.of([...defaultKeymap, ...historyKeymap]),
    history(),
    bracketMatching(),
    caffeineLang,
    oneDark,
    caffeineTheme,
    syntaxHighlighting(defaultHighlightStyle, { fallback: true }),
    EditorView.lineWrapping,
  ];

  if (onChange) {
    extensions.push(EditorView.updateListener.of((update) => {
      if (update.docChanged) onChange(update);
    }));
  }

  return new EditorView({
    state: EditorState.create({ doc: content, extensions }),
    parent: container,
  });
}

/**
 * Get the full text content of an editor.
 * @param {EditorView} view
 * @returns {string}
 */
export function getContent(view) {
  return view.state.doc.toString();
}

/**
 * Replace the full content of an editor.
 * @param {EditorView} view
 * @param {string} content
 */
export function setContent(view, content) {
  view.dispatch({
    changes: { from: 0, to: view.state.doc.length, insert: content },
  });
}
