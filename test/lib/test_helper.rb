require 'f1results'
require 'minitest/autorun'
require 'minitest/assertions'
require 'mechanize'
require 'fixtures'

module Minitest::Assertions
  def assert_nothing_raised(*)
    yield
  end

  def assert_raise_with_message(e, message, &block)
    e = assert_raises(e, &block)
    if message.is_a?(Regexp)
      assert_match(message, e.message)
    else
      assert_equal(message, e.message)
    end
  end
end
