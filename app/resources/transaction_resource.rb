class TransactionResource < ApplicationResource
  attributes :description, :currency, :paid_at, :paid_by, :amount_paid, :amount_owed, :payment_processor_url, :notes, :payment_method

  has_one :receipt, class_name: 'Photo'
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
