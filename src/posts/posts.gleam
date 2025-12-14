import gleam/dict.{type Dict}
import gleam/list
import gleam/result
import gleam/string
import lustre/element.{type Element}
import lustre/ssg/djot
import simplifile
import tom

pub type Post {
  Post(
    slug: String,
    title: String,
    date: String,
    summary: String,
    author: String,
    reading_time: Int,
    tags: List(String),
    content: List(Element(Nil)),
  )
}

pub fn all() -> List(Post) {
  let posts_dir = "./posts"

  case simplifile.read_directory(posts_dir) {
    Ok(files) -> {
      files
      |> list.filter(fn(f) { string.ends_with(f, ".djot") })
      |> list.filter_map(fn(filename) {
        let slug = string.replace(filename, ".djot", "")
        let filepath = posts_dir <> "/" <> filename
        load_post(slug, filepath)
      })
      |> list.sort(fn(a, b) { string.compare(b.date, a.date) })
    }
    Error(_) -> []
  }
}

fn load_post(slug: String, filepath: String) -> Result(Post, Nil) {
  use content <- result.try(
    simplifile.read(filepath) |> result.replace_error(Nil),
  )

  use meta <- result.try(djot.metadata(content) |> result.replace_error(Nil))

  let title = get_string(meta, "title", "Untitled")
  let date = get_string(meta, "date", "")
  let summary = get_string(meta, "summary", "")
  let author = get_string(meta, "author", "")
  let tags = get_tags(meta, "tags")

  let rendered = djot.render(content, djot.default_renderer())
  let reading_time = calculate_reading_time(content)

  Ok(Post(
    slug: slug,
    title: title,
    date: date,
    summary: summary,
    author: author,
    reading_time: reading_time,
    tags: tags,
    content: rendered,
  ))
}

pub fn as_dict() -> Dict(String, Post) {
  all()
  |> list.map(fn(post) { #(post.slug, post) })
  |> dict.from_list
}

fn get_string(
  meta: Dict(String, tom.Toml),
  key: String,
  default: String,
) -> String {
  case dict.get(meta, key) {
    Ok(tom.String(s)) -> s
    _ -> default
  }
}

fn get_tags(meta: Dict(String, tom.Toml), key: String) -> List(String) {
  case dict.get(meta, key) {
    Ok(tom.Array(items)) -> {
      items
      |> list.filter_map(fn(item) {
        case item {
          tom.String(s) -> Ok(s)
          _ -> Error(Nil)
        }
      })
    }
    _ -> []
  }
}

pub fn calculate_reading_time(content: String) -> Int {
  // Calculate word count (split by whitespace)
  let words =
    string.split(content, " ")
    |> list.length

  // Average reading speed: 200 words per minute
  let minutes = words / 200

  // Minimum 1 minute
  case minutes {
    0 -> 1
    _ -> minutes
  }
}
