require "test/unit"
require "./interpreter.rb"
require "./test-programs.rb"

class TestInterpreter < Test::Unit::TestCase

	def setup
		@parser = Parser.new
	end

	def interpret_tester(program_name)
		prog = TEST_PROGRAMS[program_name]
		interpreted = interpret(@parser.createParseTreeFromDictionary(prog[:parsed], nil))
		expected = prog[:interpreted]

		assert_equal( expected, interpreted )
	end

	def test_trivial
		interpret_tester(:single_constant)
	end	

	def test_simple_addition
		interpret_tester(:number_addition)
	end

	def test_simple_parens
		interpret_tester(:math_with_parens)
	end

	def test_simple_assignment
		interpret_tester(:number_addition)


		interpret_tester(:basic_assignment)

		# now confirm that the variable retains the assigned value
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
		res = interpret(@parser.createParseTreeFromDictionary(wanted, nil))

		assert(res == 1)
	end

	def test_simple_function_call
		interpret_tester(:single_arg_func_call)

		interpret_tester(:multi_arg_func_call)
	end

	def test_mixed
		interpret_tester(:boolean_statement)

		interpret_tester(:trivial_true_if)

		interpret_tester(:trivial_false_if)

		interpret_tester(:multiline_if)

		interpret_tester(:while_loop)
	end

end
