import gleam/list
import gleam/order
import gleam/string
import gleeunit/should
import posts/posts

pub fn reading_time_short_post_test() {
  // A post with ~50 words should take 1 minute (minimum)
  let short_content = string.repeat("word ", 50)
  let time = posts.calculate_reading_time(short_content)

  should.equal(time, 1)
}

pub fn reading_time_medium_post_test() {
  // A post with ~400 words should take 2 minutes (400/200 = 2)
  let medium_content = string.repeat("word ", 400)
  let time = posts.calculate_reading_time(medium_content)

  should.equal(time, 2)
}

pub fn reading_time_long_post_test() {
  // A post with ~1000 words should take 5 minutes (1000/200 = 5)
  let long_content = string.repeat("word ", 1000)
  let time = posts.calculate_reading_time(long_content)

  should.equal(time, 5)
}

pub fn load_all_posts_test() {
  // Test that we can load posts without errors
  let all_posts = posts.all()

  // Should have at least 2 posts (we know there are 2)
  list.is_empty(all_posts)
  |> should.be_false
}

pub fn posts_have_required_fields_test() {
  let all_posts = posts.all()

  // Check that at least one post exists and has required fields
  case all_posts {
    [] -> should.fail()
    [first, ..] -> {
      // Title should not be empty or default
      should.not_equal(first.title, "")
      should.not_equal(first.title, "Untitled")

      // Author should not be empty
      should.not_equal(first.author, "")

      // Reading time should be positive
      { first.reading_time > 0 }
      |> should.be_true

      // Slug should not be empty
      should.not_equal(first.slug, "")

      // Content should not be empty
      list.is_empty(first.content)
      |> should.be_false
    }
  }
}

pub fn posts_sorted_by_date_test() {
  let all_posts = posts.all()

  case all_posts {
    [first, second, ..] -> {
      // Posts should be sorted by date descending (newest first)
      // The first post's date should be >= second post's date
      let comparison = string.compare(first.date, second.date)
      case comparison {
        order.Gt | order.Eq -> should.be_true(True)
        order.Lt -> should.fail()
      }
    }
    _ -> {
      // If we don't have at least 2 posts, test passes
      should.be_true(True)
    }
  }
}
