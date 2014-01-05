require "test/unit"
require "./parser.rb"
require "./test-programs.rb"

class TestParser < Test::Unit::TestCase

	def parse_tester(program_name, debug=false)
		prog = TEST_PROGRAMS[program_name]
		parsed = parse(prog[:tokenized], debug)
		expected = createParseTreeFromDictionary(prog[:parsed], nil)

		assert_equal( parsed.to_s, expected.to_s )
	end

	def test_trivial
		parse_tester(:single_constant)

		res = parse([Token.new(:symbol, "a")])
		wanted = {
			:program => [
				{:statement => [
					{:expression => [
						{:math => [
							{:symbol => ["a"]},
						]}
					]}
				]}
			]
		}

		ref = createParseTreeFromDictionary(wanted, nil)
	
		assert(ref.to_s == res.to_s)
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

	# def test_if_statement
	# 	res = parse([Token.new(:if, "if"), Token.new(:constant, "1"), Token.new(:equals, "=="), Token.new(:constant, "1"), Token.new(:colon, ":")])
	# 	wanted = {
	# 		:program => [
	# 			{:statement => [
	# 				{:if_statement => [
	# 					{:if => ["if"]}
	# 					{:bool_expr => ["if"]}
	# 					{:if => ["if"]}
	# 				]}
	# 			]}
	# 		]
	# 	}
	# end

end
