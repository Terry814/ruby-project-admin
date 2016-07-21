module TasksHelper
  def task_line task, completed
    icon_class = completed ? "fa-check-square-o " : "fa-square-o"
    icon = "<i class='fa #{icon_class}' style='margin-right: 10px;'></i>"
    html = if !completed && task.url.present?
      <<-HTML
      <a class="task-title" style='display: inline;'>#{icon}</a>
      <a class="btn btn-sm btn-info" href="#{task.url}">#{task.name}</a>
      HTML
    else
      <<-HTML
      <a class="task-title">#{icon}#{task.name}</a>
      HTML
    end

    html.html_safe
  end
end