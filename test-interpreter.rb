require "test/unit"
require "./interpreter.rb"

class TestInterpreter < Test::Unit::TestCase

	def test_trivial
		wanted = {
			:program => [
				{:expression => [
					{:math => [
						{:constant => ["1"]}
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
							{:math => [
								{:constant => ["2"]}
							]}
						]},
					]}
				]}
			]
		}
		res = interpret(createParseTreeFromDictionary(wanted, nil))
		assert(res == 3)
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

		wanted = {
			:program => [
				{:expression => [
					{:math => [
						{:constant => ["3"]},
						{:math => [
							{:multiply => ["*"]},
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
					]}
				]}				
			]
		}

		res = interpret(createParseTreeFromDictionary(wanted, nil))
		assert(res == 9)
	end

	def test_simple_assignment
		wanted = {
			:program => [
				{:statement => [
					{:symbol => ["a"]},
					{:assign => ["="]},
					{:expression => [
						{:math => [
							{:constant => ["1"]}
						]}
					]}
				]}
			]
		}
		res = interpret(createParseTreeFromDictionary(wanted, nil))
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

		wanted = {
			:program => [
				{:statement => [
					{:function_call => [
						{:symbol => ["print"]},
						{:left_paren => ["("]},
						{:expression => [
							{:math => [
								{:constant => ["1"]}
							]}
						]},
						{:right_paren => [")"]}
					]}
				]}
			]
		}
		res = interpret(createParseTreeFromDictionary(wanted, nil))
		puts
		p(res)
		puts
		assert(res == "")
	end

end
