require "test/unit"
require "./lexer.rb"

EOF = Token.new(:EOF, 5000)

GRAMMAR = { 
	:program => [
		[:expression]
	],
	:expression => [ 
		[:math],
		[:EPSILON]
	],
	:math => [
		[:plus, :constant, :math],
		[:constant, :math],
		[:EPSILON]
	]
}

TERMINALS = {
	:constant => 1,
	:plus => 2,
	:EPSILON => 4
}


class ParseTree

	attr_accessor :children, :value, :parent, :rule_index, :stack_state

	def initialize(c, v, p, s)
		@children = c
		@value = v
		@parent = p
		@stack_state = s
		@rule_index = 0
	end

	def to_s
		s = "\"#{@value}\""
		if @children != nil
			if @children[0].class == String
				s += ": \"#{@children[0]}\""
			else
				s += ": {\n"
				s += @children.map { |c| c.to_s }.join(",")
				s += "}\n"
			end
		else
			s += ": 0"	
		end
		return s 
	end

	def ==(o)
		return (self.class == o.class and self.value == o.value and self.children == o.children)
	end


end

def createParseTreeFromDictionary(dict, parent)
	node_val = dict.keys[0]
	children_list = dict[node_val]
	node = ParseTree.new(nil, node_val, parent, nil)
	node.children = []
	children_list.each { |c| 
		if c.class == Hash
			node.children.push(createParseTreeFromDictionary(c, node))
		else
			node.children.push(c)
		end
	}
	return node
end

def parse(tokens)

	# append EOF token to 
	tokens.push(EOF)
	# reverse the tokens so we can pop
	tokens.reverse!
	stack = []
	stack.push(nil)
	root = ParseTree.new(nil, :program, nil, stack.clone)
	focus = root
	token = tokens.pop()
	while true 
		puts
		puts "Token: #{token.name}. focus: #{focus}"
		if token.name == :EOF and focus == nil
			return root
		elsif TERMINALS[focus.value] == nil and focus.rule_index < GRAMMAR[focus.value].length
			# non-terminal
			expanded = GRAMMAR[focus.value][focus.rule_index]
			children = []
			expanded.each { |e|
				children.push(ParseTree.new(nil, e, focus, stack.clone))
			}
			focus.children = children
			focus.children.reverse.each { |e| 
				stack.push(e)
			}
			focus = stack.pop()
		elsif token.name == focus.value
			focus.children = [token.value]
			token = tokens.pop()
			focus = stack.pop()
		elsif focus.value == :EPSILON
			puts "FOUND EPSILON!" if focus.value == 3
			# remove from parse tree
			focus.parent.parent.children.delete(focus.parent)
			focus = stack.pop()
		else
			# backtrack
			puts "backtracking!!!"
			stack = focus.stack_state
			focus = focus.parent
			focus.rule_index += 1 if focus != nil
		end
	end

end

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
