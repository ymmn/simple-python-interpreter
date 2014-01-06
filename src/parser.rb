require "test/unit"
require_relative "lexer.rb"

class Parser

	EOF = Token.new(:EOF, 5000)

	GRAMMAR = { 
		:program => [
			[:statement]
		],
		:statement => [
			[:assignment],
			[:boolean_expr],
			[:expression],
			[:if_block],
			[:while_block]
		],
		:assignment => [
			[:symbol, :assign, :expression]
		],
		:if_block => [
			[:if, :boolean_expr, :colon, :block]
		],
		:while_block => [
			[:while, :boolean_expr, :colon, :block]
		],

		# one or more statements
		:block => [
			[:statement, :_block],
			[:newline, :block]
		],
		:_block => [
			[:newline, :statement, :_block],
			[:EPSILON]
		],

		:expression => [ 
			[:function_call],
			[:math]
			# [:boolean_expr]
		],
		:boolean_expr => [
			[:boolean],
			[:expression, :equals, :expression],
			[:expression, :less_than, :expression],
			[:expression, :greater_than, :expression]
		],
		:function_call => [
			[:symbol, :left_paren, :argument_list, :right_paren]
		],

		# 0 or more arguments
		:argument_list => [
			[:expression, :_argument_list],
			[:EPSILON]
		],
		:_argument_list => [
			[:comma, :expression, :_argument_list],
			[:EPSILON]
		],

		# a mathematical expression
		:math => [
			[:symbol, :_math],
			[:left_paren, :math, :right_paren, :_math],
			[:constant, :_math],
		],
		:_math => [
			# optional additions to mathematical expression (or nothing)
			[:plus, :math],
			[:multiply, :math],
			[:EPSILON]
		]
	}


	TERMINALS = TOKEN_DEFS.map{ |t| t.name } + [:EPSILON] 


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

	def backtrack
		# puts "backtracking!!!" if debug
		@stack = @focus.stack_state
		@tokens = @focus.tokens_state
		@token = @tokens.pop()
		@focus = @focus.parent
		@focus.rule_index += 1 if @focus != nil
	end

	# takes a list of tokens
	# returns a parse tree
	def parse(tokens, debug=false)

		# append EOF token to 
		@tokens = tokens
		@tokens.push(EOF)
		# reverse the tokens so we can pop
		@tokens.reverse!
		@stack = []
		@stack.push(nil)
		root = ParseTree.new(nil, :program, nil, @stack.clone)
		@focus = root
		@token = @tokens.pop()
		i = 0
		while true 

			if debug 
				puts
				puts "#{i}: Token: #{@token.name}. focus: #{@focus}"
				i += 1
			end


			# parsed everything successfully!
			if @token.name == :EOF and @focus == nil
				return root
			end


			at_terminal = TERMINALS.include?(@focus.value)


			# are we at a non-terminal?
			if not at_terminal and @focus.rule_index < GRAMMAR[@focus.value].length

				# yes, so expand it
				expanded = GRAMMAR[@focus.value][@focus.rule_index]
				children = []

				# we want to store the current token as well in case we need to backtrack
				@tokens.push(@token)
				expanded.each { |e|
					children.push(ParseTree.new(nil, e, @focus, @stack.clone, @tokens.clone))
				}
				# pop out the extra token that we pushed for convenience
				@tokens.pop()

				@focus.children = children


				@focus.children.reverse.each { |e| 
					@stack.push(e)
				}
				@focus = @stack.pop()

			# the terminal matches the focus, so move on to next terminal
			elsif @token.name == @focus.value
				@focus.children = [@token.value]
				@token = @tokens.pop()
				@focus = @stack.pop()

			# at an epsilon, so move on to next focus
			elsif @focus.value == :EPSILON
				puts "FOUND EPSILON!" if debug
				# remove from parse tree
				@focus.parent.parent.children.delete(@focus.parent)

				new_focus = @stack.pop()

				# edge case: the new focus is nil and yet we still have more tokens.
				if new_focus == nil and @token.name != :EOF
					backtrack
				else
					@focus = new_focus
				end

			# focus is at a terminal, but doesn't match the token.  Therefore, 
			# we have to backtrack
			else
				backtrack
			end
		end

	end

end