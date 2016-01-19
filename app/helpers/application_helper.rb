# ApplicationHelper
module ApplicationHelper
  def will_be_numbered(path, list, search = nil)
    search += '&' if search
    path += ('?' + search.to_s)

    capture do
      concat "<nav><ul class='pagination'>".html_safe

      # show "Previous" button
      concat '<li>'.html_safe
      concat (link_to "#{path}list=#{list[:previous]}",
                      'aria-label' => 'Previous' do
                "<span aria-hidden='true'>&laquo;</span>".html_safe
              end)
      concat '</li>'.html_safe

      # show numbered pages
      (list[:left]..list[:right]).each do |link|
        if link == list[:current_page]
          concat "<li class='active'>".html_safe
          concat link_to "#{link}", "#{path}list=#{link}"
          concat '</li>'.html_safe
        else
          concat '<li>'.html_safe
          concat link_to "#{link}", "#{path}list=#{link}"
          concat '</li>'.html_safe
        end
      end

      # show "Next" button
      concat '<li>'.html_safe
      concat (link_to "#{path}list=#{list[:next]}",
                      'aria-label' => 'Next' do
                "<span aria-hidden='true'>&raquo;</span>".html_safe
              end)
      concat '</li>'.html_safe
      concat '</ul></nav>'.html_safe
    end
  end
end
