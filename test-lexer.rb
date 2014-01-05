require "test/unit"
require "./lexer.rb"
require "./test-programs.rb"


class TestLexer < Test::Unit::TestCase

	def lex_tester(program_name)
		prog = TEST_PROGRAMS[program_name]
		scanned = scan(prog[:src])
		expected = prog[:tokenized]

		assert_equal( scanned, expected )
	end

	def test_simple_num
		lex_tester(:single_constant)
		assert_equal(scan("1234")[0], Token.new(:constant, "1234"))
	end	

	def test_simple_mixed
		assert_equal(scan("()"), [Token.new(:left_paren, "("), Token.new(:right_paren, ")")])
		assert_equal(scan("(123)"), [Token.new(:left_paren, "("), Token.new(:constant, "123"), Token.new(:right_paren, ")")])

		lex_tester(:number_addition)	

		lex_tester(:math_with_parens)	

		lex_tester(:basic_assignment)

		lex_tester(:single_arg_func_call)

		lex_tester(:multi_arg_func_call)

		lex_tester(:boolean_statement)

		lex_tester(:trivial_if)
	end



end