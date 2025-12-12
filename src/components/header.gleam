import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html

pub fn view() -> Element(Nil) {
  html.header([attribute.class("site-header")], [
    html.nav([attribute.class("nav")], [
      html.a([attribute.href("/"), attribute.class("logo")], [
        html.img([
          attribute.src("/images/temp_caffeine_icon.png"),
          attribute.alt("Caffeine"),
          attribute.class("logo-img"),
        ]),
        html.text("Caffeine"),
      ]),
      html.ul([attribute.class("nav-links")], [
        html.li([], [html.a([attribute.href("/")], [html.text("Home")])]),
        html.li([], [html.a([attribute.href("/docs")], [html.text("Docs")])]),
        html.li([], [html.a([attribute.href("/stdlib")], [html.text("Stdlib")])]),
        html.li([], [
          html.a([attribute.href("/playground")], [html.text("Playground")]),
        ]),
        html.li([], [html.a([attribute.href("/blog")], [html.text("Blog")])]),
      ]),
    ]),
  ])
}
