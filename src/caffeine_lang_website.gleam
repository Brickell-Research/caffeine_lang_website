import lustre
import lustre/attribute
import lustre/element/html

pub fn main() {
  let app =
    lustre.element(
      html.img([
        attribute.src(
          "https://github.com/Brickell-Research/caffeine_lang/blob/main/images/temp_caffeine_icon.png?raw=true",
        ),
      ]),
    )
  let assert Ok(_) = lustre.start(app, "#app", Nil)

  Nil
}
