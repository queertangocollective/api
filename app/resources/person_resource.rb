class PersonResource < ApplicationResource
  attributes :email, :name, :biography, :website, :role, :published

  has_one :group
  has_many :photos
  has_many :authorizations
  has_many :public_keys

  before_create do
    @model.group = context[:group]
  end

  # Prevent fetching email addresses of people
  # that do aren't staff
  def fetchable_fields
    if context[:current_user].try(:staff?)
      super
    else
      super - [:email, :authorizations, :public_keys, :role, :published]
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
      Person.where(group_id: options[:context][:group].id)
            .or(Person.where(id: options[:context][:current_user].id))
    else
      options[:context][:group].people.published
    end
  end
end
