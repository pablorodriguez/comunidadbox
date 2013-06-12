class HelpController < ApplicationController
  skip_before_filter :authenticate_user!


  def index
    @docs = [
      ["67908748",I18n.t("help_what_is_comunidadbox")],
      ["65332488",I18n.t("help_user_registration")],
      ["68238819",I18n.t("help_confirm_user")],
      ["67916688",I18n.t("help_new_service_own_car")],
      ["68094773",I18n.t("help_new_client_service_budget")]
    ]

  end

end
