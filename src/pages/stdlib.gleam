import components/layout.{PageMeta}
import gleam/option.{Some}
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import stdlib/stdlib.{type StdlibRef}

pub fn view(ref: StdlibRef) -> Element(Nil) {
  let meta =
    PageMeta(
      title: ref.title,
      description: Some(ref.summary),
      url: Some("https://caffeine-lang.org/stdlib"),
    )

  layout.view_with_meta(
    meta,
    html.div([attribute.class("stdlib-container")], [
      html.article([attribute.class("stdlib-main")], [
        html.header([attribute.class("stdlib-header")], [
          html.h1([], [html.text(ref.title)]),
        ]),
        html.div([attribute.class("stdlib-content")], ref.content),
      ]),
      html.aside([attribute.class("stdlib-sidebar")], [
        html.h3([], [html.text("On This Page")]),
        html.nav(
          [attribute.class("stdlib-nav"), attribute.id("stdlib-toc")],
          [],
        ),
      ]),
    ]),
  )
}

pub fn fallback_view() -> Element(Nil) {
  layout.view(
    "Standard Library Reference",
    html.div([attribute.class("stdlib-container")], [
      html.article([attribute.class("stdlib-main")], [
        html.header([attribute.class("stdlib-header")], [
          html.h1([], [html.text("Standard Library Reference")]),
        ]),
        html.div([attribute.class("stdlib-content")], [
          html.p([], [html.text("Standard library reference coming soon!")]),
        ]),
      ]),
      html.aside([attribute.class("stdlib-sidebar")], [
        html.h3([], [html.text("On This Page")]),
        html.nav(
          [attribute.class("stdlib-nav"), attribute.id("stdlib-toc")],
          [],
        ),
      ]),
    ]),
  )
}
