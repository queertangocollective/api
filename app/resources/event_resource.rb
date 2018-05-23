class EventResource < ApplicationResource
  attributes :title, :description, :level, :starts_at, :ends_at

  belongs_to :venue, always_include_linkage_data: true
  has_many :ticketed_events

  filter :upcoming, apply: ->(records, value, _options) {
    records.where("starts_at >= ? or ends_at >= ?", DateTime.now, DateTime.now)
  }

  before_create do
    @model.group = context[:group]
  end

  def self.records(options={})
    context = options[:context]
    events = context[:group].events
    if context[:current_user].try(:staff?)
      events
    else
      events.published
    end
  end
end
