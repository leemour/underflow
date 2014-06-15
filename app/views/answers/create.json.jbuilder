json.answer do
  json.id resource.id
  json.body resource.body
  json.question_id resource.question_id
  json.created_at resource.created_at.iso8601
  json.created_at_human l resource.created_at
end
json.user do
  json.id resource.user.id
  json.name resource.user.name
  json.avatar_url resource.user.avatar_url
end
json.alert do
  json.class 'success'
  json.message tr(:answer, 'created')[:notice]
end