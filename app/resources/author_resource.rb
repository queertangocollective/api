class AuthorResource < JSONAPI::Resource
  has_one :post, always_include_linkage_data: true
  has_one :person, always_include_linkage_data: true
end
