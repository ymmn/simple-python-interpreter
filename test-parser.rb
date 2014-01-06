require "test/unit"
require "./parser.rb"
require "./test-programs.rb"

class TestParser < Test::Unit::TestCase

	def setup
		@parser = Parser.new
	end

	def parse_tester(program_name, debug=false)
		prog = TEST_PROGRAMS[program_name]
		parsed = @parser.parse(prog[:tokenized], debug)
		expected = @parser.createParseTreeFromDictionary(prog[:parsed], nil)

		assert_equal( expected.to_s, parsed.to_s )
	end

	def test_trivial
		parse_tester(:single_constant)
	end	

	def test_simple
		parse_tester(:number_addition)

		parse_tester(:math_with_parens)

		parse_tester(:basic_assignment)

		parse_tester(:boolean_statement)
	end

	def test_function_call
		parse_tester(:single_arg_func_call)

		parse_tester(:multi_arg_func_call)
	end

	def test_if_statement
		parse_tester(:trivial_true_if)

		parse_tester(:multiline_if)

	end

	def test_loops
		parse_tester(:while_loop)
	end

end
