# frozen_string_literal: true

class Blog < ApplicationRecord
  belongs_to :user
  has_many :likings, dependent: :destroy
  has_many :liking_users, class_name: 'User', source: :user, through: :likings

  validates :title, :content, presence: true

  scope :published, -> { where('secret = FALSE') }

  scope :search, lambda { |term|
    safe_term = ActiveRecord::Base.sanitize_sql_like(term.to_s)
    where('title LIKE :safe_term OR content LIKE :safe_term', safe_term: "%#{safe_term}%")
  }

  scope :default_order, -> { order(id: :desc) }

  scope :accessible, ->(user) { where(user:).or(published) }

  def owned_by?(target_user)
    user == target_user
  end
end
