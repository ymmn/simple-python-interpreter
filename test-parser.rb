require "test/unit"
require "./parser.rb"

class TestParser < Test::Unit::TestCase

	def test_trivial
		res = parse([Token.new(:constant, "1")])
		wanted = ParseTree.new(
					[ParseTree.new(
						[ParseTree.new(
							[ParseTree.new(["1"], :constant, nil, nil)],
						:math, nil, nil)], 
					:expression, nil, nil)], 
				:program, nil, nil)
		assert(res.to_s == wanted.to_s)
	end	

	def test_simple
		res = parse([Token.new(:constant, "1"), Token.new(:plus, "+"), Token.new(:constant, "2")])
		wanted = {
			:program => [
				{:expression => [
					{:math => [
						{:constant => ["1"]},
						{:plus => ["+"]},
						{:constant => ["2"]}
					]}
				]}
			]
		}

		
		puts 
		puts res
		puts
		assert(createParseTreeFromDictionary(wanted, nil).to_s == wanted.to_s)
	end

end
