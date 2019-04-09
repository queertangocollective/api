class EventResource < ApplicationResource
  attributes :title, :description, :level, :starts_at, :ends_at

  has_one :venue, always_include_linkage_data: true
  has_many :ticketed_events
  has_many :ticket_stubs
  has_many :guests

  filter :upcoming, apply: ->(records, value, _options) {
    if value[0] == 'true'
      records.where("starts_at >= ? or ends_at >= ?", DateTime.now, DateTime.now)
    else
      records
    end
  }

  before_create do
    @model.group = context[:group]
  end

  def self.records(options={})
    context = options[:context]
    context[:group].events
  end
end
