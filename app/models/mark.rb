class Mark < ApplicationRecord
  belongs_to :evaluation
  belongs_to :evaluation_criterium
end
