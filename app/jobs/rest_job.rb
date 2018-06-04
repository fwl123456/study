class RestJob < ApplicationJob
  queue_as :default

  def perform(*args)
    puts "SideKiq 测试"
  end
end
