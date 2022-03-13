# == Schema Information
#
# Table name: photos
#
#  id             :integer          not null, primary key
#  caption        :text
#  comments_count :integer
#  image          :string
#  likes_count    :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  owner_id       :integer
#
class Photo < ApplicationRecord

  belongs_to(:owner, {
    :class_name => "User"
  })

  has_many(:comments)

  has_many(:likes)

  has_many(:authors, {
    :through => :comments
  }) 

  has_many(:fans, {
    :through => :likes
  })

  has_many(:followers, {
     :through => :owner, 
     :source => :following 
  })

  has_many(:discoverer, { 
    :through => :fans,
    :source => :following 
  })




end
