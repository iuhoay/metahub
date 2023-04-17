module ApplicationHelper
  def flash_messages
    flash.collect do |key, msg|
      case key
      when "notice"
        content_tag(:div, msg, class: "alert alert-success")
      when "alert"
        content_tag(:div, msg, class: "alert alert-danger")
      end
    end.join.html_safe
  end

  def current_user_name
    return unless user_signed_in?

    if current_user.admin?
      content_tag(:span, class: "d-flex align-items-center justify-content-center gap-1") do
        [icon("fa-solid", "ring", class: "text-warning"), current_user.name].join.html_safe
      end
    else
      content_tag(:span, current_user.name, class: "d-flex align-items-center justify-content-center gap-1")
    end
  end
end
