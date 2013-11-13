# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(128)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  username               :string(255)      not null
#  phone                  :string(255)
#  first_name             :string(255)
#  last_name              :string(255)
#  display_name           :string(255)
#  status                 :string(255)
#  admin                  :boolean          default(FALSE)
#  buzzcard_id            :integer
#  buzzcard_facility_code :integer
#

class User < ActiveRecord::Base
  before_save :strip_phone
  before_create :get_ldap_data

  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable
  devise :registerable, :recoverable, :rememberable, :trackable,
    :validatable

  if Rails.env.production?
    devise :ldap_authenticatable
  else
    devise :database_authenticatable
  end

  has_many :staff_tickets, dependent: :destroy
  has_many :contests, through: :staff_tickets
  has_many :listener_tickets
  has_many :contest_suggestions, dependent: :destroy

  default_scope -> { order('username ASC') }

  validates :phone,      format: /[\(\)0-9\- \+\.]{10,20}/, allow_blank: true
  validates :email,      presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name,  presence: true
  validates :username,   presence: true, format: /[a-zA-Z]{2,8}/,
                         uniqueness: { case_sensitive: false }

  def name
    display_name.presence || [first_name, last_name].join(" ")
  end

  def username_with_name
    username + " - " + name
  end

  def admin?
    self.admin
  end

  def exec?(roles = [:contest_director])
    roles = [roles] unless roles.kind_of? Array

    result = self.admin?

    if result
      true
    else
      roles.each do |role|
        result ||= self.has_role?(role) 
      end
    end

    return result
  end

  alias_method :has_role_or_admin?, :exec?

  def authorize_exec!(roles = [:contest_director])
    unless self.exec?(roles)
      raise CanCan::AccessDenied
    end
  end

  def contest_director?
    self.exec?([:contest_director])
  end

  # FIXME: make this generic
  def strip_phone
    self.phone.gsub!(/\D/, '') if self.phone
  end

  def self.find_by_username(username)
    User.where("lower(username) = ?", username.downcase).first
  end

  def serializable_hash(options={})
    options = { 
      methods: [:name]
    }.update(options)
    super(options)
  end

  def get_ldap_data
    if Rails.env.production?
      self.legacy_id  = Devise::LDAP::Adapter.get_ldap_param(self.username, "employeeNumber")
      self.first_name = Devise::LDAP::Adapter.get_ldap_param(self.username, "givenName")
      self.last_name  = Devise::LDAP::Adapter.get_ldap_param(self.username, "sn")
      self.status     = Devise::LDAP::Adapter.get_ldap_param(self.username, "employeeType")
    end
  end

  def get_ldap_data!
    self.get_ldap_data
    self.save!
  end
end
