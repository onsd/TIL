require 'minitest/autorun'
require_relative '../lib/convert_era.rb'

class ConvertEraTest < Minitest::Test
  # 各テスト開始時に一度呼ばれる
  def setup
    @convertEra = ConvertEra.new
  end

  # test_から始まるメソッドがテスト時に呼ばれる
  def test_convert_era
    $stdin = StringIO.new("1900/1/1\n\n1989/1/8\n")
    $stdout = StringIO.new

    @convertEra.calc()
    assert_equal "error\nerror\n平成元年\n", $stdout.string
    $stdin = STDIN
  end

  def test_convert_era_accept_multi_lines
    $stdin = StringIO.new("1929/12/27\n1998/6/27\n1999/10/20\n2020/10/24\n")
    $stdout = StringIO.new

    @convertEra.calc()
    assert_equal "昭和4年\n平成10年\n平成11年\n令和2年\n", $stdout.string
    $stdin = STDIN
  end
  
  def test_convert_era_accept_single_line
    $stdin = StringIO.new("1929/12/27\n")
    $stdout = StringIO.new

    @convertEra.calc()
    assert_equal "昭和4年\n", $stdout.string
    $stdin = STDIN
  end
  
  def test_convert_error
    $stdin = StringIO.new("1900/1/1\n")
    $stdout = StringIO.new

    @convertEra.calc()
    assert_equal "error\n", $stdout.string
    $stdin = STDIN
  end
end
