class UserPaperTopic < ApplicationRecord
  belongs_to :user
  belongs_to :paper_topic
end
