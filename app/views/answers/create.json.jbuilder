json.answer do
  json.id @answer.id
  json.body @answer.body
  json.question_id @answer.question_id
  json.created_at @answer.created_at.iso8601
  json.created_at_human l @answer.created_at
end
json.user do
  json.id @answer.user.id
  json.name @answer.user.name
  json.avatar_url @answer.user.avatar_url
end
json.alert do
  json.class 'success'
  json.message tr(:answer, 'created')[:notice]
end