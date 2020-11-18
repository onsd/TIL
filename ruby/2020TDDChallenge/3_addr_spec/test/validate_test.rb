require 'minitest/autorun'
require_relative '../lib/validate_addr_spec.rb'

class ValidateAddressTest < Minitest::Test
  # 各テスト開始時に一度呼ばれる
  def setup
    @validateAddress = ValidateAddress.new
  end

  # `ドメイン部`: `example.com` などのドメインを表す部分
  def test_domain_part
    # D1
    accept_characters = '!#$%&\'*+-/=?^_`{|}~'.split('')
    accept_characters.each { |c|
        assert_equal 'ok', @validateAddress.validate("example@#{c}")
    }
    ('a'..'z').each { |c|
        assert_equal 'ok', @validateAddress.validate("example@#{c}")
    }
    ('A'..'Z').each { |c|
        assert_equal 'ok', @validateAddress.validate("example@#{c}")
    }
    ('0'..'9').each { |c|
        assert_equal 'ok', @validateAddress.validate("example@#{c}")
    }
    rejected_characters = '(),.:;<>@[] "\\'.split('')
    rejected_characters.each { |c|
        assert_equal 'ng', @validateAddress.validate("example@#{c}")
    }

    # D2
    assert_equal 'ng', @validateAddress.validate('example@.a')
    # D3
    assert_equal 'ng', @validateAddress.validate('example@a.')
    #D4
    assert_equal 'ng', @validateAddress.validate('example@a..a')
    #D5
    assert_equal 'ng', @validateAddress.validate('example@')
  end

  def test_atmark
    # A1
    assert_equal 'ok', @validateAddress.validate('example@example.com')
    assert_equal 'ng', @validateAddress.validate('example@example@example.com')
  end

  def test_local_dotatom
    # LD1
    accept_characters = '!#$%&\'*+-/=?^_`{|}~'.split('')
    accept_characters.each { |c|
        assert_equal 'ok', @validateAddress.validate("#{c}@example.com")
    }
    ('a'..'z').each { |c|
        assert_equal 'ok', @validateAddress.validate("#{c}@example.com")
    }
    ('A'..'Z').each { |c|
        assert_equal 'ok', @validateAddress.validate("#{c}@example.com")
    }
    ('0'..'9').each { |c|
        assert_equal 'ok', @validateAddress.validate("#{c}@example.com")
    }
      rejected_characters = '(),.:;<>@[] "\\'.split('')
      rejected_characters.each { |c|
          assert_equal 'ng', @validateAddress.validate("example@#{c}")
      }

    # LD2
    assert_equal 'ng', @validateAddress.validate('.example@example.com')
    # LD3
    assert_equal 'ng', @validateAddress.validate('example.@example.com')
    # LD4
    assert_equal 'ok', @validateAddress.validate('example.example.example@example.com')
    assert_equal 'ng', @validateAddress.validate('example..example@example.com')
    # LD5
    assert_equal 'ng', @validateAddress.validate('@example.com')
  end

  def test_local_quoted
    # LQ1, LQ2
    assert_equal 'ok', @validateAddress.validate("\"example\"@example.com")
    assert_equal 'ng', @validateAddress.validate("\"example@example.com")
    assert_equal 'ng', @validateAddress.validate("example\"@example.com")

    # LQ3
    accept_characters = '!#$%&\'*+-/=?^_`{|}~(),.:;<>@[]'.split('')
    accept_characters.each { |c|
        assert_equal 'ok', @validateAddress.validate("\"#{c}\"@example.com")
    }
    ('a'..'z').each { |c|
        assert_equal 'ok', @validateAddress.validate("\"#{c}\"@example.com")
    }
    ('A'..'Z').each { |c|
        assert_equal 'ok', @validateAddress.validate("\"#{c}\"@example.com")
    }
    ('0'..'9').each { |c|
        assert_equal 'ok', @validateAddress.validate("\"#{c}\"@example.com")
    }
    assert_equal 'ok', @validateAddress.validate('"example@example"@example.com')

    # LQ4
    testCases = [
      {'expect' => 'ng', 'address' => '"""@example.com'},
      {'expect' => 'ng', 'address' => '"\"@example.com'},
      {'expect' => 'ng', 'address' => '"\"@example.com'},
      {'expect' => 'ng', 'address' => '"\\"@example.com'},
      {'expect' => 'ok', 'address' => '"\\""@example.com'},
      {'expect' => 'ok', 'address' => '"\\\\"@example.com'},
      {'expect' => 'ok', 'address' => '"\\\\\\""@example.com'}
    ]
    testCases.each{ |testCase|
      assert_equal testCase['expect'], @validateAddress.validate(testCase['address'])
    }

    # LQ5
    assert_equal 'ok', @validateAddress.validate("\"\"@example.com")
  end
end
