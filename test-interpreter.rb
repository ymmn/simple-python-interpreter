require "test/unit"
require "./interpreter.rb"
require "./test-programs.rb"

class TestInterpreter < Test::Unit::TestCase

	def interpret_tester(program_name)
		prog = TEST_PROGRAMS[program_name]
		interpreted = interpret(createParseTreeFromDictionary(prog[:parsed], nil))
		expected = prog[:interpreted]

		assert_equal( interpreted, expected )
	end

	def test_trivial
		interpret_tester(:single_constant)
	end	

	def test_simple_addition
		interpret_tester(:number_addition)
	end

	def test_simple_parens
		wanted =  {
			:program => [
				{:expression => [
					{:math => [
						{:left_paren => ["("]},
						{:math => [
							{:constant => ["1"]},
							{:math => [ 
								{:plus => ["+"]},
								{:math => [
									{:constant => ["2"]}						
								]}
							]}
						]},
						{:right_paren => [")"]}
					]}
				]}
			]
		}

		res = interpret(createParseTreeFromDictionary(wanted, nil))
		assert(res == 3)

		interpret_tester(:math_with_parens)
	end

	def test_simple_assignment
		interpret_tester(:basic_assignment)

		interpret_tester(:number_addition)

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
		res = interpret(createParseTreeFromDictionary(wanted, nil))

		assert(res == 1)
	end

	def test_simple_function_call
		interpret_tester(:single_arg_func_call)

		interpret_tester(:multi_arg_func_call)
	end

	def test_boolean
		interpret_tester(:boolean_statement)
	end

end
