import components/layout
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import version

pub fn view() -> Element(Nil) {
  layout.view(
    "Tour of Caffeine",
    html.div([attribute.class("tour-container")], [
      // Tour header with progress
      html.div([attribute.class("tour-header")], [
        html.div([attribute.class("tour-title-row")], [
          html.h1([], [html.text("Tour of Caffeine")]),
          html.span([attribute.class("version-badge")], [
            html.text(version.latest_version),
          ]),
          html.a(
            [
              attribute.href("https://archive-5-6-0.caffeine-lang.run/tour"),
              attribute.class("archive-link"),
            ],
            [html.text("v5.6.0 archive →")],
          ),
        ]),
        html.div([attribute.class("tour-progress")], [
          html.div([attribute.class("tour-progress-bar")], [
            html.div(
              [
                attribute.id("progress-fill"),
                attribute.class("tour-progress-fill"),
              ],
              [],
            ),
          ]),
          html.span(
            [
              attribute.id("progress-text"),
              attribute.class("tour-progress-text"),
            ],
            [
              html.text("1 / 5"),
            ],
          ),
        ]),
      ]),
      // Main body: left column (content + editors) and right column (output)
      html.div([attribute.class("tour-body")], [
        // Left column
        html.div([attribute.class("tour-left")], [
          // Lesson content
          html.div([attribute.class("tour-lesson")], [
            html.div([attribute.class("tour-lesson-content")], [
              html.h2([attribute.id("lesson-title")], [html.text("Welcome")]),
              html.div(
                [attribute.id("lesson-body"), attribute.class("lesson-body")],
                [
                  html.p([], [html.text("Loading...")]),
                ],
              ),
            ]),
            // Navigation
            html.div([attribute.class("tour-nav")], [
              html.button(
                [
                  attribute.id("btn-prev"),
                  attribute.class("tour-btn tour-btn-prev"),
                ],
                [html.text("< Prev")],
              ),
              html.button(
                [
                  attribute.id("btn-toc"),
                  attribute.class("tour-btn tour-btn-toc"),
                ],
                [html.text("Table of Contents")],
              ),
              html.button(
                [
                  attribute.id("btn-next"),
                  attribute.class("tour-btn tour-btn-next"),
                ],
                [html.text("Next >")],
              ),
            ]),
          ]),
          // Editors (two columns)
          html.div([attribute.class("tour-editors")], [
            html.div([attribute.class("editor-panel tour-editor-panel")], [
              html.div([attribute.class("editor-header")], [
                html.span([attribute.class("editor-label")], [
                  html.text("Measurement"),
                ]),
                html.span([attribute.class("editor-filename")], [
                  html.text("datadog.caffeine"),
                ]),
              ]),
              html.div(
                [
                  attribute.id("tour-measurements-editor"),
                  attribute.class("editor"),
                ],
                [],
              ),
            ]),
            html.div([attribute.class("editor-panel tour-editor-panel")], [
              html.div([attribute.class("editor-header")], [
                html.span([attribute.class("editor-label")], [
                  html.text("Expectation"),
                ]),
                html.span([attribute.class("editor-filename")], [
                  html.text("tour/demo/service.caffeine"),
                ]),
              ]),
              html.div(
                [
                  attribute.id("tour-expectations-editor"),
                  attribute.class("editor"),
                ],
                [],
              ),
            ]),
          ]),
        ]),
        // Right column: Output (full height)
        html.div([attribute.class("output-panel tour-output-panel")], [
          html.div([attribute.class("output-header")], [
            html.span([], [html.text("Output")]),
            html.span([attribute.class("auto-compile-badge")], [
              html.text("auto-compiles"),
            ]),
          ]),
          html.div([attribute.class("output-content")], [
            html.pre(
              [
                attribute.id("tour-output-display"),
                attribute.class("output-code"),
              ],
              [
                html.code([attribute.class("language-hcl")], [
                  html.text("// Output will appear here"),
                ]),
              ],
            ),
          ]),
        ]),
      ]),
      // Table of contents overlay
      html.div(
        [
          attribute.id("toc-overlay"),
          attribute.class("tour-toc-overlay hidden"),
        ],
        [
          html.div([attribute.class("tour-toc")], [
            html.div([attribute.class("tour-toc-header")], [
              html.h3([], [html.text("Table of Contents")]),
              html.button(
                [
                  attribute.id("btn-toc-close"),
                  attribute.class("tour-toc-close"),
                ],
                [html.text("x")],
              ),
            ]),
            html.ul(
              [attribute.id("toc-list"), attribute.class("tour-toc-list")],
              [],
            ),
          ]),
        ],
      ),
      // Load tour JS (ES module)
      html.script([attribute.src("/js/tour.js"), attribute.type_("module")], ""),
    ]),
  )
}
