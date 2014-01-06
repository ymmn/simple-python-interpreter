require "./lexer.rb"
require "./parser.rb"

# test built-in function
def func_add(a,b)
	return a + b
end

$variables = {}

$functions = {
	# built-in funcs
	"print" => :print,
	"add" => :func_add
}

# takes a constant node
def evaluate_constant(node)
	return node.children[0].to_i
end

# takes an _argument_list node
def _evaluate_args(node)
	return [] if node == nil
	return [interpret(node.children[1])] + _evaluate_args(node.children[2])
end

# takes an argument_list node
def evaluate_args(node)
	return [interpret(node.children[0])] + _evaluate_args(node.children[1])
end

# takes a function_call node
def evaluate_function(node)
	func_name = node.children[0].children[0]
	args = evaluate_args(node.children[2])
	return method($functions[func_name]).call(*args)
end

# takes a symbol node
def evaluate_symbol(node)
	varname = node.children[0]
	if $variables.key?(varname)
		return $variables[varname]
	else
		raise "#{varname} is undefined"
	end
end

# takes a math node and returns a lambda func
def _evaluate_math(node)
	# epsilon case
	return lambda { |x| return x } if node == nil

	fchild = node.children[0].value
	if fchild == :plus
		return lambda { |x| return x + evaluate_math(node.children[1]) }
	elsif fchild == :multiply
		return lambda { |x| return x * evaluate_math(node.children[1]) }
	end
end

# takes a math node
def evaluate_math(node)
	fchild = node.children[0].value
	if fchild == :left_paren
		return _evaluate_math(node.children[3]).call( evaluate_math(node.children[1]) ) 
	elsif fchild == :constant
		return _evaluate_math(node.children[1]).call( evaluate_constant(node.children[0]) )
	elsif fchild == :symbol
		return _evaluate_math(node.children[1]).call( evaluate_symbol(node.children[0]) )
	end
end

def evaluate_boolean_expr(node)
	if node.children[0].value == :boolean
		# grandchild is either the string "True" or the string "False"
		return node.children[0].children[0] == "True"
	else 
		# given two expressions and a comparison operator
		left_val = interpret(node.children[0])
		right_val = interpret(node.children[2])

		comparison = node.children[1].value

		if comparison == :equals
			return left_val == right_val
		elsif comparison == :less_than
			return left_val < right_val
		elsif comparison == :greater_than
			return left_val > right_val
		end
	end
end

def evaluate_while(node)
	condition = evaluate_boolean_expr(node.children[1])	
	ret = []
	while condition
		ret += evaluate_block(node.children[3])
		condition = evaluate_boolean_expr(node.children[1])	
	end
	return ret
end

def _evaluate_block(node)
	# epsilon case
	return [] if node == nil

	return [interpret(node.children[1])] + _evaluate_block(node.children[2])
end

def evaluate_block(node)
	if node.children[0].value == :statement
		return [interpret(node.children[0])] + _evaluate_block(node.children[1])
	else 
		return evaluate_block(node.children[1])
	end
end

def evaluate_if(node)
	condition = evaluate_boolean_expr(node.children[1])
	if condition
		return interpret(node.children[3])
	else
		return ""
	end
end

def evaluate_assignment(node)
	variable_name = node.children[0].children[0]
	value = interpret(node.children[2])
	$variables[variable_name] = value
	return ""
end

# takes a parse tree
def interpret(ptree)
	node_type = ptree.value

	if node_type == :block
		return evaluate_block(ptree)
	elsif node_type == :if_block
		return evaluate_if(ptree)
	elsif node_type == :while_block
		return evaluate_while(ptree)
	elsif node_type == :boolean_expr
		return evaluate_boolean_expr(ptree)
	elsif node_type == :assignment
		return evaluate_assignment(ptree)
	elsif node_type == :function_call
		return evaluate_function(ptree)
	elsif node_type == :math
		return evaluate_math(ptree)
	end

	# dig deeper
	return interpret(ptree.children[0])
end

