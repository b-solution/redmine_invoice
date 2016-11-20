require 'redmine'

Redmine::Plugin.register :redmine_invoice do
  name 'Redmine Invoice plugin'
  author 'Bilel Kedidi'
  description 'This is a plugin for Redmine'
  version '0.0.1'

  project_module :redmine_invoice do
    permission :view_invoices, :invoices => [:index, :show]
    permission :manage_invoices, :invoices => [:new, :create, :destroy, :edit, :update]

    permission :view_payment, :payments => [:index, :show]
    permission :manage_payment, :payments => [:new, :create, :destroy, :edit, :update]

  end

  menu :top_menu, :clients,
       {:controller => 'clients', :action => 'index'},
       :caption => :label_client_plural, :if => Proc.new {
        User.current.admin?
      }

  menu :top_menu, :taxes,
       {:controller => 'taxes', :action => 'index'},
       :caption => :label_tax_plural, :if => Proc.new {
        User.current.admin?
      }

  menu :project_menu, :invoices,
       {:controller => 'invoices', :action => 'index'},
       :caption => :label_invoice_plural,  param: 'project_id'

  settings  :partial => 'settings/invoice_settings',
            :default => {
                'company_name' => '',
                'address' => '',
                'phone' => '',
                'email' => '',
                'footer_info' => ''
            }

  Rails.application.config.assets.precompile += %w( cocoon.js )
end

Rails.application.config.to_prepare do
  require_dependency 'redmine_invoice/hooks'

  Project.send(:include, RedmineInvoice::ProjectPatch)
  Issue.send(:include, RedmineInvoice::IssuePatch)
end

