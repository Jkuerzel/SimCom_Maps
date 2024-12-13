module ApplicationHelper
  def smart_round(number)
    number = number.to_f
    return number.to_i if number == number.to_i
    significant_digits = (Math.log10(1.0 / number.abs).ceil + 2) if number != 0
    number.round(significant_digits || 0)
  end
end
