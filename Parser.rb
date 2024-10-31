require './Grid.rb'
require './Exp.rb'
require './Lexer.rb'


def parselist (listOfTokens, runtime)
	tempParser = Parser.new(listOfTokens, runtime)
    return tempParser.parse #root node of ast.
end

	
# Ast build from bottom flow should be downward the case of () can reup

class Parser

	def initialize(tokens, runtime)
	@runtime = runtime
	@tokens = tokens
	@treeArray = Array.new(tokens.length)
	@i = 0
	@root = @treeArray[0]
	end
	
	def has(type)
		if(@tokens[@i].is_a?(Experession) )
			return false
		end
		@i < @tokens.size && @tokens[@i][:type] == type
	end
	
	def advance
	@i += 1
	end
	
	def parse
		level9 
	end

	#Check for sytax errors.
	def level9 
		while (@i < @tokens.size)
			
			if ( has(:Error)  )
				raise SyntaxError 
				return
			end
			advance
		end
		@i = 0
		level8
	end

	def level8 #although i evaluations below are for the input not the tree as a whole
		while (@i < @tokens.size)
			if ( has(:Rvalue) )
				visitorE = Evaluate.new()
				xandy = @tokens[@i][:text].split(",")
				x = xandy[0][2..xandy[0].length()]
				y = xandy[1][0...-1]
				xval = parselist( (lex(x)) , @runtime)
				yval = parselist( (lex(y)) , @runtime) 
				xval.traverse(visitorE, @runtime)
				yval.traverse(visitorE, @runtime)

				@tokens[@i] =  @runtime.R(CellAddress.new(xval.Val, yval.Val))

			elsif ( has(:Sum) )
				xandy = @tokens[@i][:text].split(",")
				visitorE = Evaluate.new()

				tx = parselist((lex (xandy[0][5, 50])) , @runtime)
				ty = parselist((lex (xandy[1].chop)) , @runtime)
				bx = parselist((lex (xandy[2].lstrip[1,50])) , @runtime)
				by = parselist((lex (xandy[3].chop.chop)) , @runtime)
				tx.traverse(visitorE, @runtime)
				ty.traverse(visitorE, @runtime)
				bx.traverse(visitorE, @runtime)
				by.traverse(visitorE, @runtime)
			
				top = CellAddress.new(tx.Val, ty.Val)
				bottom = CellAddress.new(tx.Val, ty.Val)
				
				@tokens[@i] = Sum.new(top, bottom)
			elsif ( has(:Max) )
				xandy = @tokens[@i][:text].split(",")
				visitorE = Evaluate.new()

				tx = parselist((lex (xandy[0][5, 50])) , @runtime)
				ty = parselist((lex (xandy[1].chop)) , @runtime)
				bx = parselist((lex (xandy[2].lstrip[1,50])) , @runtime)
				by = parselist((lex (xandy[3].chop.chop)) , @runtime)
				tx.traverse(visitorE, @runtime)
				ty.traverse(visitorE, @runtime)
				bx.traverse(visitorE, @runtime)
				by.traverse(visitorE, @runtime)
			
				top = CellAddress.new(tx.Val, ty.Val)
				bottom = CellAddress.new(tx.Val, ty.Val)
				
				@tokens[@i] = Max.new(top, bottom)
			elsif ( has(:Min) )
				xandy = @tokens[@i][:text].split(",")
				visitorE = Evaluate.new()

				tx = parselist((lex (xandy[0][5, 50])) , @runtime)
				ty = parselist((lex (xandy[1].chop)) , @runtime)
				bx = parselist((lex (xandy[2].lstrip[1,50])) , @runtime)
				by = parselist((lex (xandy[3].chop.chop)) , @runtime)
				tx.traverse(visitorE, @runtime)
				ty.traverse(visitorE, @runtime)
				bx.traverse(visitorE, @runtime)
				by.traverse(visitorE, @runtime)
			
				top = CellAddress.new(tx.Val, ty.Val)
				bottom = CellAddress.new(tx.Val, ty.Val)
				
				@tokens[@i] = Min.new(top, bottom)
			elsif ( has(:Mean) )
				xandy = @tokens[@i][:text].split(",")
				visitorE = Evaluate.new()

				tx = parselist((lex (xandy[0][6, 50])) , @runtime)
				ty = parselist((lex (xandy[1].chop)) , @runtime)
				bx = parselist((lex (xandy[2].lstrip[1,50])) , @runtime)
				by = parselist((lex (xandy[3].chop.chop)) , @runtime)
				tx.traverse(visitorE, @runtime)
				ty.traverse(visitorE, @runtime)
				bx.traverse(visitorE, @runtime)
				by.traverse(visitorE, @runtime)
			
				top = CellAddress.new(tx.Val, ty.Val)
				bottom = CellAddress.new(tx.Val, ty.Val)
				
				@tokens[@i] = Min.new(top, bottom)
			end
			advance
		end
		@i = 0
		level7
	end

	def level7
		visitorE = Evaluate.new()

		while (@i < @tokens.size)
			if ( has(:Int) )
				@tokens[@i] = IntegerPrimitive.new(@tokens[@i][:text].to_i)
			elsif ( has(:Float) )
				@tokens[@i] = FloatPrimitive.new(@tokens[@i][:text].to_f)
			elsif ( has(:False) )
				@tokens[@i] = BooleanPrimitive.new(false)
			elsif ( has(:True) )
				@tokens[@i] = BooleanPrimitive.new(true)
			elsif ( has(:String))
				@tokens[@i] = StringPrimitive.new(@tokens[@i][:text])
			elsif ( has(:ToFloat))
				fltroot = parselist( (lex (@tokens[@i][:text][6..50].chop)), @runtime)
				fltroot.traverse(visitorE, @runtime)
				@tokens[@i] = FloatPrimitive.new(fltroot.Val)
			elsif ( has(:ToInt))
				introot = parselist( (lex (@tokens[@i][:text][4..50].chop)), @runtime)
				introot.traverse(visitorE, @runtime)
				@tokens[@i] = Int.new(introot.Val)
			end
			advance
		end
		@i = 0
		level6
	end

	

	#This level allows for recursion if a paren is seen.
	def  level6
		right = nil
		while (@i < @tokens.size)
			if ( has(:right_parenthesis) )
				right = @i
				while ( @i >= 0)
					if ( has(:left_parenthesis) )
						root = parselist(@tokens[(@i + 1)...right], @runtime)
						prev = @tokens[0...@i]
						tail = @tokens[(right + 1) .. -1]
						@tokens =  prev + [root] + tail
						level6
					end
					@i = @i - 1
				end
			end
			advance
		end
		@i = 0
		level5
	end

	
	def level5
		@i = @tokens.size - 1
		while (@i >= 0)
			if ( has(:Exponetiation) )
				@tokens[@i] = Exponetiation.new(@tokens[@i-1] , @tokens[@i+1] )
				@tokens.delete_at(@i+1)
				@tokens.delete_at(@i-1)
			end
			@i = @i -1
		end
		@i = 0
		level4
	end 

	def level4
		while (@i < @tokens.size)
			
			if ( has(:Multiply) ) 
				@tokens[@i] = Multiply.new(@tokens[@i-1] , @tokens[@i+1] )
				@tokens.delete_at(@i+1)
				@tokens.delete_at(@i-1)
				@i = @i -1
			elsif ( has(:Divide) ) 
				@tokens[@i] = Divide.new(@tokens[@i-1] , @tokens[@i+1] )
				@tokens.delete_at(@i+1)
				@tokens.delete_at(@i-1)
				@i = @i -1

			elsif ( has(:Modulo) ) 
				@tokens[@i] = Mod.new(@tokens[@i-1] , @tokens[@i+1] )
				@tokens.delete_at(@i+1)
				@tokens.delete_at(@i-1)
				@i = @i -1

			end
			advance
		end
		@i = 0
		level3
	end
	

	def level3
		while (@i < @tokens.size)
			
			if ( has(:Add)  )
				@tokens[@i] = Add.new(@tokens[@i-1] , @tokens[@i+1] )
				@tokens.delete_at(@i+1)
				@tokens.delete_at(@i-1)
				@i = @i -1
			elsif ( has(:Subtract)  )
				@tokens[@i] = Subtract.new(@tokens[@i-1] , @tokens[@i+1] )
				@tokens.delete_at(@i+1)
				@tokens.delete_at(@i-1)
				@i = @i -1
			end
			advance
		end
		@i = 0
		level2
	end

	def level2
		@i = @tokens.size
		while (@i >= 0)
			
			if ( has(:Not) )
				@tokens[@i] = Not.new(@tokens[@i+1])
				@tokens.delete_at(@i+1)
			elsif ( has(:Negation) )
				@tokens[@i] = Negation.new(@tokens[@i+1])
				@tokens.delete_at(@i+1)
			
			end
			@i = @i - 1
		end
		@i = 0
		level1
	end

	def level1
		while (@i < @tokens.size)
			
			if ( has(:LessThan)  )
				@tokens[@i] = LessThan.new(@tokens[@i-1] , @tokens[@i+1] )
				@tokens.delete_at(@i+1)
				@tokens.delete_at(@i-1)
				@i = @i -1
			elsif ( has(:GreaterThan)  )
				@tokens[@i] = GreaterThan.new(@tokens[@i-1] , @tokens[@i+1] )
				@tokens.delete_at(@i+1)
				@tokens.delete_at(@i-1)
				@i = @i -1
			elsif ( has(:LessThanOrEqual)  )
				@tokens[@i] = LessThanOrEqual.new(@tokens[@i-1] , @tokens[@i+1] )
				@tokens.delete_at(@i+1)
				@tokens.delete_at(@i-1)
				@i = @i -1
			elsif ( has(:GreaterThanOrEqual)  )
				@tokens[@i] = GreaterThanOrEqual.new(@tokens[@i-1] , @tokens[@i+1] )
				@tokens.delete_at(@i+1)
				@tokens.delete_at(@i-1)
				@i = @i -1
			elsif ( has(:Equals)  )
				@tokens[@i] = Equals.new(@tokens[@i-1] , @tokens[@i+1] )
				@tokens.delete_at(@i+1)
				@tokens.delete_at(@i-1)
				@i = @i -1
			elsif ( has(:NotEquals)  )
				@tokens[@i] = NotEquals.new(@tokens[@i-1] , @tokens[@i+1] )
				@tokens.delete_at(@i+1)
				@tokens.delete_at(@i-1)
				@i = @i -1
			end
			advance
		end
		@i = 0
		level0
	end

	def level0
		while (@i < @tokens.size)
			
			if ( has(:And)  )
				@tokens[@i] = And.new(@tokens[@i-1] , @tokens[@i+1] )
				@tokens.delete_at(@i+1)
				@tokens.delete_at(@i-1)
				@i = @i -1
			elsif ( has(:Xor))
				@tokens[@i] = Xor.new(@tokens[@i-1] , @tokens[@i+1] )
				@tokens.delete_at(@i+1)
				@tokens.delete_at(@i-1)
				@i = @i -1
			end
			advance
		end
		@i = 0
	levelN
	end

	def levelN
		while (@i < @tokens.size)
			
			if ( has(:Or)  )
				@tokens[@i] = Or.new(@tokens[@i-1] , @tokens[@i+1] )
				@tokens.delete_at(@i+1)
				@tokens.delete_at(@i-1)
				@i = @i -1
			end
			advance
		end
		@i = 0
		#p @tokens
	@tokens[0]
	end

end