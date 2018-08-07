class PostResource < ApplicationResource
  attributes :title, :body, :published, :published_at, :slug, :pinned

  has_one :channel, always_include_linkage_data: true
  has_many :authors, always_include_linkage_data: true

  before_create do
    @model.group = context[:group]
  end

  after_create do
    Author.create(
      post: @model,
      person: context[:current_user]
    )
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

  def self.sortable_fields(context)
    super(context) + [:"channel.name"]
  end
end
