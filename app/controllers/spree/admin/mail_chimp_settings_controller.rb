module Spree

  class Admin::MailChimpSettingsController < Admin::BaseController
    include SpreeMailChimp::SharedMethods

    def show
       @lists = hominid.lists['data']
    end


    def update
      Spree::Config.set(params[:preferences])

      respond_to do |format|
        format.html {
          redirect_to admin_mail_chimp_settings_path
        }
      end
    end
  end

end


