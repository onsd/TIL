require 'minitest/autorun'
require_relative '../lib/tax.rb'

class SampleTest < Minitest::Test
  # 各テスト開始時に一度呼ばれる
  def setup
    @sample = Tax.new
  end

  # test_から始まるメソッドがテスト時に呼ばれる
  def test_calc_with_round_up
    # assertするメソッドはいくつかあるので
    # http://docs.seattlerb.org/minitest/Minitest/Assertions.html を参考に
    assert_equal 24, @sample.calc([10, 12])
    assert_equal 62, @sample.calc([40,16])
    assert_equal 160, @sample.calc([100,45])
    assert_equal 171, @sample.calc([50,50,55])
  end
  
  def test_calc_without_round_up
    # assertするメソッドはいくつかあるので
    # http://docs.seattlerb.org/minitest/Minitest/Assertions.html を参考に
    assert_equal 154, @sample.calc([100, 40])
    assert_equal 165, @sample.calc([100, 50])
  end

  def test_calc_return_0
    assert_equal 0, @sample.calc([])
  end
end
