import components/layout.{PageMeta}
import gleam/dict
import gleam/int
import gleam/list
import gleam/option.{None, Some}
import gleam/string
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import posts/posts.{type Post}

pub fn list_view(all_posts: List(Post)) -> Element(Nil) {
  let tag_counts = get_tag_counts(all_posts)

  layout.view(
    "Blog",
    html.div([], [
      html.div([attribute.class("blog-container")], [
        html.div([attribute.class("blog-main")], [
          html.h1([], [html.text("Blog")]),
          html.ul([attribute.class("posts")], list_posts(all_posts)),
        ]),
        html.aside([attribute.class("blog-sidebar")], [
          tag_filter_sidebar(tag_counts),
        ]),
      ]),
      html.script([attribute.src("/js/blog-filter.js")], ""),
    ]),
  )
}

fn list_posts(all_posts: List(Post)) -> List(Element(Nil)) {
  case all_posts {
    [] -> [
      html.li([attribute.class("no-posts")], [
        html.p([], [html.text("No posts yet. Check back soon!")]),
      ]),
    ]
    _ ->
      all_posts
      |> list.map(fn(post) {
        let reading_time_text = case post.reading_time {
          1 -> "1 min read"
          n -> int.to_string(n) <> " min read"
        }

        html.li(
          [
            attribute.class("post-item"),
            attribute.attribute("data-tags", string.join(post.tags, ",")),
          ],
          [
            html.a([attribute.href("/blog/" <> post.slug)], [
              html.h2([], [html.text(post.title)]),
              html.p([attribute.class("post-date")], [
                html.text(
                  post.date
                  <> " · by "
                  <> post.author
                  <> " · "
                  <> reading_time_text,
                ),
              ]),
              html.p([attribute.class("post-summary")], [
                html.text(post.summary),
              ]),
              html.div(
                [attribute.class("post-tags")],
                post.tags
                  |> list.map(fn(tag) {
                    html.span([attribute.class("tag")], [html.text(tag)])
                  }),
              ),
            ]),
          ],
        )
      })
  }
}

fn get_tag_counts(all_posts: List(Post)) -> List(#(String, Int)) {
  all_posts
  |> list.flat_map(fn(post) { post.tags })
  |> list.fold(dict.new(), fn(acc, tag) {
    dict.upsert(acc, tag, fn(existing) {
      case existing {
        Some(count) -> count + 1
        None -> 1
      }
    })
  })
  |> dict.to_list()
  |> list.sort(fn(a, b) { string.compare(a.0, b.0) })
}

fn tag_filter_sidebar(tag_counts: List(#(String, Int))) -> Element(Nil) {
  html.div([], [
    html.div([attribute.class("filter-header")], [
      html.h3([], [html.text("Filter by Tag")]),
      html.div([attribute.class("sort-controls")], [
        html.button(
          [
            attribute.class("sort-btn active"),
            attribute.attribute("data-sort", "alpha"),
          ],
          [html.text("A-Z")],
        ),
        html.button(
          [
            attribute.class("sort-btn"),
            attribute.attribute("data-sort", "count"),
          ],
          [html.text("#")],
        ),
      ]),
    ]),
    html.div(
      [attribute.class("tag-filters")],
      list.map(tag_counts, fn(tag_count) {
        let #(tag, count) = tag_count
        html.button(
          [
            attribute.class("filter-tag"),
            attribute.attribute("data-tag", tag),
            attribute.attribute("data-count", int.to_string(count)),
          ],
          [
            html.text(tag),
            html.span([attribute.class("tag-count")], [
              html.text("(" <> int.to_string(count) <> ")"),
            ]),
          ],
        )
      }),
    ),
  ])
}

pub fn post_view(post: Post) -> Element(Nil) {
  let meta =
    PageMeta(
      title: post.title,
      description: Some(post.summary),
      url: Some("https://caffeine-lang.run/blog/" <> post.slug),
    )

  // Add TOC div before post content
  let toc_div = html.div([attribute.class("toc")], [])

  layout.view_with_meta(
    meta,
    html.article([attribute.class("blog-post")], [
      html.header([attribute.class("post-header")], [
        html.h1([], [html.text(post.title)]),
        html.p([attribute.class("post-date")], [
          html.text(post.date <> " · by " <> post.author),
        ]),
      ]),
      html.div([attribute.class("post-content")], [toc_div, ..post.content]),
    ]),
  )
}
