require 'minitest/autorun'
require_relative '../lib/check_addr.rb'

class CheckAddrTest < Minitest::Test
  # 各テスト開始時に一度呼ばれる
  def setup
    @validater = CheckAddr.new
  end

  # test_から始まるメソッドがテスト時に呼ばれる
  def test_check_addr
    $stdin = StringIO.new("example@example.com\n")
    $stdout = StringIO.new

    @validater.validate
    assert_equal "ok\n", $stdout.string
  end

  def test_check_addr_accept_multi_lines
    $stdin = StringIO.new("example@example.com\nexample@example.com\n")
    $stdout = StringIO.new

    @validater.validate
    assert_equal "ok\nok\n", $stdout.string
  end

  def test_check_addr_accept_multi_lines_with_empty
    $stdin = StringIO.new("example@example.com\nexample@example.com\n\n")
    $stdout = StringIO.new

    @validater.validate
    assert_equal "ok\nok\nng\n", $stdout.string
  end
end
