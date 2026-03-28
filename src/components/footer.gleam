import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html

pub fn view() -> Element(Nil) {
  html.footer([attribute.class("site-footer")], [
    html.div([attribute.class("footer-content")], [
      html.p([], [
        html.text("Built with "),
        html.a(
          [attribute.href("https://gleam.run"), attribute.target("_blank")],
          [html.text("Gleam")],
        ),
        html.text(" and "),
        html.a(
          [
            attribute.href("https://github.com/lustre-labs/ssg"),
            attribute.target("_blank"),
          ],
          [html.text("Lustre SSG")],
        ),
      ]),
      html.p([], [
        html.text("© 2026 "),
        html.a(
          [
            attribute.href("https://brickellresearch.org/"),
            attribute.target("_blank"),
          ],
          [html.text("Brickell Research")],
        ),
      ]),
    ]),
  ])
}
