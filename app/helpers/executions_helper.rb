module ExecutionsHelper


  def stacked_progress_bar(label,total, pass, fail, skip=0)

    pass_percent = pass.to_f / total * 100
    fail_percent = fail.to_f / total * 100
    skip_percent = skip.to_f / total * 100

    puts pass_percent, fail_percent, skip_percent

    content = content_tag(:span, "#{label}: #{display_percentage(total, pass + fail + skip)}")

    content << content_tag(:div, class: 'progress') do
      concat *content_tag(:div, nil,
                          class: 'progress-bar progress-bar-success',
                          role: 'progressbar',
                          aria: { valuenow: pass_percent, valuemin: 0, valuemax: 100 },
                          style: "width: #{pass_percent}%") + content_tag(:div, nil,
                                                                  class: ' progress-bar progress-bar-danger',
                                                                  role: 'progressbar',
                                                                  aria: { valuenow: fail_percent, valuemin: 0, valuemax: 100 },
                                                                  style: "width: #{fail_percent}%")+ content_tag(:div, nil,
                                                                                                         class: ' progress-bar progress-bar-warning',
                                                                                                         role: 'progressbar',
                                                                                                         aria: { valuenow: skip_percent, valuemin: 0, valuemax: 100 },
                                                                                                         style: "width: #{skip_percent}%")
    end
  end

  def display_percentage(total, complete)
    if total == 0
      return "No Tests"
    else

      number_to_percentage(complete.to_f / total.to_f * 100, precision: 1)
    end
  end

end
