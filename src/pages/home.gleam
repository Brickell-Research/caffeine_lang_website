import components/layout
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import simplifile

pub fn view() -> Element(Nil) {
  // Specification files
  let basic_types = case simplifile.read("content/artifacts/basic_types.yaml") {
    Ok(content) -> content
    Error(_) -> "# Error loading file"
  }
  let query_templates = case
    simplifile.read("content/artifacts/query_template_types.yaml")
  {
    Ok(content) -> content
    Error(_) -> "# Error loading file"
  }
  let sli_types = case simplifile.read("content/artifacts/sli_types.yaml") {
    Ok(content) -> content
    Error(_) -> "# Error loading file"
  }
  let services = case simplifile.read("content/artifacts/services.yaml") {
    Ok(content) -> content
    Error(_) -> "# Error loading file"
  }

  // Instantiation files
  let service_a = case simplifile.read("content/artifacts/service_a.yaml") {
    Ok(content) -> content
    Error(_) -> "# Error loading file"
  }
  let service_b = case simplifile.read("content/artifacts/service_b.yaml") {
    Ok(content) -> content
    Error(_) -> "# Error loading file"
  }

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
                "brew tap Brickell-Research/caffeine_lang && brew install caffeine",
              ),
            ]),
          ]),
        ]),
      ]),
      html.section([attribute.class("code-examples")], [
        html.div([attribute.class("code-grid")], [
          // Specification Panel
          html.div([attribute.class("code-panel")], [
            html.div([attribute.class("panel-header")], [
              html.text("Specification"),
            ]),
            html.div([attribute.class("tab-bar")], [
              html.button(
                [
                  attribute.class("tab active"),
                  attribute.attribute("data-panel", "spec"),
                  attribute.attribute("data-tab", "basic_types"),
                ],
                [html.text("basic_types.yaml")],
              ),
              html.button(
                [
                  attribute.class("tab"),
                  attribute.attribute("data-panel", "spec"),
                  attribute.attribute("data-tab", "query_templates"),
                ],
                [html.text("query_templates.yaml")],
              ),
              html.button(
                [
                  attribute.class("tab"),
                  attribute.attribute("data-panel", "spec"),
                  attribute.attribute("data-tab", "sli_types"),
                ],
                [html.text("sli_types.yaml")],
              ),
              html.button(
                [
                  attribute.class("tab"),
                  attribute.attribute("data-panel", "spec"),
                  attribute.attribute("data-tab", "services"),
                ],
                [html.text("services.yaml")],
              ),
            ]),
            html.div([attribute.class("tab-content")], [
              html.pre(
                [
                  attribute.class("code-block active"),
                  attribute.attribute("data-panel", "spec"),
                  attribute.attribute("data-content", "basic_types"),
                ],
                [
                  html.code([attribute.class("language-yaml")], [
                    html.text(basic_types),
                  ]),
                ],
              ),
              html.pre(
                [
                  attribute.class("code-block"),
                  attribute.attribute("data-panel", "spec"),
                  attribute.attribute("data-content", "query_templates"),
                ],
                [
                  html.code([attribute.class("language-yaml")], [
                    html.text(query_templates),
                  ]),
                ],
              ),
              html.pre(
                [
                  attribute.class("code-block"),
                  attribute.attribute("data-panel", "spec"),
                  attribute.attribute("data-content", "sli_types"),
                ],
                [
                  html.code([attribute.class("language-yaml")], [
                    html.text(sli_types),
                  ]),
                ],
              ),
              html.pre(
                [
                  attribute.class("code-block"),
                  attribute.attribute("data-panel", "spec"),
                  attribute.attribute("data-content", "services"),
                ],
                [
                  html.code([attribute.class("language-yaml")], [
                    html.text(services),
                  ]),
                ],
              ),
            ]),
          ]),
          // Instantiation Panel
          html.div([attribute.class("code-panel")], [
            html.div([attribute.class("panel-header")], [
              html.text("Instantiation"),
            ]),
            html.div([attribute.class("tab-bar")], [
              html.button(
                [
                  attribute.class("tab active"),
                  attribute.attribute("data-panel", "inst"),
                  attribute.attribute("data-tab", "service_a"),
                ],
                [html.text("service_a.yaml")],
              ),
              html.button(
                [
                  attribute.class("tab"),
                  attribute.attribute("data-panel", "inst"),
                  attribute.attribute("data-tab", "service_b"),
                ],
                [html.text("service_b.yaml")],
              ),
            ]),
            html.div([attribute.class("tab-content")], [
              html.pre(
                [
                  attribute.class("code-block active"),
                  attribute.attribute("data-panel", "inst"),
                  attribute.attribute("data-content", "service_a"),
                ],
                [
                  html.code([attribute.class("language-yaml")], [
                    html.text(service_a),
                  ]),
                ],
              ),
              html.pre(
                [
                  attribute.class("code-block"),
                  attribute.attribute("data-panel", "inst"),
                  attribute.attribute("data-content", "service_b"),
                ],
                [
                  html.code([attribute.class("language-yaml")], [
                    html.text(service_b),
                  ]),
                ],
              ),
            ]),
          ]),
        ]),
      ]),
      // Tab switching script
      html.script(
        [],
        "document.querySelectorAll('.tab').forEach(tab => {
  tab.addEventListener('click', () => {
    const panel = tab.dataset.panel;
    const target = tab.dataset.tab;

    // Update tabs
    document.querySelectorAll(`.tab[data-panel=\"${panel}\"]`).forEach(t => t.classList.remove('active'));
    tab.classList.add('active');

    // Update content
    document.querySelectorAll(`.code-block[data-panel=\"${panel}\"]`).forEach(c => c.classList.remove('active'));
    document.querySelector(`.code-block[data-panel=\"${panel}\"][data-content=\"${target}\"]`).classList.add('active');
  });
});

// Initialize syntax highlighting
if (typeof Prism !== 'undefined') {
  Prism.highlightAll();
}",
      ),
    ]),
  )
}
