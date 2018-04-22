class LocationResource < ApplicationResource
  attributes :name, :website, :address_line, :extended_address,
             :city, :region_code, :postal_code, :latitude, :longitude

  has_one :photo

  filter :address_line, :city, :region_code

  before_create do
    @model.group = context[:group]
  end

  def self.updatable_fields(context)
    super - [:latitude, :longitude]
  end

  def self.creatable_fields(context)
    super - [:latitude, :longitude]
  end

  def self.records(options={})
    options[:context][:group].locations
  end
end
