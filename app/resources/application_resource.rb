class ApplicationResource < JSONAPI::Resource
  abstract

  attributes :created_at, :updated_at

  filter :text, apply: ->(records, value, _options) {
    name = value[0]
    if name.blank?
      records
    else
      records.search_for(value[0])
    end
  }

  def self.updatable_fields(context)
    super - [:created_at, :updated_at]
  end

  def self.creatable_fields(context)
    super - [:created_at, :updated_at]
  end
end
