import components/layout
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html

pub fn view() -> Element(Nil) {
  layout.view(
    "Home",
    html.div([attribute.class("home")], [
      html.section([attribute.class("hero")], [
        html.h1([], [html.text("Caffeine")]),
        html.p([attribute.class("tagline")], [
          html.text(
            "A compiler for generating reliability artifacts from service expectation definitions.",
          ),
        ]),
        html.div([attribute.class("cta-buttons")], [
          html.a(
            [
              attribute.href(
                "https://github.com/Brickell-Research/caffeine_lang",
              ),
              attribute.class("btn btn-primary"),
            ],
            [html.text("Get Started")],
          ),
          html.a(
            [attribute.href("/blog"), attribute.class("btn btn-secondary")],
            [html.text("Read the Blog")],
          ),
        ]),
      ]),
      // Install section
      html.section([attribute.class("install-section")], [
        html.h2([], [html.text("Installation")]),
        html.p([], [html.text("With Homebrew:")]),
        html.div([attribute.class("install-box")], [
          html.pre([attribute.class("code-block")], [
            html.code([attribute.class("language-bash")], [
              html.text(
                "brew tap Brickell-Research/caffeine_lang && brew update && brew install caffeine",
              ),
            ]),
          ]),
        ]),
      ]),
    ]),
  )
}
