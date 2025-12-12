import components/layout
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import version

pub fn view() -> Element(Nil) {
  layout.view(
    "Playground",
    html.div([attribute.class("playground-container")], [
      html.div([attribute.class("playground-header")], [
        html.div([attribute.class("playground-title-row")], [
          html.h1([], [html.text("Playground")]),
          html.span([attribute.class("playground-version")], [
            html.text(version.latest_version),
          ]),
        ]),
        html.p([attribute.class("playground-intro")], [
          html.text(
            "Try Caffeine in your browser. Edit the blueprints and expectations below, then click Compile to see the generated Terraform output.",
          ),
        ]),
      ]),
      html.div([attribute.class("playground-layout")], [
        // Left side: editors
        html.div([attribute.class("playground-editors")], [
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
                html.text("playground/demo/service.json"),
              ]),
            ]),
            html.div(
              [attribute.id("expectations-editor"), attribute.class("editor")],
              [],
            ),
          ]),
        ]),
        // Right side: output
        html.div([attribute.class("playground-output")], [
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
                    html.text("// Click 'Compile' to generate Terraform output"),
                  ]),
                ],
              ),
            ]),
          ]),
        ]),
      ]),
      // Load playground JS (ES module)
      html.script([attribute.src("/js/playground.js"), attribute.type_("module")], ""),
    ]),
  )
}
