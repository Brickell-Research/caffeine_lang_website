import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html

pub fn view() -> Element(Nil) {
  html.div([attribute.class("announcement-banner")], [
    html.a(
      [
        attribute.href("https://gleamgathering.com/"),
        attribute.target("_blank"),
        attribute.class("banner-link"),
      ],
      [
        html.span([attribute.class("banner-text-full")], [
          html.text(
            "📣 I will be speaking at Gleam Gathering! Join me for \"10,000 Lines Later: When a Tool Became a Compiler (and I Became a Gleamlin)\"",
          ),
        ]),
        html.span([attribute.class("banner-text-mobile")], [
          html.text("📣 Speaking at Gleam Gathering"),
        ]),
        html.span([attribute.class("banner-arrow")], [html.text(" →")]),
      ],
    ),
  ])
}
