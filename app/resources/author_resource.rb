class AuthorResource < JSONAPI::Resource
  belongs_to :post, always_include_linkage_data: true
  belongs_to :person, always_include_linkage_data: true
end
