import gleam/dict.{type Dict}
import gleam/result
import lustre/element.{type Element}
import lustre/ssg/djot
import simplifile
import tom

pub type Doc {
  Doc(title: String, summary: String, content: List(Element(Nil)))
}

pub fn load() -> Result(Doc, Nil) {
  let filepath = "./documentation/index.djot"

  use content <- result.try(
    simplifile.read(filepath) |> result.replace_error(Nil),
  )

  use meta <- result.try(djot.metadata(content) |> result.replace_error(Nil))

  let title = get_string(meta, "title", "Documentation")
  let summary = get_string(meta, "summary", "")

  let rendered = djot.render(content, djot.default_renderer())

  Ok(Doc(title: title, summary: summary, content: rendered))
}

fn get_string(meta: Dict(String, tom.Toml), key: String, default: String) -> String {
  case dict.get(meta, key) {
    Ok(tom.String(s)) -> s
    _ -> default
  }
}
