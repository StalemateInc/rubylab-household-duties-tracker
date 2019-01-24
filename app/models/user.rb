class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  devise :omniauthable, omniauth_providers: %i[facebook]
  mount_uploader :avatar, ImageUploader

  validates_uniqueness_of :email
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

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.display_name = auth.info.name
      user.avatar = auth.info.image if auth.info.image
      user.skip_confirmation!
    end
  end
end
