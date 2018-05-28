class EventResource < ApplicationResource
  attributes :title, :description, :level, :starts_at, :ends_at

  belongs_to :venue, always_include_linkage_data: true
  has_many :ticketed_events
  has_many :ticket_stubs

  filter :upcoming, apply: ->(records, value, _options) {
    records.where("starts_at >= ? or ends_at >= ?", DateTime.now, DateTime.now)
  }

  before_create do
    @model.group = context[:group]
  end

  def self.records(options={})
    context = options[:context]
    context[:group].events
  end
end
