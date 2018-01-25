class PersonResource < ApplicationResource
  attributes :email, :name, :biography, :website, :role, :published

  has_one :group
  has_many :photos
  has_many :authorizations

  before_create do
    @model.group = context[:group]
  end

  # Prevent fetching email addresses of people
  # that do aren't staff
  def fetchable_fields
    if context[:current_user].try(:staff?)
      super
    else
      super - [:email, :authorizations]
    end
  end

  def self.updatable_fields(context)
    if context[:current_user].try(:staff?)
      super
    else
      super - [:email]
    end
  end

  def self.creatable_fields(context)
    if context[:current_user].try(:staff?)
      super
    else
      super - [:email]
    end
  end

  def self.records(options={})
    if options[:context][:current_user].try(:staff?)
      options[:context][:group].people
    else
      options[:context][:group].people.published
    end
  end
end
