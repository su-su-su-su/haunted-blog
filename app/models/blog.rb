# frozen_string_literal: true

class Blog < ApplicationRecord
  belongs_to :user
  has_many :likings, dependent: :destroy
  has_many :liking_users, class_name: 'User', source: :user, through: :likings

  validates :title, :content, presence: true

  scope :published, -> { where('secret = FALSE') }

  scope :search, ->(term) {
    term = term.nil? ? "" : term
    where("title LIKE ? OR content LIKE ?", 
          "%" + ActiveRecord::Base.sanitize_sql_like(term) + "%",
          "%" + ActiveRecord::Base.sanitize_sql_like(term) + "%")
  }  

  scope :default_order, -> { order(id: :desc) }

  scope :accessible_blogs, ->(user) { where(user: user).or(where(secret: false)) }

  def owned_by?(target_user)
    user == target_user
  end
end
