# category
class CategorySerializer < ActiveModel::Serializer
  type :category
  attributes :id, :name, :workspace_id
end

# has_one :blog do |serializer|
#   serializer.cached_blog
# end
#
# def cached_blog
#   cache_store.fetch("cached_blog:#{object.updated_at}") do
#     Blog.find(object.blog_id)
#   end
# end