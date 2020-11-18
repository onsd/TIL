require_relative './era.rb'

class ConvertEra
  def get_lines
    readlines.map(&:chomp)
  end

  # @param line [String] e.g. "2020/10/24"
  # @return arr [Array<Integer>] e.g. [2020, 10, 24]
  def parse_line(line)
    line.split('/').map {|e|
      e.to_i
    }
  end

  def calc
    era = Era.new
    puts get_lines.map {|line|
      year, month, day = parse_line line
      begin
        era.calc(year, month, day)
      rescue => exception
        'error'
      end
    }
  end
end

if __FILE__ == $0
  era = ConvertEra.new
  era.calc
end