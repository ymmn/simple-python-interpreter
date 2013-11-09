require "test/unit"
require "./interpreter.rb"

class TestInterpreter < Test::Unit::TestCase

	def test_trivial
		wanted = {
			:program => [
				{:expression => [
					{:math => [
						{:constant => ["1"]},
						{:math => [
							{:EPSILON => [0]}
						]}
					]}
				]}
			]
		}
		res = interpret(createParseTreeFromDictionary(wanted, nil))
		assert(res == 1)
	end	

	def test_simple_addition
		wanted = {
			:program => [
				{:expression => [
					{:math => [
						{:constant => ["1"]},
						{:math => [
							{:plus => ["+"]},
							{:constant => ["2"]},
							{:math => [
								{:EPSILON => [0]}
							]}
						]},
					]}
				]}
			]
		}
		res = interpret(createParseTreeFromDictionary(wanted, nil))
		assert(res == 3)
	end

end
