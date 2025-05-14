class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, 
		 :confirmable
  has_many :fraud_prompts

  # Reset count at the beginning of each day
  def can_query_openai?
 	if last_query_at.nil? || last_query_at < Time.zone.now.beginning_of_day
		reset_daily_query_count!
	end
	query_count.to_i < 10
  end

  # Incrementing on each use
  def increment_query_count!
	update!(query_count: query_count.to_i + 1, last_query_at: Time.zone.now)
  end

  def reset_daily_query_count!
	update!(query_count: 0, last_query_at: Time.zone.now)
  end
end
