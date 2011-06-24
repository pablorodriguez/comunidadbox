module ComboxStatus
  def method_missing1(method_name)
    puts "### method missed #{method_name}"
  end
end
