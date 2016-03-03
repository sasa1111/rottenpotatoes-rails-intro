class Movie < ActiveRecord::Base
def self.all_ratings
     rate_type = Array.new
     self.select("rating").uniq.each do |x|
         rate_type << x.rating
     end
     rate_type.uniq
end
end