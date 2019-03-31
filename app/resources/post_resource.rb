class PostResource < ApplicationResource
  attributes :title, :body, :published, :slug, :pinned

  has_one :channel, always_include_linkage_data: true
  # has_many :authors, always_include_linkage_data: true
  has_many :published_posts, always_include_linkage_data: true

  before_create do
    @model.group = context[:group]
  end

  after_create do
    Author.create(
      post: @model,
      person: context[:current_user]
    )
  end

  filters :pinned, :published, :slug, :channel_id

  def self.apply_sort(records, order_options, context = {})
    if order_options.has_key?('published_at')
      records = records.joins(:published_posts).order(:"published_at" => order_options["published_at"].to_sym)
      order_options.delete('published_at')
    end

    super(records, order_options, context)
  end

  def self.records(options={})
    if options[:context][:current_user].try(:staff?)
      options[:context][:group].posts
    end
  end

  def self.sortable_fields(context)
    super(context) + [:"channel.name", :"published_at"]
  end
end
