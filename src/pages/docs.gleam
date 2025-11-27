import components/layout.{PageMeta}
import docs/docs.{type Doc}
import gleam/option.{Some}
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html

pub fn view(doc: Doc) -> Element(Nil) {
  let meta =
    PageMeta(
      title: doc.title <> " - Caffeine",
      description: Some(doc.summary),
      url: Some("https://caffeine-lang.org/docs"),
    )

  layout.view_with_meta(
    meta,
    html.div([attribute.class("docs-container")], [
      html.article([attribute.class("docs-main")], [
        html.header([attribute.class("doc-header")], [
          html.h1([], [html.text(doc.title)]),
        ]),
        html.div([attribute.class("doc-content")], doc.content),
      ]),
      html.aside([attribute.class("docs-sidebar")], [
        html.h3([], [html.text("On This Page")]),
        html.nav([attribute.class("docs-nav"), attribute.id("docs-toc")], []),
      ]),
    ]),
  )
}

pub fn fallback_view() -> Element(Nil) {
  layout.view(
    "Documentation",
    html.div([attribute.class("docs-container")], [
      html.article([attribute.class("docs-main")], [
        html.header([attribute.class("doc-header")], [
          html.h1([], [html.text("Documentation")]),
        ]),
        html.div([attribute.class("doc-content")], [
          html.p([], [html.text("Documentation coming soon!")]),
        ]),
      ]),
      html.aside([attribute.class("docs-sidebar")], [
        html.h3([], [html.text("On This Page")]),
        html.nav([attribute.class("docs-nav"), attribute.id("docs-toc")], []),
      ]),
    ]),
  )
}
