class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  has_many :memberships
  has_many :groups, through: :memberships, dependent: :destroy
  has_many :roles, through: :memberships
  has_many :created_tasks, class_name: 'Task', foreign_key: 'creator_id'
  has_many :executed_tasks, class_name: 'Task', foreign_key: 'executor_id'
end
