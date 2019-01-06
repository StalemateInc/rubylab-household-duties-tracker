class Group < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  settings index: {
    number_of_shards: 1
  } do
    mapping do
      indexes :name, type: 'text'
      indexes :visible_to_all
    end
  end

  has_many :memberships, inverse_of: :group
  has_many :users, through: :memberships, dependent: :destroy
  has_many :tasks
  accepts_nested_attributes_for :memberships

  scope :text_contains, ->(query) { where('LOWER(name) LIKE ?', "%#{query.downcase}%")}

  scope :full_text_search, ->(query) { text_contains(query) }

  def as_indexed_json(options = {})
    as_json(only: %i[id name visible_to_all], methods: :accessible_by)
  end

  private

  def accessible_by
    abilities = User.all.each_with_object({}) { |user, hash| hash[user.id] = Ability.new(user) }
    visible_to_all? ? :everyone : abilities.select { |_key, value| value.can?(:read, self) }.keys
  end
end
