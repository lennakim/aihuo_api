if @comments.is_a?(Comment)
  json.(@comments, :id, :name, :content, :comment_at)
else
  json.comment @comments do |comment|
    # binding.pry
    json.(comment, :id, :name, :content, :comment_at)
    # json.id comment.id
    # json.name comment.name
    # json.content comment.content
    # json.comment_at comment.comment_at
    # json.name comment.name
  end
end
