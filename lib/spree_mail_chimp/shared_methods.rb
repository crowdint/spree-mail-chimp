module SpreeMailChimp
  module SharedMethods

    def hominid
      @hominid ||= Hominid::API.new(Spree::Config.get(:mailchimp_api_key), {:timeout => 60})
    end

    def subscribe_email(email_to_subscribe)
      subscribe_errors = validate_email(email_to_subscribe)

      if subscribe_errors.empty?
        begin
          @mc_member = hominid.list_member_info(Spree::Config.get(:mailchimp_list_id), [email_to_subscribe])
        rescue Hominid::APIError => e
        end

        if @mc_member['errors'] == 0
          subscribe_errors << I18n.t('that_address_is_already_subscribed')
        else
          begin
            hominid.list_subscribe(Spree::Config.get(:mailchimp_list_id), email_to_subscribe, {}, 'html', *mailchimp_subscription_opts)
          rescue
            subscribe_errors << I18n.t('invalid_email_address')
          end
        end
      end
      subscribe_errors
    end

    def subscribe_email_to_list(email_to_subscribe, list_name)
      subscribe_errors = validate_email(email_to_subscribe)
      subscribe_errors << I18n.t('missing_list_name') if list_name.blank?

      if subscribe_errors.empty?
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

    def subscribe_email_to_group(email_to_subscribe, groupings, group_name)
      subscribe_errors = validate_email(email_to_subscribe)

      if subscribe_errors.empty?
        begin
          @mc_member = hominid.list_member_info(Spree::Config.get(:mailchimp_list_id), [email_to_subscribe])
        rescue Hominid::APIError => e
        end

        if @mc_member['errors'] == 0
          subscribe_errors << I18n.t('that_address_is_already_subscribed')
        else
          begin
            hominid.list_subscribe(Spree::Config.get(:mailchimp_list_id), email_to_subscribe, { "GROUPINGS" => [{"name"=>groupings, "groups"=>group_name}] }, 'html', *mailchimp_subscription_opts)
          rescue
            subscribe_errors << I18n.t('invalid_email_address')
          end
        end
      end
      subscribe_errors
    end


    def mailchimp_subscription_opts
      [Spree::Config.get(:mailchimp_double_opt_in), true, true, Spree::Config.get(:mailchimp_send_welcome)]
    end

    def validate_email email_to_subscribe
      error = []
      if email_to_subscribe.blank?
        error << I18n.t('missing_email')
      elsif email_to_subscribe !~ /[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/i
        error << subscribe_errors << I18n.t('invalid_email_address')
      end
      error
    end

  end
end
