require_relative './validate_addr_spec.rb'

class CheckAddr
  def get_lines
    readlines.map(&:chomp)
  end

  def validate
    validator = ValidateAddress.new
    puts get_lines.map {|line|
      begin
        validator.validate line
      rescue => exception
        'ng'
      end
    }
  end
end

if __FILE__ == $0
  checkAddr = CheckAddr.new
  checkAddr.validate
end