class User < ActiveRecord::Base
  has_many :splatts
  has_and_belongs_to_many :follows,
    class_name: "User",
    join_table: :follows,
    foreign_key: :follower_id,
    association_foreign_key: :followed_id
  has_and_belongs_to_many :followed_by,
    class_name: "User",
    join_table: :followed_by,
    foreign_key: :followed_id,
    association_foreign_key: :follower_id

  validates :name, presence: true
  validates :email, uniqueness: { case_sensitive: false}
  validates :password, presence: true, length: {minimum: 8}

  def strong?
    password =~ /.*\d+.*/ && \
    password =~ /.*[a-z]+.*/ && \
    password =~ /.*[A-Z].*/
  end
end
