class TransactionResource < ApplicationResource
  attributes :description, :currency, :paid_at, :amount_paid, :amount_owed, :payment_processor_url, :notes, :payment_method

  has_one :receipt, class_name: 'Photo', always_include_linkage_data: true
  has_one :paid_by, class_name: 'Person', always_include_linkage_data: true
  has_one :ticket

  before_create do
    @model.group = context[:group]
  end

  def self.records(options={})
    if options[:context][:current_user].try(:staff?)
      options[:context][:group].transactions
    end
  end
end
