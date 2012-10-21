class Movie < ActiveRecord::Base

    def self.get_ratings(checked)
        Movie.select(:rating).uniq_by(&:rating).map do |m|
            { :rating => m.rating, :checked => checked.nil? ? true : checked.include?(m.rating) }
        end
    end
end
