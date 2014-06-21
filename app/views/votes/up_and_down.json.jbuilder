json.selector class_with_id(parent)
json.sum      parent.vote_sum
json.voted    !!@vote
if action_name == 'up'
  json.action '.upvote'
  json.other_action '.downvote'
  json.text @vote ? t('vote.upvoted') : t('vote.up')
  json.other_text t('vote.down')
else
  json.action '.downvote'
  json.other_action '.upvote'
  json.text @vote ? t('vote.downvoted') : t('vote.down')
  json.other_text t('vote.up')
end

