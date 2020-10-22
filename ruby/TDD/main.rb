require 'minitest/reporters'
Minitest::Reporters.use!
require 'minitest/autorun'

class FizzBuzzTest < Minitest::Test
    def setup
        @fizzbuzz = FizzBuzz
    end
    def numberを渡したらFizzbuzzをやる
        assert_equal '1', @fizzbuzz.generate(1)
        assert_equal '2', @fizzbuzz.generate(2)
        assert_equal 'Fizz', @fizzbuzz.generate(3)
        assert_equal '4', @fizzbuzz.generate(4)
        assert_equal 'Buzz', @fizzbuzz.generate(5)
        assert_equal 'FizzBuzz', @fizzbuzz.generate(15)

    end
end

class FizzBuzz
    def self.generate(number)
        if number.modulo(3).zero? && number.modulo(5).zero?
            return 'FizzBuzz'
        elsif number.modulo(3).zero?
            return 'Fizz'
        elsif number.modulo(5).zero?
            return 'Buzz'
        end
        return number.to_s
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