# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  comments_count  :integer
#  email           :string
#  likes_count     :integer
#  password_digest :string
#  private         :boolean
#  username        :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord
  validates :email, :uniqueness => { :case_sensitive => false }
  validates :email, :presence => true
  has_secure_password

  has_many(:comments, {
    :foreign_key => "author_id"
  })

  has_many(:likes, {
    :foreign_key => "fan_id"
  })

  has_many(:my_photos, {
    :class_name => "Photo",
    :foreign_key => "owner_id",
    :dependent => :destroy
  })

  #To find out all the follow request the user sent and that was accepted
  has_many( :accepted_sent_follow_requests, -> { 
    where({ :status => "accepted" }) },{ 
      :class_name => "FollowRequest", 
      :foreign_key => "sender_id" })

  #To find out all the  follow request the user received and has accepted
  has_many( :accepted_received_follow_requests, -> {
     where({ :status => "accepted" }) }, {
       :class_name => "FollowRequest", 
       :foreign_key => "recipient_id" })

  has_many(:sent_follow_requests, {
    :class_name => "FollowRequest",
    :foreign_key => "sender_id",
    :dependent => :destroy
  })

  has_many(:received_follow_requests, {
    :class_name => "FollowRequest",
    :foreign_key => "recipient_id",
    :dependent => :destroy
  })

  #To find out who all the user is following is to see who all has he sent the request to follow
  has_many(:following, {
    :through => :accepted_sent_follow_requests,
    :source => :recipient
  })

  #To find out who all are my followers
  has_many(:followers, {
    :through => :accepted_received_follow_requests,
    :source => :sender
  })
  
  #To find the list of all the photos that user has commente on
  has_many(:commented_photos, {
    :through => :comments,
    :source => :photo
  })

  #To find the list of all the photos that user has liked
  has_many(:liked_photos, {
    :through => :likes,
    :source => :photo
  })

  has_many(:feed, { 
    :through => :following, 
    :source => :my_photos 
  })

  has_many(:discovery, { 
    :through => :following,
     :source => :liked_photos 
  })

  
  
end
