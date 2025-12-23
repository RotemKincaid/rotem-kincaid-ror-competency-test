class User < ApplicationRecord
  include Petergate
  petergate(roles: [ :user, :editor, :admin ], multiple: false)

  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :articles, dependent: :destroy

  def role_list
    value = roles

    case value
    when Array
      value
    when String
      value.split(",")
    else
      Array(value)
    end.map { |r| r.to_s.strip.downcase }.reject(&:empty?).uniq
  end

  def has_role_name?(name)
    role_list.include?(name.to_s)
  end

  def editor_role?
    has_role_name?("editor")
  end

  def admin_role?
    has_role_name?("admin")
  end

  def assign_primary_role!(primary)
    primary = primary.to_s

    self.roles =
      case primary
      when "admin"  then [ :admin, :user ]
      when "editor" then [ :editor, :user ]
      else               [ :user ]
      end
  end

  def primary_role
    list = Array(roles).map(&:to_s)
    return "admin"  if list.include?("admin")
    return "editor" if list.include?("editor")
    "user"
  end

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
