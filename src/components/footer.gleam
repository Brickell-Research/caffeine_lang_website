import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html

pub fn view() -> Element(Nil) {
  html.footer([attribute.class("site-footer")], [
    html.div([attribute.class("footer-content")], [
      // Newsletter subscription form
      html.div([attribute.class("subscribe-section")], [
        html.p([attribute.class("subscribe-title")], [
          html.text("Stay updated on Caffeine"),
        ]),
        html.form(
          [attribute.id("subscribe-form"), attribute.class("subscribe-form")],
          [
            html.input([
              attribute.type_("email"),
              attribute.name("email"),
              attribute.id("subscribe-email"),
              attribute.placeholder("your@email.com"),
              attribute.required(True),
              attribute.class("subscribe-input"),
            ]),
            // Honeypot field (hidden from users, catches bots)
            html.input([
              attribute.type_("text"),
              attribute.name("website"),
              attribute.attribute("tabindex", "-1"),
              attribute.attribute("autocomplete", "off"),
              attribute.attribute("style", "position: absolute; left: -9999px;"),
            ]),
            html.button(
              [
                attribute.type_("submit"),
                attribute.class("subscribe-button"),
              ],
              [html.text("Subscribe")],
            ),
            // Turnstile widget container
            html.div(
              [
                attribute.id("turnstile-widget"),
                attribute.class("cf-turnstile"),
                attribute.attribute("data-sitekey", "0x4AAAAAACNHy9TzUWzOgn_A"),
                attribute.attribute("data-theme", "dark"),
                attribute.attribute("data-size", "compact"),
                attribute.attribute("data-callback", "onTurnstileSuccess"),
                attribute.attribute("data-error-callback", "onTurnstileError"),
                attribute.attribute(
                  "data-expired-callback",
                  "onTurnstileExpired",
                ),
              ],
              [],
            ),
          ],
        ),
        html.p(
          [
            attribute.id("subscribe-message"),
            attribute.class("subscribe-message"),
          ],
          [],
        ),
      ]),
      html.p([], [
        html.text("Built with "),
        html.a(
          [attribute.href("https://gleam.run"), attribute.target("_blank")],
          [html.text("Gleam")],
        ),
        html.text(" and "),
        html.a(
          [
            attribute.href("https://github.com/lustre-labs/ssg"),
            attribute.target("_blank"),
          ],
          [html.text("Lustre SSG")],
        ),
      ]),
      html.p([], [
        html.text("© 2025 "),
        html.a(
          [
            attribute.href("https://brickellresearch.org/"),
            attribute.target("_blank"),
          ],
          [html.text("Brickell Research")],
        ),
      ]),
    ]),
  ])
}
