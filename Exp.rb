
#Expression class for all values that expressions share.
class Experession
    attr_accessor :Val
    def traverse(vistor, payload)
        self
    end

    def initialize(val)
        self.Val = val
    end

    def to_s
        self.Val.to_s
    end
end

class IntegerPrimitive < Experession
end
class FloatPrimitive < Experession
end
class BooleanPrimitive  < Experession
end
class StringPrimitive < Experession
end

#Cell address has an R value for traversals.
class CellAddress < Experession
    attr_accessor :X
    attr_accessor :Y
    attr_accessor :R
    def initialize( x, y)
        self.X = x
        self.Y = y
        self.R = nil
    end

    def traverse(visitor, payload)
        self.R = payload.getCellVal(self.X, self.Y)
        self.R
    end

end


#Operations
class Operation < Experession
    attr_accessor :Left
    attr_accessor :Right
    attr_accessor :Val
    def initialize( left, right)
        self.Left = left
        self.Right = right
    end

    def traverse(visitor, payload)
        a = self.Left.traverse(visitor, payload)
        b = self.Right.traverse(visitor, payload)
        visitor.callingClass = self.class
        self.Val = visitor.visit(a, b, payload)
        self.Val
    end
end
class Add < Operation
end
class Subtract < Operation
end
class Multiply < Operation
end
class Divide < Operation
end
class Mod < Operation
end
class Exponetiation < Operation
end

#Float only accepts one parameter
class ToFloat < Experession
    attr_accessor :Left
    def initialize( left)
        self.Left = left
    end
    def traverse(visitor, payload)
        a = self.Left.traverse(visitor, payload)
        b = nil
        visitor.callingClass = self.class
        self.Val = visitor.visit(a, b, payload)
        self.Val
    end
end

#Int only accepts one parameter
class ToInt < Experession
    attr_accessor :Left
    def initialize( left)
        self.Left = left
    end
    def traverse(visitor, payload)
        a = self.Left.traverse(visitor, payload)
        b = nil
        visitor.callingClass = self.class
        self.Val = visitor.visit(a, b, payload)
        self.Val
    end
end

#Negation only accepts one parameter
class Negation < Experession
    attr_accessor :Left
    def initialize( left)
        self.Left = left
    end
    def traverse(visitor, payload)
        a = self.Left.traverse(visitor, payload)
        b = nil
        visitor.callingClass = self.class
        self.Val = visitor.visit(a, b, payload)
        self.Val
    end
end
class Or < Operation
end
class And < Operation
end
#Not only accepts one parameter
class Not < Experession
    attr_accessor :Left
    def initialize( left)
        self.Left = left
    end

    def traverse(visitor, payload)
        a = self.Left.traverse(visitor, payload)
        b = nil
        visitor.callingClass = self.class
        self.Val = visitor.visit(a, b, payload)
        self.Val
    end

end
class Xor < Operation
end
class LeftShift < Operation
end
class RightShift < Operation
end
class Equals < Operation
end
class NotEquals < Operation
end
class LessThan < Operation
end
class GreaterThan < Operation
end
class LessThanOrEqual < Operation
end
class GreaterThanOrEqual < Operation
end
#StatFunct abstraction for setting up the traversals of other cells.
class StatFunct < Operation
    def traverse(visitor, payload)
        visitor.callingClass = self.class
        self.Val = visitor.visit(self.Left, self.Right, payload)
        self.Val
    end
end
class Sum < StatFunct
end
class Mean < StatFunct
end
class Min < StatFunct
end
class Max < StatFunct
end


