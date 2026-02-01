import components/layout
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html

pub fn view() -> Element(Nil) {
  layout.view(
    "Tools",
    html.div([attribute.class("tools-page")], [
      html.section([attribute.class("tools-hero")], [
        html.h1([], [html.text("Tools")]),
        html.p([attribute.class("tagline")], [
          html.text("Everything a barista needs to brew Caffeine"),
        ]),
      ]),
      // Editor Support
      html.section([attribute.class("tools-section")], [
        html.h2([], [html.text("Editor Support")]),
        html.div([attribute.class("tool-card")], [
          html.div([attribute.class("tool-card-header")], [
            html.h3([], [html.text("IDE Extensions")]),
            html.p([], [
              html.text(
                "Enable first-class editor support for Caffeine: syntax highlighting, real-time diagnostics, and language server integration.",
              ),
            ]),
          ]),
          html.div([attribute.class("tool-links")], [
            html.a(
              [
                attribute.href(
                  "https://marketplace.visualstudio.com/items?itemName=BrickellResearch.caffeine-lang",
                ),
                attribute.class("btn btn-secondary"),
                attribute.target("_blank"),
                attribute.attribute("rel", "noopener noreferrer"),
              ],
              [
                html.span([attribute.class("tool-badge")], [
                  html.text("VS Code"),
                ]),
                html.text(" Marketplace"),
              ],
            ),
            html.a(
              [
                attribute.href(
                  "https://open-vsx.org/extension/BrickellResearch/caffeine-lang",
                ),
                attribute.class("btn btn-secondary"),
                attribute.target("_blank"),
                attribute.attribute("rel", "noopener noreferrer"),
              ],
              [
                html.span([attribute.class("tool-badge")], [
                  html.text("Open VSX"),
                ]),
                html.text(" Registry"),
              ],
            ),
          ]),
        ]),
      ]),
    ]),
  )
}
