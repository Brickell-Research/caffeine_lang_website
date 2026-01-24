import components/layout
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import version

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
                "https://github.com/Brickell-Research/caffeine_lang/releases",
              ),
              attribute.class("btn btn-primary"),
            ],
            [html.text("Get Started (" <> version.latest_version <> ")")],
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
          html.pre([attribute.class("code-block copyable")], [
            html.button(
              [attribute.class("copy-btn"), attribute.attribute("aria-label", "Copy to clipboard")],
              [html.text("Copy")],
            ),
            html.code([attribute.class("language-bash")], [
              html.text(
                "brew tap Brickell-Research/caffeine && brew install caffeine_lang",
              ),
            ]),
          ]),
        ]),
        html.p([attribute.class("install-alt")], [
          html.text("Or download a binary from "),
          html.a(
            [attribute.href("https://github.com/Brickell-Research/caffeine_lang/releases")],
            [html.text("GitHub Releases")],
          ),
          html.text("."),
        ]),
        html.p([attribute.class("install-subtitle")], [
          html.text("Verify your installation:"),
        ]),
        html.div([attribute.class("install-box")], [
          html.pre([attribute.class("code-block copyable")], [
            html.button(
              [attribute.class("copy-btn"), attribute.attribute("aria-label", "Copy to clipboard")],
              [html.text("Copy")],
            ),
            html.code([attribute.class("language-bash")], [
              html.text("caffeine --version"),
            ]),
          ]),
        ]),
        html.p([attribute.class("install-platform")], [
          html.text("Supports macOS and Linux."),
        ]),
      ]),
      // Copy button script
      html.script([], "
        document.querySelectorAll('.copy-btn').forEach(function(btn) {
          btn.addEventListener('click', function() {
            var code = btn.parentElement.querySelector('code').textContent;
            navigator.clipboard.writeText(code).then(function() {
              btn.textContent = 'Copied!';
              setTimeout(function() { btn.textContent = 'Copy'; }, 2000);
            });
          });
        });
      "),
    ]),
  )
}
