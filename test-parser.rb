require "test/unit"
require "./parser.rb"

class TestParser < Test::Unit::TestCase

	def test_trivial
		res = parse([Token.new(:constant, "1")])
		wanted = {
			:program => [
				{:statement => [
					{:expression => [
						{:math => [
							{:constant => ["1"]},
						]}
					]}
				]}
			]
		}

		ref = createParseTreeFromDictionary(wanted, nil)
	
		assert(ref.to_s == res.to_s)

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

		puts 
		puts "RES"
		puts res.to_s
		ref = createParseTreeFromDictionary(wanted, nil)
	
		assert(ref.to_s == res.to_s)
	end	

	def test_simple
		res = parse([Token.new(:constant, "1"), Token.new(:plus, "+"), Token.new(:constant, "2")])
		wanted = {
			:program => [
				{:statement => [
					{:expression => [
						{:math => [
							{:constant => ["1"]},
							{:math => [
								{:plus => ["+"]},
								{:math => [
									{:constant => ["2"]}						]},
								]}
						]}
					]}
				]}
			]
		}

		puts 
		puts "RES"
		puts res.to_s
		ref = createParseTreeFromDictionary(wanted, nil)
		assert(ref.to_s == res.to_s)

		res = parse([Token.new(:constant, "3"), Token.new(:multiply, "*"), Token.new(:left_paren, "("),
			 Token.new(:constant, "1"), Token.new(:plus, "+"), Token.new(:constant, "2"), Token.new(:right_paren, ")")])
		wanted = {
			:program => [
				{:statement => [
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
					]}
			]
		}
			

		ref = createParseTreeFromDictionary(wanted, nil)
		# puts 
		# puts "RES"
		# puts res.to_s
		# puts 
		# puts "REF"
		# puts ref.to_s
	
		assert(ref.to_s == res.to_s)

		res = parse([Token.new(:symbol, "a"), Token.new(:assign, "="), Token.new(:constant, "1")])
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
		ref = createParseTreeFromDictionary(wanted, nil)
		assert(ref.to_s == res.to_s)
	end

end
