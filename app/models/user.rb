class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  mount_uploader :avatar, ImageUploader

  validates :avatar, file_size: { less_than: 1.megabytes }

  has_many :memberships
  has_many :groups, through: :memberships, dependent: :destroy
  has_many :roles, through: :memberships
  has_many :created_tasks, class_name: 'Task', foreign_key: 'creator_id'
  has_many :executed_tasks, class_name: 'Task', foreign_key: 'executor_id'

  def average_rating
    executed_tasks.where.not(rating: 0).average(:rating).to_f
  end

  def created_tasks_count
    created_tasks.count
  end

  def finished_tasks_count
    executed_tasks.where(status: :closed).count
  end

  def active_tasks_count
    executed_tasks.where.not(status: %i[finished closed]).count
  end
end
