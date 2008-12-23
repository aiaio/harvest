class Hash
  def assert_valid_keys(*valid_keys)
    invalid_keys = keys - valid_keys
    raise ArgumentError, "Invalid key(s): #{invalid_keys.join(", ")}" unless invalid_keys.empty?
  end

  def assert_required_keys(*required_keys)
    missing_keys = required_keys.select {|key| !keys.include?(key)}
    raise ArgumentError, "Missing required option(s): #{missing_keys.join(", ")}" unless missing_keys.empty?
  end
end
