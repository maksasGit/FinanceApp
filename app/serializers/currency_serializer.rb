class CurrencySerializer
  include JSONAPI::Serializer

  attributes :code
  attributes :name
  attributes :decimal_places
  attributes :updated_at
  attributes :created_at
end
