require "test/unit"
require "./lexer.rb"
require "./parser.rb"
require "./interpreter.rb"
require "./test-programs.rb"

class TestAll < Test::Unit::TestCase

	def setup
		@parser = Parser.new
	end

	def execute(src)
		return interpret(@parser.parse(scan(src)))
	end

	def full_tester(program_name)
		prog = TEST_PROGRAMS[program_name]
		evaluated = execute(prog[:src])
		expected = prog[:interpreted]

		assert_equal( evaluated, expected )
	end

	def test_simple_addition
		full_tester(:number_addition)
	end	

	def test_simple_math	
		full_tester(:math_with_parens)

		src = "5 + (3*2) * 16"
		res = execute(src)
		assert(res == 101)
	end

	def test_simple_variable	
		src = "a = 1"
		execute(src)
		src = "a"
		res = execute(src)
		assert(res == 1)
	end

	def test_easy_variable
		src = "a = 1"
		execute(src)
		src = "b = 2*a"
		execute(src)
		src = "c = 2*b"
		execute(src)
		src = "a"		
		res = execute(src)
		assert(res == 1)
		src = "b"		
		res = execute(src)
		assert(res == 2)
		src = "c"		
		res = execute(src)
		assert(res == 4)
	end

end