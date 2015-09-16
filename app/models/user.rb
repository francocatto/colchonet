class User < ActiveRecord::Base

  has_many :rooms, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :reviewed_rooms, through: :reviews, source: :room

  scope :confirmed, -> { where.not(confirmed_at: nil) }
  EMAIL_REGEXP = /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/
  validates_presence_of :email, :full_name, :location
  validates_length_of :bio, minimum: 30, allow_blank: false
  validates_uniqueness_of :email
  has_secure_password

  validate do
    errors.add(:email, :invalid) unless email.match(EMAIL_REGEXP)
  end

  before_create do |user|
    user.confirmation_token = SecureRandom.urlsafe_base64
  end

  def confirm!
    return if confirmed?
    self.confirmed_at = Time.current
    self.confirmation_token = ''
    save!
  end

  def confirmed?
    confirmed_at.present?
  end

  def self.authenticate(email, password)
    user = confirmed.find_by(email: email).try(:authenticate,password)
  end
end