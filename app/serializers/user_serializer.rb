class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :updated_at, :created_at, :avatar, :reputation
  has_one :profile
end