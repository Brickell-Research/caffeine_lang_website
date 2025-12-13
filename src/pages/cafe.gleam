import components/layout
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import version

pub fn view() -> Element(Nil) {
  layout.view(
    "The Cafe",
    html.div([attribute.class("cafe-container")], [
      html.div([attribute.class("cafe-header")], [
        html.div([attribute.class("cafe-title-row")], [
          html.h1([], [html.text("The Cafe")]),
          html.span([attribute.class("cafe-version")], [
            html.text(version.latest_version),
          ]),
        ]),
        html.p([attribute.class("cafe-intro")], [
          html.text(
            "Try Caffeine in your browser. Edit the blueprints and expectations below to see the generated Terraform output.",
          ),
        ]),
      ]),
      html.div([attribute.class("cafe-layout")], [
        // Left side: editors
        html.div([attribute.class("cafe-editors")], [
          // Blueprints editor
          html.div([attribute.class("editor-panel")], [
            html.div([attribute.class("editor-header")], [
              html.span([attribute.class("editor-label")], [html.text("Blueprint")]),
              html.span([attribute.class("editor-filename")], [
                html.text("blueprints.json"),
              ]),
            ]),
            html.div(
              [attribute.id("blueprints-editor"), attribute.class("editor")],
              [],
            ),
          ]),
          // Expectations editor
          html.div([attribute.class("editor-panel")], [
            html.div([attribute.class("editor-header")], [
              html.span([attribute.class("editor-label")], [html.text("Expectation")]),
              html.span([attribute.class("editor-filename")], [
                html.text("cafe/demo/service.json"),
              ]),
            ]),
            html.div(
              [attribute.id("expectations-editor"), attribute.class("editor")],
              [],
            ),
          ]),
        ]),
        // Right side: output
        html.div([attribute.class("cafe-output")], [
          html.div([attribute.class("output-panel")], [
            html.div([attribute.class("output-header")], [
              html.span([], [html.text("Output")]),
              html.span([attribute.class("auto-compile-badge")], [
                html.text("auto-compiles"),
              ]),
            ]),
            html.div([attribute.class("output-content")], [
              html.pre(
                [attribute.id("output-display"), attribute.class("output-code")],
                [
                  html.code([attribute.class("language-hcl")], [
                    html.text("// Edit the inputs to generate Terraform output"),
                  ]),
                ],
              ),
            ]),
          ]),
        ]),
      ]),
      // Load cafe JS (ES module)
      html.script([attribute.src("/js/cafe.js"), attribute.type_("module")], ""),
    ]),
  )
}
