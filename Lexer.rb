def lex (inputString)
	tempLexer = Lexer.new(inputString)
    return tempLexer.lex() #list of tokens.
end




#Each lexer is made with one bit of Text
class Lexer
	def initialize(source)
	@source = source 
	@index = 0
	@token_so_far = ''
	@tokens = Array.new()
	end
	
	#asks if the index is a given target
	def has(target)
		return @source[@index] == target
	end
	
	#asks if index is a letter.
	def has_alphabetic
		if(@index >= @source.length())
			return false 
		end
		'a' <= @source[@index] && @source[@index] <= 'z'
	end

	#asks if index is a number.
	def has_numeric
		if(@index >= @source.length())
			return false 
		end
		return ('0' <= @source[@index] && @source[@index] <= '9') | (@source[@index] == ".")
	end
	

	def capture
		@token_so_far += @source[@index]
		@index += 1
	end
	
	def emit_token(type)
		@tokens.push(
		{
		type: type,
		text: @token_so_far,
		})
		@token_so_far = ""
	end
	

	
	def lex
		while(@index < (@source.length()) )
			if has('#')
				capture
				while (! has("]")) & (@index < (@source.length() - 1 ) )
					capture
				end
				capture
				emit_token(:Rvalue)
			elsif has('!')
				capture
				emit_token(:Not)
			elsif has('F')
				capture
				while (! has("e")) & (@index < (@source.length() - 1 ) )
					capture
				end
				capture
				emit_token(:False)
			elsif has('T')
				capture
				while ((! has("e")) & (@index < (@source.length() - 1 ) ))
					capture
				end
				capture
				emit_token(:True)
			elsif has('f')
				capture
				while (! has(")")) & (@index < (@source.length() - 1 ) )
					capture
				end
				capture
				emit_token(:ToFloat)
			elsif has('i')
				capture 
				while ( ! has("t")) & (@index < (@source.length() - 1 ) )
					capture
				end
				capture
				emit_token(:ToInt)
			elsif has('s')
				capture
				while (! has(")")) & (@index < (@source.length() - 1 ) )
					capture
				end
				capture
				emit_token(:Sum)
			elsif has('m')
				capture
				while ( (! has(")")) ) & (@index < (@source.length() - 1 ) )
					capture
				end
				capture

				if(@token_so_far.include?"e")
					emit_token(:Mean)
				elsif(@token_so_far.include?"i")
					emit_token(:Min)
				else
					emit_token(:Max)
				end

			elsif has('}')
				capture
				emit_token(:right_curly)
			elsif has('*')
				capture
				if has('*')
					capture 
					emit_token (:Exponetiation)
				else
					emit_token(:Multiply)
				end
			elsif has('/')
				capture
				emit_token(:Divide)
			elsif has('%')
				capture
				emit_token(:Modulo)
			elsif has('-')#both negation and subtraction.
				capture
				if( @tokens[- 1] == nil ) 
					emit_token(:Negation)
				elsif( (@tokens[-1][:type] != :Int)  ) 
					emit_token(:Negation)
				else
					emit_token(:Subtract)
				end
			elsif has('+')
				capture
				emit_token(:Add)
			elsif has('(')
				capture
				emit_token(:left_parenthesis) 
			elsif has(')')
				capture
				emit_token(:right_parenthesis)
			elsif has('<')
				capture
				emit_token(:LessThan) 
			elsif has('>')
				capture
				emit_token(:GreaterThan)
			elsif has('<=')
				capture
				emit_token(:LessThanOrEqual) 
			elsif has('>=')
				capture
				emit_token(:GreaterThanOrEqual)
			elsif has('==')
				capture
				emit_token(:Equals) 
			elsif has('!=')
				capture
				emit_token(:NotEquals)
			elsif has('&')
				capture
				if (has("&"))
					capture
				end
				emit_token(:And)
			elsif has('|')
				capture
				emit_token(:Or)
			elsif has('^')
				capture
				emit_token(:Xor)
			elsif has("\n")
				capture
				emit_token(:linebreak)
			elsif has_numeric()
				while has_numeric()
					capture
				end
				if (@token_so_far.include?".")
					emit_token(:Float)
				else
					emit_token(:Int)
				end
			elsif has_alphabetic()
				while has_alphabetic()
					capture
				end
				emit_token(:String)
			elsif has(' ')
				@index += 1
			else 
				emit_token(:Error)
				@index += 1
			end
		end


	@tokens
	end



end
