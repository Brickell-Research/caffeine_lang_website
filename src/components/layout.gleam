import components/banner
import components/footer
import components/header
import gleam/list
import gleam/option.{type Option, None, Some}
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html

pub type PageMeta {
  PageMeta(title: String, description: Option(String), url: Option(String))
}

pub fn view(title: String, content: Element(Nil)) -> Element(Nil) {
  view_with_meta(PageMeta(title, None, None), content)
}

pub fn view_with_meta(meta: PageMeta, content: Element(Nil)) -> Element(Nil) {
  let description_tags = case meta.description {
    Some(desc) -> [
      html.meta([
        attribute.name("description"),
        attribute.attribute("content", desc),
      ]),
      html.meta([
        attribute.attribute("property", "og:description"),
        attribute.attribute("content", desc),
      ]),
    ]
    None -> []
  }

  let url_tags = case meta.url {
    Some(url) -> [
      html.meta([
        attribute.attribute("property", "og:url"),
        attribute.attribute("content", url),
      ]),
    ]
    None -> []
  }

  let base_tags = [
    html.meta([attribute.attribute("charset", "UTF-8")]),
    html.meta([
      attribute.name("viewport"),
      attribute.attribute("content", "width=device-width, initial-scale=1.0"),
    ]),
    html.title([], meta.title <> " | Caffeine"),
    // Favicon
    html.link([
      attribute.rel("icon"),
      attribute.type_("image/png"),
      attribute.href("/images/temp_caffeine_icon.png"),
    ]),
    // OpenGraph meta tags
    html.meta([
      attribute.attribute("property", "og:title"),
      attribute.attribute("content", meta.title <> " | Caffeine"),
    ]),
    html.meta([
      attribute.attribute("property", "og:type"),
      attribute.attribute("content", "website"),
    ]),
    html.meta([
      attribute.attribute("property", "og:site_name"),
      attribute.attribute("content", "Caffeine"),
    ]),
    html.meta([
      attribute.attribute("name", "twitter:card"),
      attribute.attribute("content", "summary"),
    ]),
  ]

  let telemetry_tags = [
    // Honeycomb OpenTelemetry browser instrumentation
    html.script([attribute.src("/js/honeycomb.js")], ""),
  ]

  let style_tags = [
    // Google Fonts: Inter + JetBrains Mono
    html.link([
      attribute.rel("preconnect"),
      attribute.href("https://fonts.googleapis.com"),
    ]),
    html.link([
      attribute.rel("preconnect"),
      attribute.href("https://fonts.gstatic.com"),
      attribute.attribute("crossorigin", ""),
    ]),
    html.link([
      attribute.rel("stylesheet"),
      attribute.href(
        "https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap",
      ),
    ]),
    html.link([
      attribute.rel("stylesheet"),
      attribute.href("/css/styles.css"),
    ]),
    // Prism.js for syntax highlighting
    html.link([
      attribute.rel("stylesheet"),
      attribute.href(
        "https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/themes/prism-tomorrow.min.css",
      ),
    ]),
    html.script(
      [
        attribute.src(
          "https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/prism.min.js",
        ),
      ],
      "",
    ),
    html.script(
      [
        attribute.src(
          "https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/components/prism-yaml.min.js",
        ),
      ],
      "",
    ),
    html.script(
      [
        attribute.src(
          "https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/components/prism-bash.min.js",
        ),
      ],
      "",
    ),
    html.script(
      [
        attribute.src(
          "https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/components/prism-json.min.js",
        ),
      ],
      "",
    ),
    html.script(
      [
        attribute.src(
          "https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/components/prism-javascript.min.js",
        ),
      ],
      "",
    ),
    html.script(
      [
        attribute.src(
          "https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/components/prism-toml.min.js",
        ),
      ],
      "",
    ),
    html.script(
      [
        attribute.src(
          "https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/components/prism-docker.min.js",
        ),
      ],
      "",
    ),
    // HCL/Terraform syntax highlighting
    html.script(
      [
        attribute.src(
          "https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/components/prism-hcl.min.js",
        ),
      ],
      "",
    ),
    // Gleam syntax highlighting (community package)
    html.script(
      [attribute.src("https://unpkg.com/prismjs-gleam@1/gleam.js")],
      "",
    ),
  ]

  let head_content =
    list.flatten([
      base_tags, telemetry_tags, description_tags, url_tags, style_tags,
    ])

  html.html([attribute.attribute("lang", "en")], [
    html.head([], head_content),
    html.body([], [
      banner.view(),
      header.view(),
      html.main([attribute.class("main-content")], [content]),
      footer.view(),
      // Initialize Prism syntax highlighting and style inspiration quotes
      html.script(
        [],
        "
        // Convert data-lang to language-* class for Prism
        document.querySelectorAll('code[data-lang]').forEach(function(code) {
          var lang = code.getAttribute('data-lang').toLowerCase();
          // Map common language names
          if (lang === 'dockerfile') lang = 'docker';
          if (lang === 'js') lang = 'javascript';
          code.classList.add('language-' + lang);
          if (code.parentElement.tagName === 'PRE') {
            code.parentElement.classList.add('language-' + lang);
          }
        });
        if (typeof Prism !== 'undefined') { Prism.highlightAll(); }
        // Generate Table of Contents
        document.querySelectorAll('.post-content .toc').forEach(function(tocContainer) {
          var headers = document.querySelectorAll('.post-content h1[id], .post-content h2[id], .post-content h3[id], .post-content h4[id]');

          if (headers.length === 0) return;

          // Function to convert number to Roman numeral
          function toRoman(num) {
            var romans = [
              ['X', 10], ['IX', 9], ['V', 5], ['IV', 4], ['I', 1]
            ];
            var result = '';
            for (var i = 0; i < romans.length; i++) {
              while (num >= romans[i][1]) {
                result += romans[i][0];
                num -= romans[i][1];
              }
            }
            return result;
          }

          // Function to convert number to letter (1=a, 2=b, etc.)
          function toLetter(num) {
            return String.fromCharCode(96 + num); // 97 is 'a'
          }

          var tocTitle = document.createElement('div');
          tocTitle.className = 'toc-title';
          tocTitle.textContent = 'Table of Contents';

          var tocList = document.createElement('ul');
          var currentH1 = null;
          var currentH2 = null;
          var currentH3 = null;
          var h1Count = 0;
          var h2Count = 0;
          var h3Count = 0;

          headers.forEach(function(header) {
            var level = header.tagName.toLowerCase();
            var text = header.textContent.replace('#', '').trim();
            var link = document.createElement('a');
            link.href = '#' + header.id;

            if (level === 'h1') {
              h1Count++;
              h2Count = 0;
              h3Count = 0;
              link.textContent = toRoman(h1Count) + '. ' + text;
            } else if (level === 'h2') {
              h2Count++;
              h3Count = 0;
              link.textContent = toLetter(h2Count) + '. ' + text;
            } else if (level === 'h3') {
              h3Count++;
              link.textContent = h3Count + '. ' + text;
            } else {
              link.textContent = text;
            }

            var li = document.createElement('li');
            li.appendChild(link);

            if (level === 'h1') {
              tocList.appendChild(li);
              currentH1 = li;
              currentH2 = null;
              currentH3 = null;
            } else if (level === 'h2' && currentH1) {
              if (!currentH1.querySelector('ul')) {
                var ul = document.createElement('ul');
                currentH1.appendChild(ul);
              }
              currentH1.querySelector('ul').appendChild(li);
              currentH2 = li;
              currentH3 = null;
            } else if (level === 'h2') {
              tocList.appendChild(li);
              currentH2 = li;
              currentH3 = null;
            } else if (level === 'h3' && currentH2) {
              if (!currentH2.querySelector('ul')) {
                var ul = document.createElement('ul');
                currentH2.appendChild(ul);
              }
              currentH2.querySelector('ul').appendChild(li);
              currentH3 = li;
            } else if (level === 'h4' && currentH3) {
              if (!currentH3.querySelector('ul')) {
                var ul = document.createElement('ul');
                currentH3.appendChild(ul);
              }
              currentH3.querySelector('ul').appendChild(li);
            }
          });

          tocContainer.appendChild(tocTitle);
          tocContainer.appendChild(tocList);
        });

        // Add anchor links to headers
        document.querySelectorAll('.post-content h1[id], .post-content h2[id], .post-content h3[id], .post-content h4[id]').forEach(function(header) {
          var anchor = document.createElement('span');
          anchor.className = 'header-anchor';
          anchor.innerHTML = '#';
          anchor.setAttribute('aria-label', 'Copy link to ' + header.textContent);
          header.insertBefore(anchor, header.firstChild);

          // Make entire header clickable to copy URL
          header.style.cursor = 'pointer';
          header.addEventListener('click', function(e) {
            var url = window.location.origin + window.location.pathname + '#' + header.id;

            // Update URL bar
            window.history.pushState(null, '', '#' + header.id);

            // Copy to clipboard
            navigator.clipboard.writeText(url).then(function() {
              // Show feedback
              var originalText = anchor.innerHTML;
              anchor.innerHTML = '✓';
              setTimeout(function() {
                anchor.innerHTML = originalText;
              }, 1000);
            }).catch(function(err) {
              console.error('Failed to copy:', err);
            });
          });
        });

        // Subscribe form handler with execute-on-demand Turnstile
        var subscribeForm = document.getElementById('subscribe-form');
        if (subscribeForm) {
          subscribeForm.addEventListener('submit', function(e) {
            e.preventDefault();

            var email = document.getElementById('subscribe-email').value;
            var website = subscribeForm.querySelector('input[name=\"website\"]').value;
            var message = document.getElementById('subscribe-message');
            var button = subscribeForm.querySelector('button');

            // Show verifying state
            button.disabled = true;
            button.textContent = 'Verifying...';
            message.textContent = '';
            message.className = 'subscribe-message';

            // Load Turnstile script on-demand if not yet loaded
            function loadTurnstile(cb) {
              if (typeof turnstile !== 'undefined') return cb();
              var s = document.createElement('script');
              s.src = 'https://challenges.cloudflare.com/turnstile/v0/api.js?onload=onTurnstileLoad';
              window.onTurnstileLoad = function() { cb(); };
              s.onerror = function() {
                message.textContent = 'Verification failed to load. Please try again.';
                message.className = 'subscribe-message error';
                button.disabled = false;
                button.textContent = 'Subscribe';
              };
              document.head.appendChild(s);
            }

            loadTurnstile(function() {
            // Get fresh token by executing Turnstile
            turnstile.execute('#turnstile-widget', {
              callback: function(token) {
                button.textContent = 'Subscribing...';

                fetch('https://notifications.brickellresearch.org/subscribe', {
                  method: 'POST',
                  headers: { 'Content-Type': 'application/json' },
                  body: JSON.stringify({
                    email: email,
                    website: website,
                    'cf-turnstile-response': token
                  })
                })
                .then(function(response) {
                  return response.json().then(function(data) {
                    return { ok: response.ok, data: data };
                  });
                })
                .then(function(result) {
                  if (result.ok) {
                    message.textContent = result.data.message || 'Check your email to confirm!';
                    message.className = 'subscribe-message success';
                    subscribeForm.reset();
                  } else {
                    message.textContent = result.data.error || 'Something went wrong';
                    message.className = 'subscribe-message error';
                  }
                })
                .catch(function(err) {
                  message.textContent = 'Network error. Please try again.';
                  message.className = 'subscribe-message error';
                })
                .finally(function() {
                  button.textContent = 'Subscribe';
                  button.disabled = false;
                  // Reset for next submission
                  turnstile.reset('#turnstile-widget');
                });
              },
              'error-callback': function() {
                message.textContent = 'Verification failed. Please try again.';
                message.className = 'subscribe-message error';
                button.textContent = 'Subscribe';
                button.disabled = false;
                turnstile.reset('#turnstile-widget');
              }
            });
            });
          });
        }
      ",
      ),
    ]),
  ])
}
