module ApplicationHelper
	# Returns the full title on a per-page basis.
  def full_title(page_title)  # Определение метода
    base_title = "Ruby on Rails Tutorial Sample App"  # Назначение переменной
    if page_title.empty?   # Булевый тест
      base_title     # Явное возвращение
    else
      "#{base_title} | #{page_title}"       # Интерполяция строки
    end
  end
end
