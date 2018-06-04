class HardTestJob < ApplicationJob
  queue_as :default

  def perform()
    Article.deleted.each do |article|
			if Time.now - article.deleted_at >= 7.days
				article.destroy!
			end
		end
  end
end
