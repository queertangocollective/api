class TicketResource < ApplicationResource
  attributes :description, :sku, :cost, :currency, :quantity, :valid_from, :valid_to, :number_sold

  has_many :purchases
  has_many :ticketed_events
  has_many :ticket_stubs

  before_create do
    @model.group = context[:group]
  end

  def number_sold
    Transaction.all.includes(:ticket_stubs)
      .references(:ticket_stubs)
      .where("ticket_stubs.ticket_id = ?", @model.id).count
  end

  def self.apply_sort(records, order_options, context = {})
    if order_options.has_key?('number_sold')
      records = records.left_joins(:ticket_stubs).group(:id).order('COUNT(distinct ticket_stubs.person_id)')
      order_options.delete('number_sold')
    end

    super(records, order_options, context)
  end

  def self.sortable_fields(context)
    super(context) + [:number_sold]
  end

  def self.records(options={})
    options[:context][:group].tickets
  end

  def self.updatable_fields(context)
    super - [:number_sold]
  end

  def self.creatable_fields(context)
    super - [:number_sold]
  end
end
