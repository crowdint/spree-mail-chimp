class Spree::SubscriptionsController < Spree::BaseController
  include SpreeMailChimp::SharedMethods

  def create
    @errors = subscribe_email(params[:email])

    respond_to do |wants|
      wants.js
    end
  end

end
