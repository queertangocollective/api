class PostResource < ApplicationResource
  attributes :title, :body, :published, :published_at, :slug, :pinned

  before_create do
    @model.group = context[:group]
  end

  filters :pinned, :published, :slug

  def self.records(options={})
    context = options[:context]
    posts = context[:group].posts
    if context[:current_user]
      posts
    else
      posts.published
    end
  end
end
