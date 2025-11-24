// Blog post tag filtering and sorting
document.addEventListener('DOMContentLoaded', function() {
  const filterButtons = document.querySelectorAll('.filter-tag');
  const postItems = document.querySelectorAll('.post-item');
  const sortButtons = document.querySelectorAll('.sort-btn');
  const tagFiltersContainer = document.querySelector('.tag-filters');

  // Tag filtering with deselect
  filterButtons.forEach(button => {
    button.addEventListener('click', function() {
      const selectedTag = this.getAttribute('data-tag');
      const isActive = this.classList.contains('active');

      // Toggle selection
      if (isActive) {
        // Deselect - show all posts
        this.classList.remove('active');
        postItems.forEach(post => post.classList.remove('hidden'));
      } else {
        // Select - filter posts
        filterButtons.forEach(btn => btn.classList.remove('active'));
        this.classList.add('active');

        postItems.forEach(post => {
          const postTags = post.getAttribute('data-tags');
          if (postTags && postTags.split(',').includes(selectedTag)) {
            post.classList.remove('hidden');
          } else {
            post.classList.add('hidden');
          }
        });
      }
    });
  });

  // Sort functionality
  sortButtons.forEach(button => {
    button.addEventListener('click', function() {
      const sortType = this.getAttribute('data-sort');

      // Update active state
      sortButtons.forEach(btn => btn.classList.remove('active'));
      this.classList.add('active');

      // Get all filter buttons as array
      const buttons = Array.from(document.querySelectorAll('.filter-tag'));

      // Sort based on type
      if (sortType === 'alpha') {
        buttons.sort((a, b) => {
          const tagA = a.getAttribute('data-tag').toLowerCase();
          const tagB = b.getAttribute('data-tag').toLowerCase();
          return tagA.localeCompare(tagB);
        });
      } else if (sortType === 'count') {
        buttons.sort((a, b) => {
          const countA = parseInt(a.getAttribute('data-count'));
          const countB = parseInt(b.getAttribute('data-count'));
          return countB - countA; // Descending order
        });
      }

      // Re-append buttons in new order
      tagFiltersContainer.innerHTML = '';
      buttons.forEach(btn => tagFiltersContainer.appendChild(btn));
    });
  });
});
