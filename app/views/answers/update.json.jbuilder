json.answer do
  json.id @answer.id
  json.body @answer.body
  json.question_id @answer.question_id
  json.created_at @answer.created_at.iso8601
end
json.attachments @answer.attachments do |attachment|
  json.filename attachment.file.filename
  json.url attachment.file.url
end
json.user do
  json.id @answer.user.id
  json.name @answer.user.name
  json.avatar_url @answer.user.avatar_url
end
json.alert do
  json.class 'success'
  json.message tr(:answer, 'updated')[:notice]
end