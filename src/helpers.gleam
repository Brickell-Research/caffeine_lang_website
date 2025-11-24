import gleam/list
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html

pub type LinkedSuggestion {
  LinkedSuggestion(text: String, link: String)
}

fn li_with_link(text: String, link: String) -> Element(Nil) {
  html.li([], [
    html.text(text),
    html.a([attribute.href(link)], [html.text("(link)")]),
  ])
}

pub fn ul_with_links(links: List(LinkedSuggestion)) -> Element(Nil) {
  html.ul(
    [],
    links
      |> list.map(fn(link) { li_with_link(link.text, link.link) }),
  )
}
