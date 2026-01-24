import gleam/io
import gleam/string
import lustre/ssg
import pages/blog
import pages/home
import pages/tour
import posts/posts

pub fn main() {
  let all_posts = posts.all()
  let posts_dict = posts.as_dict()

  let build =
    ssg.new("./docs")
    |> ssg.add_static_dir("./static")
    |> ssg.add_static_route("/", home.view())
    |> ssg.add_static_route("/blog", blog.list_view(all_posts))
    |> ssg.add_dynamic_route("/blog", posts_dict, fn(post) {
      blog.post_view(post)
    })
    |> ssg.add_static_route("/tour", tour.view())
    |> ssg.build

  case build {
    Ok(_) -> io.println("Build completed successfully!")
    Error(e) -> {
      io.println("Build failed:")
      io.println(string.inspect(e))
      Nil
    }
  }
}
