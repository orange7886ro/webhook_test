class WebhooksController < ActionController::Base
  skip_before_action :verify_authenticity_token
  def usecase_test
    dir = Rails.root.join('public', 'uploads', 'webhook.txt')
    Rails.logger.debug("Sheryl-test: #{params}")
    File.open(dir, "a") do |f|
      f.write("EVENT: #{params}\n")
    end
    render json: {message: "hello"}
  end
end
