import gleam/bytes_tree
import gleam/erlang/process
import gleam/http/request.{type Request}
import gleam/http/response.{type Response}
import gleam/io
import gleam/list
import gleam/string
import mist.{type Connection, type ResponseData}
import simplifile

pub fn main() {
  let assert Ok(_) =
    mist.new(handler)
    |> mist.port(8000)
    |> mist.start

  io.println("Server running at http://localhost:8000")
  process.sleep_forever()
}

fn handler(req: Request(Connection)) -> Response(ResponseData) {
  let path = case req.path {
    "/" -> "/index.html"
    p ->
      case string.ends_with(p, "/") {
        True -> p <> "index.html"
        False ->
          case string.contains(p, ".") {
            True -> p
            False -> p <> ".html"
          }
      }
  }

  let file_path = "./docs" <> path

  case simplifile.read(file_path) {
    Ok(content) ->
      response.new(200)
      |> response.set_header("content-type", get_content_type(path))
      |> response.set_body(mist.Bytes(bytes_tree.from_string(content)))

    Error(_) ->
      case simplifile.read_bits(file_path) {
        Ok(bits) ->
          response.new(200)
          |> response.set_header("content-type", get_content_type(path))
          |> response.set_body(mist.Bytes(bytes_tree.from_bit_array(bits)))

        Error(_) ->
          response.new(404)
          |> response.set_body(mist.Bytes(bytes_tree.from_string("Not Found")))
      }
  }
}

fn get_content_type(path: String) -> String {
  case string.split(path, ".") |> list.last {
    Ok("html") -> "text/html; charset=utf-8"
    Ok("css") -> "text/css; charset=utf-8"
    Ok("js") -> "application/javascript"
    Ok("png") -> "image/png"
    Ok("jpg") | Ok("jpeg") -> "image/jpeg"
    Ok("svg") -> "image/svg+xml"
    _ -> "application/octet-stream"
  }
}
