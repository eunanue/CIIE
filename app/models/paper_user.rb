class PaperUser < ApplicationRecord
  belongs_to :paper
  belongs_to :user
end
