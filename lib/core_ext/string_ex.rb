class String
  def try_to_boolean
    case self.strip
    when "true"
      true
    when "false"
      false
    else
      self
    end
  end
end
