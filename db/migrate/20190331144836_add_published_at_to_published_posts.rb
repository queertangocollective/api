class AddPublishedAtToPublishedPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :published_posts, :published_at, :datetime
    add_index :published_posts, [:published_at]

    reversible do |direction|
      direction.up do
        published_posts = PublishedPost.order(post_id: :asc, created_at: :asc)
        first_post = nil

        published_posts.each do |post|
          if first_post.nil? || post.post_id != first_post.post_id
            first_post = post
          end

          post.update_attribute(:published_at, first_post.created_at)
        end
      end
    end
  end
end
