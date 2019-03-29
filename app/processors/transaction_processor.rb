class TransactionProcessor < ApplicationProcessor
  def find
    filters = params[:filters]
    include_directives = params[:include_directives]
    sort_criteria = params.fetch(:sort_criteria, [])
    paginator = params[:paginator]
    fields = params[:fields]

    verified_filters = resource_klass.verify_filters(filters, context)
    find_options = {
      context: context,
      include_directives: include_directives,
      sort_criteria: sort_criteria,
      paginator: paginator,
      fields: fields
    }

    records = resource_klass.filter_records(verified_filters, find_options)
    resources = if params[:cache_serializer]
      resource_klass.find_serialized_with_caching(verified_filters,
                                                  params[:cache_serializer],
                                                  find_options)
    else
      resource_klass.find(verified_filters, find_options)
    end

    result = JSONAPI::ResourcesOperationResult.new(:ok, resources, { record_count: records.count })

    currency = records.first.try(:currency)
    result.meta[:balance] = {
      amount: records.sum(:amount_paid) - records.sum(:amount_owed),
      currency: currency
    }
    result.meta[:credit] = {
      amount: records.where('amount_paid > 0').sum(:amount_paid),
      currency: currency
    }
    result.meta[:debit] = {
      amount: records.where('amount_paid < 0').sum(:amount_paid),
      currency: currency
    }
    result.meta[:settled] = {
      amount: records.sum(:amount_paid),
      currency: currency
    }
    result.meta[:owed] = {
      amount: records.sum(:amount_owed),
      currency: currency
    }

    result
  end
end
