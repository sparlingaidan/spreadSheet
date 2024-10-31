require './Exp.rb'

#Class for evaluating an expression.
class Evaluate
        attr_accessor :valSoFar
        attr_accessor :callingClass
        def initialize()
                @valSoFar
        end

        def integerOps(left, right)
                if (callingClass == Add)
                        IntegerPrimitive.new(left.Val + right.Val)
                elsif (callingClass == Subtract)
                        IntegerPrimitive.new(left.Val - right.Val)
                elsif (callingClass == Multiply)
                        IntegerPrimitive.new(left.Val * right.Val)
                elsif (callingClass == Divide)
                        IntegerPrimitive.new(left.Val / right.Val)
                elsif (callingClass == Mod)
                        IntegerPrimitive.new(left.Val % right.Val)
                elsif (callingClass == Exponetiation)
                        IntegerPrimitive.new(left.Val ** right.Val)
                elsif (callingClass == And)
                        IntegerPrimitive.new(left.Val & right.Val)
                elsif (callingClass == Or)
                        IntegerPrimitive.new(left.Val | right.Val)
                elsif (callingClass == Not)
                        IntegerPrimitive.new(left.Val ! right.Val)
                elsif (callingClass == Xor)
                        IntegerPrimitive.new(left.Val ^ right.Val)
                elsif (callingClass == LeftShift)
                        IntegerPrimitive.new(left.Val << right.Val)
                elsif (callingClass == RightShift)
                        IntegerPrimitive.new(left.Val >> right.Val)
                elsif (callingClass == Equals)
                        BooleanPrimitive.new(left.Val != right.Val)
                elsif (callingClass == NotEquals)
                        BooleanPrimitive.new(left.Val != right.Val)
                elsif (callingClass == LessThan)
                        BooleanPrimitive.new(left.Val < right.Val)
                elsif (callingClass == GreaterThan)
                        BooleanPrimitive.new(left.Val > right.Val)
                elsif (callingClass == LessThanOrEqual)
                        BooleanPrimitive.new(left.Val <= right.Val)
                elsif (callingClass == GreaterThanOrEqual)
                        BooleanPrimitive.new(left.Val >= right.Val)
                elsif (callingClass == Negation)
                        IntegerPrimitive.new(-1 * left.Val)
                elsif (callingClass == ToFloat)
                        FloatPrimitive.new(left.Val)
                else
                        raise ArgumentError
                end
        end

        def floatOps(left ,right)
                if (callingClass == Add)
                        FloatPrimitive.new(left.Val.to_f + right.Val.to_f)
                elsif (callingClass == Subtract)
                        FloatPrimitive.new(left.Val.to_f - right.Val.to_f)
                elsif (callingClass == Multiply)
                        FloatPrimitive.new(left.Val.to_f * right.Val.to_f)
                elsif (callingClass == Divide)
                        FloatPrimitive.new(left.Val.to_f / right.Val.to_f)
                elsif (callingClass == Mod)
                        FloatPrimitive.new(left.Val.to_f % right.Val.to_f)
                elsif (callingClass == Exponetiation)
                        FloatPrimitive.new(left.Val.to_f ^ right.Val.to_f)
                elsif ((callingClass == Negation) & (right == -1))
                        FloatPrimitive.new(-1 * left.Val.to_f)
                elsif (callingClass == Equals)
                        BooleanPrimitive.new(left.Val != right.Val)
                elsif (callingClass == NotEquals)
                        BooleanPrimitive.new(left.Val != right.Val)
                elsif (callingClass == LessThan)
                        BooleanPrimitive.new(left.Val < right.Val)
                elsif (callingClass == GreaterThan)
                        BooleanPrimitive.new(left.Val > right.Val)
                elsif (callingClass == LessThanOrEqual)
                        BooleanPrimitive.new(left.Val <= right.Val)
                elsif (callingClass == GreaterThanOrEqual)
                        BooleanPrimitive.new(left.Val >= right.Val)
                elsif (callingClass == ToInt)
                        IntPrimitive.new(left.Val.to_i)
                else
                        raise ArgumentError
                end
        end

        def booleanOps(left, right)
                if ( callingClass == Or)
                        BooleanPrimitive.new(left.Val | right.Val)
                elsif ( callingClass == And)
                        BooleanPrimitive.new(left.Val & right.Val)
                elsif ((callingClass == Not) & (right == -1))
                        BooleanPrimitive.new(!left.Val)
                else
                        raise ArgumentError
                end
        end

        def statOps(left, right, run)
                if (callingClass == Sum)
                        total = 0
                        float = false
                        for y in (left.Y .. right.Y) do
                                for x in ( left.X .. right.X)do
                                        cell = run.getCellVal(x,y)
                                        if ( cell.class == FloatPrimitive)
                                                float = true
                                        elsif( cell.class == IntegerPrimitive)
                                        else
                                                raise "Invalid Operands"
                                        end
                                        total = total + cell.Val
                                end
                        end
                        if(float)
                                FloatPrimitive.new(total)
                        else
                                IntegerPrimitive.new(total)
                        end
                elsif(callingClass == Mean)
                                count = 0
                                total = 0
                                for y in (left.Y .. right.Y) do
                                        for x in ( left.X .. right.X)do
                                                cell = run.getCellVal(x,y)
                                                if( ! ((cell.class == FloatPrimitive) | (cell.class == IntegerPrimitive)))
                                                        raise "Invalid Operands"
                                                end
                                                total = total + cell.Val
                                                count = count + 1
                                        end
                                end
                                FloatPrimitive.new(total.to_f / count)


                elsif(callingClass == Min)
                                sofar = nil
                                float = false
                                for y in (left.Y .. right.Y) do
                                        for x in ( left.X .. right.X)do
                                                cell = run.getCellVal(x,y)
                                                if ( cell.class == FloatPrimitive)
                                                        float = true
                                                elsif( cell.class == IntegerPrimitive)
                                                else
                                                        raise "Invalid Operands"
                                                end
                                                if(sofar == nil)
                                                        sofar = cell.Val
                                                elsif((cell.Val < sofar))
                                                        sofar = cell.Val
                                                end
                                        end
                                end
                                if(float)
                                        FloatPrimitive.new(sofar)
                                else
                                        IntegerPrimitive.new(sofar)
                                end

                elsif(callingClass == Max)
                                sofar = nil
                                float = false
                                for y in (left.Y .. right.Y) do
                                        for x in ( left.X .. right.X)do
                                                cell = run.getCellVal(x,y)
                                                if ( cell.class == FloatPrimitive)
                                                        float = true
                                                elsif( cell.class == IntegerPrimitive)
                                                else
                                                        raise "Invalid Operands"
                                                end
                                                if(sofar == nil)
                                                        sofar = cell.Val
                                                elsif((cell.Val > sofar))
                                                        sofar = cell.Val
                                                end
                                        end
                                end
                                if(float)
                                        FloatPrimitive.new(sofar)
                                else
                                        IntegerPrimitive.new(sofar)
                                end
                        
                else
                        raise ArgumentError
                end

        end

        def stringOps(left , right)
                if (callingClass == Add)
                        left.Val + right.Val
                else
                        raise ArgumentError
                end
        end

        #Visit method for cheching if operations can be performed on the types given
        def visit(left, right, run)
                if((left.class == IntegerPrimitive) & (right.class == IntegerPrimitive))
                        integerOps(left, right)
                elsif((left.class == IntegerPrimitive) & (right.class == NilClass))
                        integerOps(left, -1)#-1 used to enforce that only negation is called with one operand
                elsif((left.class == BooleanPrimitive) & (right.class == BooleanPrimitive))
                        booleanOps(left, right)
                elsif((left.class == BooleanPrimitive) & (right.class == NilClass))
                        booleanOps(left, -1)#-1 used to enforce that only not is called with one operand
                elsif(((left.class ==  FloatPrimitive) & (right.class == FloatPrimitive)) |((left.class ==  IntegerPrimitive) & (right.class == FloatPrimitive)) | ((left.class ==  FloatPrimitive) & (right.class == IntegerPrimitive)))
                        floatOps(left, right)
                elsif((left.class ==  FloatPrimitive) & (right.class == NilClass))
                        floatOps(left, -1)
                elsif((left.class == CellAddress) & (right.class == CellAddress))
                        statOps(left, right, run)
                else
                        raise ArgumentError
                end
        end
end

#class for creating string representations of expressions.
class Serializer
        attr_accessor :strSoFar
        attr_accessor :callingClass
        def initialize()
                @strSoFar = ""
        end

        def visit(left, right, run)
                if (callingClass == Add)
                        strSoFar + "(+ "  + left.to_s + " " +  right.to_s + ")"
                elsif (callingClass == Subtract)
                        strSoFar + "(- " + left.to_s + " " +  right.to_s + ")"
                elsif (callingClass == Multiply)
                        strSoFar + "(* " + left.to_s + " " +  right.to_s + ")"
                elsif (callingClass == Divide)
                        strSoFar + "(/ " + left.to_s + " " +  right.to_s + ")"
                elsif (callingClass == Mod)
                        strSoFar + "(% " + left.to_s + " " +  right.to_s + ")"
                elsif (callingClass == Exponetiation)
                        strSoFar + "(^ " + left.to_s + " " +  right.to_s + ")"
                elsif (callingClass == Negation)
                        strSoFar + "(- " + left.to_s + " " +  right.to_s + ")"
                elsif (callingClass == Or)
                        strSoFar + "(| " + left.to_s + " " +  right.to_s + ")"
                elsif (callingClass == And)
                        strSoFar + "(& " + left.to_s + " " +  right.to_s + ")"
                elsif (callingClass == Not)
                        strSoFar + "(! " + left.to_s + " " +  right.to_s + ")"
                elsif (callingClass == Xor)
                        strSoFar + "(xor " + left.to_s + " " +  right.to_s + ")"
                elsif (callingClass == LeftShift)
                        strSoFar + "(<< " + left.to_s + " " +  right.to_s + ")"
                elsif (callingClass == RightShift)
                        strSoFar + "(>> " + left.to_s + " " +  right.to_s + ")"
                elsif (callingClass == Equals)
                        strSoFar + "(== " + left.to_s + " " +  right.to_s + ")"
                elsif (callingClass == NotEquals)
                        strSoFar + "(!= " + left.to_s + " " +  right.to_s + ")"
                elsif (callingClass == LessThan)
                        strSoFar + "(< " + left.to_s + " " +  right.to_s + ")"
                elsif (callingClass == GreaterThan)
                        strSoFar + "(> " + left.to_s + " " +  right.to_s + ")"
                elsif (callingClass == LessThanOrEqual)
                        strSoFar + "(<= " + left.to_s + " " +  right.to_s + ")"
                elsif (callingClass == GreaterThanOrEqual)
                        strSoFar + "(>= " + left.to_s + " " +  right.to_s + ")"
                elsif (callingClass == Sum)
                        strSoFar + "(sum (" + left.X.to_s + "," + left.Y.to_s + ") (" + right.Y.to_s + "," + right.X.to_s + ")"
                elsif (callingClass == Mean)
                        strSoFar + "(mean (" + left.X.to_s + "," + left.Y.to_s + ") (" + right.Y.to_s+ ","  + right.X.to_s + ")"
                elsif (callingClass == Min)
                        strSoFar + "(min (" + left.X.to_s + "," + left.Y.to_s + ") (" + right.Y.to_s + "," + right.X.to_s + ")"
                elsif (callingClass == Max)
                        strSoFar + "(max (" + left.X.to_s + "," + left.Y.to_s + ") (" + right.Y.to_s + "," + right.X.to_s + ")"
                elsif (callingClass == ToFloat)
                        strSoFar + "(flaot " + left.to_s + ")"
                else
                        raise ArgumentError
                end
                
        end
        
end