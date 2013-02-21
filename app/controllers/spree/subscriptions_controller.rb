class Spree::SubscriptionsController < Spree::BaseController

  def hominid
    @hominid ||= Hominid::API.new(Spree::Config.get(:mailchimp_api_key))
  end

  def create
    @errors = []

    if params[:email].blank?
      @errors << t('missing_email')
    elsif params[:email] !~ /[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/i
      @errors << t('invalid_email_address')
    else
      begin
        @mc_member = hominid.list_member_info(Spree::Config.get(:mailchimp_list_id), [params[:email]])
        rescue Hominid::APIError => e
      end

      if @mc_member['errors'] == 0
        @errors << t('that_address_is_already_subscribed')
      else
        begin
          hominid.list_subscribe(Spree::Config.get(:mailchimp_list_id), params[:email], {})
        rescue
          @errors << t('invalid_email_address')
        end
      end
    end

    respond_to do |wants|
      wants.js
    end
  end
end
