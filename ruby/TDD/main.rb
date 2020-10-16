require 'minitest/reporters'
Minitest::Reporters.use!
require 'minitest/autorun'

class FizzBuzzTest < Minitest::Test
  def test_1を渡したら文字列1を返す
    assert_equal '1', FizzBuzz.generate(1)
    assert_equal '2', FizzBuzz.generate(2)
    assert_equal '3', FizzBuzz.generate(3)
    assert_equal '4', FizzBuzz.generate(4)
    assert_equal '5', FizzBuzz.generate(5)



  end
end

class FizzBuzz
    def self.generate(n)
        n.to_s
    end
end

# TODO
# 数を文字列にして返す
# 1を渡したら文字列"1"を返す
# 3 の倍数のときは数の代わりに｢Fizz｣と返す
# 5 の倍数のときは｢Buzz｣と返す
# 3 と 5 両方の倍数の場合には｢FizzBuzz｣と返す
# 1 から 100 までの数
# プリントする