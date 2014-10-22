json.id topic.to_param
json.node_id topic.node.to_param
json.(topic, :body, :nickname)
json.liked_count topic.likes_count
json.disliked_count topic.unlikes_count
json.replies_count topic.replies_count
json.(topic, :top, :lock, :best, :approved)
json.deleted topic.deleted_at.present?
json.(topic, :created_at)
if topic.member
  json.member do
    json.partial! "members/member", member: topic.member
  end
end
if topic.topic_images.any?
  json.images topic.topic_images do |topic_image|
    json.partial! "topic_images/topic_image", topic_image: topic_image
  end
end
