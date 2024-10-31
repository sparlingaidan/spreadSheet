require './Exp.rb'
require './Parser.rb'
require './Lexer.rb'

#Cell class to hold expressions, thier strings, an adress, and a value
class Cell
    attr_accessor :CellAdress
    attr_accessor :Exp
    attr_accessor :CurrentValue
    attr_accessor :String
    def initialize(cellAdress, rvalue)
        self.CellAdress = cellAdress
        self.Exp = rvalue
        self.CurrentValue = nil
    end 

    def get_val(run)
        visitor = Evaluate.new()
        serial = Serializer.new()
        self.CurrentValue = self.Exp.traverse(visitor, run)
        self.CurrentValue
    end

    def to_s(run)
        visitor = Serializer.new()
        self.Exp.traverse(visitor, run)
    end

end


#The runtime object that holds the grid of cells and provides ways to access them.
class Runtime
    attr_accessor :Grid
    def initialize()
        self.Grid = Hash.new()
    end

    def addCell(cell)
        key = cell.CellAdress.X.to_s + cell.CellAdress.Y.to_s
        self.Grid.merge!({key => cell})
        if(cell.Exp == nil)
            return
        else
            cell.get_val(self)
        end
    end

    def getCell(left, right)
        key = left.to_s + right.to_s
        ret = self.Grid[key]
        if (ret == nil)
            raise 
        end
        ret
    end
    
    def getCellVal(left, right)
        getCell(left,right).get_val(self)
    end

    def getCellString(cell_adress)
        getCell(cell_adress.X, cell_adress.Y).to_s(self)
    end

    def getCellInput(cell_adress)
        getCell(cell_adress.X, cell_adress.Y).String
    end

    def R(cell_adress)
        getCell(cell_adress.X, cell_adress.Y).CurrentValue
    end

    def L(left, right)
        key = left.to_s + right.to_s
        self.Grid[key].CellAddress
    end

    #Method for updating a cell with a string.
    def update(cell_adress, inputText)
        tempCell = getCell(cell_adress.X, cell_adress.Y)
        tempCell.Exp = parselist( lex(inputText) , self)
        tempCell.get_val(self)
    end


end