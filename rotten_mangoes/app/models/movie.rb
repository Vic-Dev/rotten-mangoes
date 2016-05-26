
class Movie < ActiveRecord::Base

  has_many :reviews

  validates :title,
    presence: true

  validates :director,
    presence: true

  validates :runtime_in_minutes,
    numericality: { only_integer: true }

  validates :description,
    presence: true

  validates :release_date,
    presence: true

  validate :release_date_is_in_the_future

  mount_uploader :image, ImageUploader

  def review_average
    if reviews.size > 0
      reviews.sum(:rating_out_of_ten)/reviews.size
    end
  end

  protected

  def release_date_is_in_the_future
    if release_date.present?
      errors.add(:release_date, "should probably be in the future") if release_date < Date.today
    end
  end

  def self.search(search_title="%", search_director="%", duration="%")
    # if search_title || search_director || duration
    #   if search_title.length > 0
    #     all.where('title LIKE ? AND director LIKE ?', "%#{search_title}%", "%#{search_director}%")
    #   elsif search_title.length > 0
    #     all.where('title LIKE ?',  "%#{search_title}%")
    #   elsif search_director.length > 0
    #     all.where('director LIKE ?', "%#{search_director}%")
    #   elsif duration == '1'
    #     all.where('runtime_in_minutes < ?', 90)
    #   elsif duration == '2'
    #     all.where('runtime_in_minutes BETWEEN ? AND ?', 90, 120)
    #   elsif duration == '3'
    #     all.where('runtime_in_minutes > ?', 120)
    #   else
    #     all
    #   end
    # else
    #   all
    # end
    result = all.where('title LIKE ? AND director LIKE ?', "%#{search_title}%", "%#{search_director}%")
    if duration == '1'
      result = result.where('runtime_in_minutes < ?', 90)
    elsif duration == '2'
      result = result.where('runtime_in_minutes BETWEEN ? AND ?', 90, 120)
    elsif duration == '3'
      result = result.where('runtime_in_minutes > ?', 120)
    end
    result
  end

end