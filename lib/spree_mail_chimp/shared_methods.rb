module SpreeMailChimp
  module SharedMethods

    def hominid
      @hominid ||= Hominid::API.new(Spree::Config.get(:mailchimp_api_key), {:timeout => 60})
    end

    def subscribe_email(email_to_subscribe)
      @errors = []

      if email_to_subscribe.blank?
        @errors << t('missing_email')
      elsif email_to_subscribe !~ /[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/i
        @errors << t('invalid_email_address')
      else
        begin
          @mc_member = hominid.list_member_info(Spree::Config.get(:mailchimp_list_id), [email_to_subscribe])
        rescue Hominid::APIError => e
        end

        if @mc_member['errors'] == 0
          @errors << t('that_address_is_already_subscribed')
        else
          begin
            hominid.list_subscribe(Spree::Config.get(:mailchimp_list_id), email_to_subscribe, {})
          rescue
            @errors << t('invalid_email_address')
          end
        end
      end
      binding.pry
      @errors
    end

  end
end