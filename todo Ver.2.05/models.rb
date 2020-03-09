require 'bundler/setup'
Bundler.require

if development?
 ActiveRecord::Base.establish_connection("sqlite3:db/development.db")
end

class User < ActiveRecord::Base
  has_secure_password
  #validates :name,
  #  presense: true,
  #  format: { with: /\A\w+\z/ }
  #validates :password,
  #  length: { in: 5..10 }
  has_many :tasks
end

class Task < ActiveRecord::Base
  scope :due_over, -> { where('due_date < ?', Date.today).where(completed: [nil, false]) }
  scope :had_by, -> (user) { where(user_id: user.id) }

  validates :title,
  presence: true
  belongs_to :user
  belongs_to :list

  def remained_days
    return(due_date - Date.today).to_i
  end
end

class List < ActiveRecord::Base
  has_many :tasks
end