require "./lexer.rb"
require "./parser.rb"
require "test/unit"

def interpret(ptree)
	if ptree.value == :program
		return interpret(ptree.children[0])
	elsif ptree.value == :expression
		return interpret(ptree.children[0])	
	elsif ptree.value == :math
		if ptree.children[0].value == :constant
			return interpret(ptree.children[0])	
		end
	elsif ptree.value == :constant
		return ptree.children[0].to_i
	end
end


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
