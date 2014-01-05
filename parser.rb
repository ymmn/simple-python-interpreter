require "test/unit"
require "./lexer.rb"

EOF = Token.new(:EOF, 5000)

GRAMMAR = { 
	:program => [
		[:statement]
	],
	:statement => [
		[:assignment],
		[:expression],
		[:if_statement]
	],
	:assignment => [
		[:symbol, :assign, :expression]
	],
	:if_statement => [
		[:if, :boolean_expr, :colon, :indented_statement]
	],
	:indented_statement => [
		[:tab, :statement],
		[:EPSILON]
	],
	:expression => [ 
		[:function_call],
		[:math],
		[:boolean_expr],
		[:EPSILON]
	],
	:boolean_expr => [
		[:expression, :equals, :expression]
	],
	:function_call => [
		[:symbol, :left_paren, :argument_list, :right_paren]
	],
	:argument_list => [
		[:expression, :_argument_list]
	],
	:_argument_list => [
		[:comma, :expression, :_argument_list],
		[:EPSILON]
	],
	:math => [
		[:symbol, :math],
		[:plus, :math],
		[:multiply, :math],
		[:left_paren, :math, :right_paren, :math],
		[:constant, :math],
		[:EPSILON]
	]
}

TERMINALS = {
	:constant => 1,
	:equals => 50,
	:plus => 2,
	:multiply => 3,
	:left_paren => 10,
	:comma => 10,
	:right_paren => 11,
	:symbol => 11,
	:assign => 11,
	:EPSILON => 4
}


class ParseTree

	attr_accessor :children, :value, :parent, :rule_index, :stack_state, :tokens_state

	def initialize(c, v, p, s, t=nil)
		@children = c
		@value = v
		@parent = p
		@stack_state = s
		@tokens_state = t
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

# a convenient method for testing
# takes a dictionary representing a tree and makes
# a parse tree
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

# takes a list of tokens
# returns a parse tree
def parse(tokens, debug=false)

	# append EOF token to 
	tokens.push(EOF)
	# reverse the tokens so we can pop
	tokens.reverse!
	stack = []
	stack.push(nil)
	root = ParseTree.new(nil, :program, nil, stack.clone)
	focus = root
	token = tokens.pop()
	i = 0
	while true 
		if debug 
			puts
			puts "#{i}: Token: #{token.name}. focus: #{focus}"
			puts "STACK"
			stack.each do |s|
				if s == nil
					puts "nil"
				else
					puts s.to_s
				end
			end
			i += 1
		end

		# parsed everything successfully!
		if token.name == :EOF and focus == nil
			return root
		# we are currently at a non-terminal, so expand
		elsif TERMINALS[focus.value] == nil and focus.rule_index < GRAMMAR[focus.value].length
			expanded = GRAMMAR[focus.value][focus.rule_index]
			children = []
			# we want to store the current token as well in case we need to backtrack
			tokens.push(token)
			expanded.each { |e|
				children.push(ParseTree.new(nil, e, focus, stack.clone, tokens.clone))
			}
			# pop out the extra token that we pushed for convenience
			tokens.pop()
			focus.children = children
			focus.children.reverse.each { |e| 
				stack.push(e)
			}
			focus = stack.pop()
		# the terminal matches the focus, so move on to next terminal
		elsif token.name == focus.value
			focus.children = [token.value]
			token = tokens.pop()
			focus = stack.pop()
		# at an epsilon, so move on to next focus
		elsif focus.value == :EPSILON
			puts "FOUND EPSILON!" if debug
			# remove from parse tree
			focus.parent.parent.children.delete(focus.parent)

			new_focus = stack.pop()

			# edge case: the new focus is nil and yet we still have more tokens
			if new_focus == nil and token.name != :EOF
				# TO REFACTOR
				puts "backtracking!!!" if debug
				stack = focus.stack_state
				tokens = focus.tokens_state
				token = tokens.pop()
				focus = focus.parent
				focus.rule_index += 1 if focus != nil
			else
				focus = new_focus
			end

		# focus is at a terminal, but doesn't match the token.  Therefore, 
		# we have to backtrack
		else
			puts "backtracking!!!" if debug
			stack = focus.stack_state
			tokens = focus.tokens_state
			token = tokens.pop()
			focus = focus.parent
			focus.rule_index += 1 if focus != nil
		end
	end

end

