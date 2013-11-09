require "test/unit"
require "./lexer.rb"

class TestLexer < Test::Unit::TestCase

	def test_simple_num
		assert_equal(scan("1")[0], Token.new(:constant, "1"))
		assert_equal(scan("1234")[0], Token.new(:constant, "1234"))
	end	

	def test_simple_mixed
		assert_equal(scan("()"), [Token.new(:left_paren, "("), Token.new(:right_paren, ")")])
		assert_equal(scan("(123)"), [Token.new(:left_paren, "("), Token.new(:constant, "123"), Token.new(:right_paren, ")")])
		assert_equal(scan("1 + 2"), [Token.new(:constant, "1"), Token.new(:whitespace, " "), Token.new(:plus, "+"), Token.new(:whitespace, " "), Token.new(:constant, "2")])
	end

end