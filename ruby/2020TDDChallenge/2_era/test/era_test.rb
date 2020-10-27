require 'minitest/autorun'
require_relative '../lib/era.rb'

class EraTest < Minitest::Test
  # 各テスト開始時に一度呼ばれる
  def setup
    @era = Era.new
  end

  # test_から始まるメソッドがテスト時に呼ばれる
  def test_calc
    assert_equal "平成10年", @era.calc(1998, 6, 27)
    assert_equal "平成11年", @era.calc(1999, 10, 20)
    assert_equal "令和2年", @era.calc(2020, 10, 24)
  end
  def test_calc_gannnenn
    assert_equal "昭和元年", @era.calc(1926, 12, 27)
    assert_equal "平成元年", @era.calc(1989, 1, 9)
    assert_equal "令和元年", @era.calc(2019, 10, 20)
  end
  def test_mukasi
    assert_raises ArgumentError do
        @era.calc(1900, 1, 1)
    end
  end
  def test_mirai
    assert_equal "令和82年", @era.calc(2100, 10, 24)
  end
end
