require "test/unit"
require "./lexer.rb"
require "./parser.rb"
require "./interpreter.rb"

class TestAll < Test::Unit::TestCase

	def test_simple_addition
		src = "1 + 2"
		res = interpret(parse(scan(src)))
		assert(res == 3)
	end	

	def test_simple_math	
		src = "5 + (3*2) * 16"
		res = interpret(parse(scan(src)))
		assert(res == 101)
	end

	def test_simple_variable	
		src = "a = 1"
		interpret(parse(scan(src)))
		src = "a"
		res = interpret(parse(scan(src)))
		assert(res == 1)
	end

	def test_easy_variable
		src = "a = 1"
		interpret(parse(scan(src)))
		src = "b = 2*a"
		interpret(parse(scan(src)))
		src = "c = 2*b"
		interpret(parse(scan(src)))
		src = "a"		
		res = interpret(parse(scan(src)))
		assert(res == 1)
		src = "b"		
		res = interpret(parse(scan(src)))
		assert(res == 2)
		src = "c"		
		res = interpret(parse(scan(src)))
		assert(res == 4)
	end

end