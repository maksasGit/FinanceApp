class UserSerializer
  include JSONAPI::Serializer

  attributes :name
  attributes :email
  attributes :balance
  attributes :updated_at
  attributes :created_at
end
