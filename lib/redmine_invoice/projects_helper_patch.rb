require_dependency 'projects_helper'
module  RedmineInvoice
  module ProjectsHelperPatch
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        alias_method_chain :render_project_action_links, :reports
      end
    end
    module InstanceMethods
      def render_project_action_links_with_reports
        links = []
        if User.current.allowed_to?(:add_project, nil, :global => true)
          links << link_to(l(:label_project_new), new_project_path, :class => 'icon icon-add')
        end
       if User.current.allowed_to?(:view_invoice_report, nil, :global => true)
          links << link_to('reports', reports_invoices_path)
        end
        if User.current.allowed_to?(:view_issues, nil, :global => true)
          links << link_to(l(:label_issue_view_all), issues_path)
        end
        if User.current.allowed_to?(:view_time_entries, nil, :global => true)
          links << link_to(l(:label_overall_spent_time), time_entries_path)
        end
        links << link_to(l(:label_overall_activity), activity_path)
        links.join(" | ").html_safe
      end
    end


  end
end
