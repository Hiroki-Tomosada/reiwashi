class Word < ApplicationRecord
    has_many :fabs
    belongs_to :user, optional: true
end
