class CategorySerializer
  include JSONAPI::Serializer

  attributes :name
  attributes :user_id
  attributes :parent_id
  attributes :category_type
  attributes :updated_at
  attributes :created_at
end
