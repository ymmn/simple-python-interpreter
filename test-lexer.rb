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
		assert_equal(scan("1 + 2"), [Token.new(:constant, "1"), Token.new(:plus, "+"), Token.new(:constant, "2")])
		assert_equal(scan("3*(1+2)"), [Token.new(:constant, "3"), Token.new(:multiply, "*"), Token.new(:left_paren, "("),
			 Token.new(:constant, "1"), Token.new(:plus, "+"), Token.new(:constant, "2"), Token.new(:right_paren, ")")])
		assert_equal(scan("a = 1"), [Token.new(:symbol, "a"), Token.new(:assign, "="), Token.new(:constant, "1")])
	end


end