module SpreeMailChimp
  module SharedMethods

    def hominid
      @hominid ||= Hominid::API.new(Spree::Config.get(:mailchimp_api_key), {:timeout => 60})
    end

    def subscribe_email(email_to_subscribe)
      subscribe_errors = []

      if email_to_subscribe.blank?
        subscribe_errors << I18n.t('missing_email')
      elsif email_to_subscribe !~ /[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/i
        subscribe_errors << I18n.t('invalid_email_address')
      else
        begin
          @mc_member = hominid.list_member_info(Spree::Config.get(:mailchimp_list_id), [email_to_subscribe])
        rescue Hominid::APIError => e
        end

        if @mc_member['errors'] == 0
          subscribe_errors << I18n.t('that_address_is_already_subscribed')
        else
          begin
            hominid.list_subscribe(Spree::Config.get(:mailchimp_list_id), email_to_subscribe, {})
          rescue
            subscribe_errors << I18n.t('invalid_email_address')
          end
        end
      end
      subscribe_errors
    end

    def subscribe_email_to_list(email_to_subscribe, list_name)
      subscribe_errors = []
      if email_to_subscribe.blank?
        subscribe_errors << I18n.t('missing_email')
      elsif email_to_subscribe !~ /[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/i
        subscribe_errors << I18n.t('invalid_email_address')
      elsif list_name.blank?
        subscribe_errors << I18n.t('missing_list_name')
      else
        begin
          list_id = hominid.find_list_id_by_name list_name
          @mc_member = hominid.list_member_info(list_id, [email_to_subscribe])
        rescue Hominid::APIError => e
        end

        if @mc_member['errors'] == 0
          subscribe_errors << I18n.t('that_address_is_already_subscribed')
        else
          begin
            hominid.list_subscribe(list_id, email_to_subscribe, {})
          rescue
            subscribe_errors << I18n.t('invalid_email_address')
          end
        end
      end
      subscribe_errors
    end

  end
end