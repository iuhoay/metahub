module ApplicationHelper
  def icon(name, options = {})
    content_tag(:i, "", class: "bi bi-#{name} #{options[:class]}")
  end

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
      content_tag(:span, class: "d-inline-flex align-items-center justify-content-center gap-1") do
        [content_tag(:i, "", class: "bi bi-asterisk text-warning"), current_user.name].join.html_safe
      end
    else
      content_tag(:span, current_user.name, class: "d-flex align-items-center justify-content-center gap-1")
    end
  end

  def breadcrumbs_render
    return unless @breadcrumbs.present?
    active = @breadcrumbs.pop
    content_tag(:ol, class: "breadcrumb m-0") do
      @breadcrumbs.map do |breadcrumb|
        if breadcrumb.link?
          content_tag(:li, class: "breadcrumb-item") do
            link_to(breadcrumb.name, breadcrumb.path)
          end
        else
          content_tag(:li, class: "breadcrumb-item") do
            breadcrumb.name
          end
        end
      end.join.html_safe
        .concat(
          content_tag(:li, class: "breadcrumb-item active") do
            active.name
          end
        )
    end
  end
end
