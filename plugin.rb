# name: discourse-redirect-after-activation
# about: after activation, redirect to a specific URL
# version: 1.0
# authors: richard@discoursehosting.com
# url: https://github.com/discoursehosting/discourse-redirect-after-activation

enabled_site_setting :redirect_after_activation_enabled

module OverridePerformAccountActivation
  def perform_account_activation
    result = super
    if SiteSetting.redirect_after_activation_enabled
      @user.last_seen_at = Time.zone.now
      @user.save
    end
    return result
  end
end

after_initialize do
  begin
    ApplicationController.prepend_view_path("plugins/discourse-redirect-after-activation/app/views")

    class ::UsersController
      prepend OverridePerformAccountActivation
    end
  rescue
  end
end
