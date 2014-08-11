ThinkingSphinx::Index.define :user, with: :active_record do
  # fields
  indexes name, sortable: true
  indexes email, sortable: true
  indexes profile.location, as: :location
  indexes profile.real_name, as: :real_name
  indexes profile.website, as: :website
  indexes profile.birthday, as: :birthday
  indexes profile.about, as: :about

  # attributes
  has created_at, updated_at
end