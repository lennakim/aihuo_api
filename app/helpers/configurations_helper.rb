module ConfigurationsHelper

  def turn_string_to_json_boolean(str)
    case str.strip
    when "true"
      true
    when "false"
      false
    else
      str
    end
  end

  def turn_setting_to_special_hash settins
    settins.weixin_fans.inject({}) do |hsh, config|
      i_index = config.name.index("_") || -1
      name = config.name[(i_index + 1)..-1]
      hsh[name.to_sym] = turn_string_to_json_boolean(config.value)
      hsh
    end
  end
end
