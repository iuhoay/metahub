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
end
