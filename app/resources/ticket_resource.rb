class TicketResource < ApplicationResource
  attributes :description, :sku, :cost, :currency, :quantity, :valid_from, :valid_to

  has_many :ticketed_events

  before_create do
    @model.group = context[:group]
  end

  def self.records(options={})
    options[:context][:group].tickets
  end
end
