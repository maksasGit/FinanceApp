class UserSerializer
  include JSONAPI::Serializer
  attributes :name, :email, :balance, :updated_at, :created_at
end
