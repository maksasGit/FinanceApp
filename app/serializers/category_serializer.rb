class CategorySerializer
  include JSONAPI::Serializer
  attributes :name, :user_id, :parent_id, :category_type, :updated_at, :created_at
end
