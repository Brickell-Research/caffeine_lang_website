import gleam/dict.{type Dict}
import gleam/result
import lustre/element.{type Element}
import lustre/ssg/djot
import simplifile
import tom

pub type StdlibRef {
  StdlibRef(title: String, summary: String, content: List(Element(Nil)))
}

pub fn load() -> Result(StdlibRef, Nil) {
  let filepath = "./stdlib/index.djot"

  use content <- result.try(
    simplifile.read(filepath) |> result.replace_error(Nil),
  )

  use meta <- result.try(djot.metadata(content) |> result.replace_error(Nil))

  let title = get_string(meta, "title", "Standard Library Reference")
  let summary = get_string(meta, "summary", "")

  let rendered = djot.render(content, djot.default_renderer())

  Ok(StdlibRef(title: title, summary: summary, content: rendered))
}

fn get_string(meta: Dict(String, tom.Toml), key: String, default: String) -> String {
  case dict.get(meta, key) {
    Ok(tom.String(s)) -> s
    _ -> default
  }
}
