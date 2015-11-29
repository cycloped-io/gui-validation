module DecisionsHelper
  def value_label(value)
    case value
    when "positive"
      "valid"
    when "negative"
      "invalid"
    else
      value
    end
  end

  def value_class(value)
    case value
    when "positive"
      "label-success"
    when "negative"
      "label-danger"
    else
      "label-warning"
    end
  end

end
