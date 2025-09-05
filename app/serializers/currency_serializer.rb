class CurrencySerializer
  include JSONAPI::Serializer
  attributes :code, :name, :decimal_places, :updated_at, :created_at
end
