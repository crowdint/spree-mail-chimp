Deface::Override.new(:virtual_path  => 'spree/admin/shared/_configuration_menu',
                     :name          => 'add_mail_chimp_admin_menu_link',
                     :insert_bottom => "[data-hook='admin_configurations_sidebar_menu'],#admin_configurations_sidebar_menu[data-hook]",
                     :partial       => 'spree/admin/configurations/spree_mail_chimp_configuration_link' )
