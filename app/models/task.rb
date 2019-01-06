class Task < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  acts_as_taggable

  settings index: {
    number_of_shards: 1
  } do
    mapping do
      indexes :id, type: :keyword
      indexes :title
      indexes :description
      indexes :tag_list
      indexes :visible_to_all
      indexes :accessible_by
    end
  end

  belongs_to :creator, class_name: 'User'
  belongs_to :executor, class_name: 'User'
  belongs_to :group
  has_many :comments, as: :commentable, dependent: :destroy
  belongs_to :category
  enum status: %i[opened pending in_progress paused finished closed]
  validates :rating, inclusion: { in: 0..5 }

  scope :text_contains, (lambda do |query|
    where('LOWER(title) LIKE ?', "%#{query.downcase}%")
    .or(where('LOWER(description) LIKE ?', "%#{query.downcase}%"))
  end)

  scope :tag_contains, (lambda do |query|
    tagged_with(query.to_s, wild: true)
  end)

  scope :full_text_search, (lambda do |query|
    text_contains(query).union_all(tag_contains(query))
  end)

  def as_indexed_json(options={})
    as_json(only: %i[id title description tag_list visible_to_all], methods: %i[accessible_by group_id])
  end

  def stoppable?
    !(finished? || closed?)
  end

  private

  def accessible_by
    abilities = User.all.each_with_object({}) { |user, hash| hash[user.id] = Ability.new(user) }
    visible_to_all? ? :everyone : abilities.select { |_key, value| value.can?(:read, self) }.keys
  end
end
