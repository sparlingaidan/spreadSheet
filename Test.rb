require './Exp.rb'
require './Grid.rb'
require './Visit.rb'
require './Parser.rb'
require './Lexer.rb'

#new Intege primatives
five = IntegerPrimitive.new(5)
two = IntegerPrimitive.new(2)
three = IntegerPrimitive.new(3)
four = IntegerPrimitive.new(4)
seven = IntegerPrimitive.new(7)
twelve = IntegerPrimitive.new(12)
one = IntegerPrimitive.new(1)


#new operations
#visitor init
payload = nil
visitorS = Serializer.new()
visitorE = Evaluate.new()
#          negation
#             |
#          Multiply
#          /      \
#       prim 3    Add
#                /    \
#            prim 5   prim 2
add = Add.new(five,two)
#p five.Val
multt = Multiply.new(three, add)
neg = Negation.new(multt)
#print "traverse add: "
#p add.traverse(visitorS,payload) #traverse add and print
eadd = add.traverse(visitorE,payload)
#p eadd.Val
#print "traverse multiply: "
#p multt.traverse(visitorS,payload) #traverse multt and print
multttrav = multt.traverse(visitorE,payload)
#p multttrav.Val
#print "traverse negation: "
#p neg.traverse(visitorS,payload) #traverse negation
negtrav = neg.traverse(visitorE,payload)
#p negtrav.Val
#String text = tree.traverse(new Serializer(), null);



#new boolean primitives
tr = BooleanPrimitive.new(true)
fl = BooleanPrimitive.new(false)
#             Not
#              |
#             And
#           /     \
#         true    or
#                /   \
#              true  false
ur = Or.new(tr,fl)
nd = And.new(tr, ur)
nt = Not.new(nd)
#print "traverse or: "
urtrav = ur.traverse(visitorE, payload)
#p urtrav.Val
#p ur.traverse(visitorS, payload)
#print "traverse and: "
ndtrav = nd.traverse(visitorE, payload)
#p ndtrav.Val
#p nd.traverse(visitorS, payload)
#print "traverse not: "
nttrav = nt.traverse(visitorE, payload)
#p nttrav.Val
#p nt.traverse(visitorS, payload)

#add expressions to grid.
ad22 = CellAddress.new(2, 2)
ad23 = CellAddress.new(2, 3)
ad24 = CellAddress.new(2, 4)
ad32= CellAddress.new(3, 2)
ad33 = CellAddress.new(3, 3)
ad34 = CellAddress.new(3, 4)
cell22 = Cell.new(ad22, multt)
cell23 = Cell.new(ad23,add)
run = Runtime.new()
run.addCell(cell22)
run.addCell(cell23)

#Tests from the textbook
#             Mod
#           /     \
#         add    prim 12
#        /    \
#  Multiply   prim 3
#    /     \
# prim 7   prim 4 
q1mult = Multiply.new(seven, four)
q1add = Add.new(q1mult, three)
q1mod = Mod.new(q1add, twelve)

print "q1 mult add and mod\n"

run.addCell(Cell.new(CellAddress.new(1,20), q1mod))
p run.R(CellAddress.new(1,20))
p run.getCellString(CellAddress.new(1,20))

print "\n\n"

rValAddeq =  Multiply.new(CellAddress.new(2, 2), Negation.new(CellAddress.new(2, 3)))
rValAdd = Cell.new(ad34, rValAddeq)
run.addCell(rValAdd)
print "q2 rvalue negation: \n"
p run.R(ad34)
p run.getCellString(ad34)

print "\n\n"

lsh = LeftShift.new(CellAddress.new(1 + one.Val,2), three)
print "q3 rvalue lookup and left shift\n"
addcell24 = Cell.new(ad24, lsh)
p run.addCell(addcell24)
p run.getCellString(ad24)

print "\n\n"

print "q4 rvalue lookup and comparison\n"
lcmp = LessThan.new(CellAddress.new(2, 2), CellAddress.new(2, 3))
q4cell = Cell.new(CellAddress.new(15,1), lcmp)
p run.addCell(q4cell)
p run.getCellString(CellAddress.new(15,1))

print "\n\n"

print"q5 logic and comparison\n"
lngt = Not.new(GreaterThan.new(FloatPrimitive.new(3.3), FloatPrimitive.new(3.2)))
lngtCell = Cell.new(CellAddress.new(14,1), lngt)
p run.addCell(lngtCell)
p run.getCellString(CellAddress.new(14,1))

print "\n\n"

print "sum area of cells\n"
sm = Sum.new(CellAddress.new(2,2), CellAddress.new(2,3))
run.addCell(Cell.new(ad33,sm))
p run.R(ad33)
p run.getCellString(ad33)

print "\n\n"

print "Mean area of cells\n"
mne = Mean.new(CellAddress.new(2,2), CellAddress.new(2,3))
run.addCell(Cell.new(CellAddress.new(1,3), mne))
p run.R(CellAddress.new(1,3))
p run.getCellString(CellAddress.new(1,3))

print "\n\n"

print "Min area of cells\n"
mn = Min.new(CellAddress.new(2,2), CellAddress.new(2,3))
run.addCell(Cell.new(CellAddress.new(1,1),mn))
p run.R(CellAddress.new(1,1))
p run.getCellString(CellAddress.new(1,1))


print "\n\n"

print "Max area of cells\n"
mx = Max.new(CellAddress.new(2,2), CellAddress.new(2,3))
run.addCell(Cell.new(CellAddress.new(1,2),mx))
p run.R(CellAddress.new(1,2))
p run.getCellString(CellAddress.new(1,2))

print "\n\n"

print "Casting to float\n"
castingDiv = Divide.new(ToFloat.new(three), two)
run.addCell(Cell.new(CellAddress.new(2,8), castingDiv))
p run.R(CellAddress.new(2,8))
p run.getCellString(CellAddress.new(2,8))

print "\n\n"

begin
    failcell = Cell.new(CellAddress.new(2,9), Add.new(three, tr))
    run.addCell(failcell)
rescue ArgumentError => e
    print "Raised ArgumentError\n"
else
    print "failed to fail\n"
end

begin
    failcell2 = Cell.new(CellAddress.new(2,10), LeftShift.new(LessThanOrEqual.new(tr, three)))
    run.addCell(failcell2)
rescue ArgumentError => e
    print "Raised ArgumentError\n"
else
    print "failed to fail\n"
end

begin
    failcell3 = Cell.new(CellAddress.new(2,11), Mean.new(CellAddress.new(2,2), CellAddress.new(2,13)))
    run.addCell(failcell3)
rescue RuntimeError => e
    print "Raised RuntimeError\n"
else
    print "failed to fail\n"
end

print "\n\n"


Basic = "3 + 4 * 5"
Arithmetic = "((55 + 2)) * 3 % 4"
Rvaluelookupandshift=  "#[2, 11] + 3"
Rvaluelookupandcomparison = "#[3 - 1, 11] < #[1 * 1 + 1 , 12]"
Logicandcomparison = "(5 > 3) && !(2 > 8)"
SumToTree = "1 + sum([2, 2], [2, 3])"
Casting = "float(10) / 4.0"
ImplicitCasting = "10.0 / 4.0"
Exponentiation = "2 ** 3 ** 2"
Negationandbitwiseand = "45 & ---(1 + 3)"


cellforcomp = Cell.new(CellAddress.new(2,12), nil)
run.addCell(cellforcomp)
print "Text input: " + Basic + "\n"
run.update(CellAddress.new(2,12) , Basic)
p run.R(CellAddress.new(2,12))
p run.getCellString(CellAddress.new(2,12))

print "\n\n"

print "Text input: " + Arithmetic + "\n"
run.update(CellAddress.new(2,11) , Arithmetic)
p run.R(CellAddress.new(2,11))
p run.getCellString(CellAddress.new(2,11))

print "\n\n"

print "Text input: " + Rvaluelookupandshift + "\n"
run.update(CellAddress.new(2,11) , Rvaluelookupandshift)
p run.R(CellAddress.new(2,11))
p run.getCellString(CellAddress.new(2,11))

print "\n\n"

print "Text input: " + Rvaluelookupandcomparison + "\n"
run.update(CellAddress.new(2,11) , Rvaluelookupandcomparison)
p run.R(CellAddress.new(2,11))
p run.getCellString(CellAddress.new(2,11))

print "\n\n"

print "Text input: " + Logicandcomparison + "\n"
run.update(CellAddress.new(2,11) , Logicandcomparison)
p run.R(CellAddress.new(2,11))
p run.getCellString(CellAddress.new(2,11))

print "\n\n"

print "Text input: " + SumToTree + "\n"
run.update(CellAddress.new(2,11) , SumToTree)
p run.R(CellAddress.new(2,11))
p run.getCellString(CellAddress.new(2,11))

print "\n\n"

print "Text input: " + ImplicitCasting + "\n"
run.update(CellAddress.new(2,11) , ImplicitCasting)
p run.R(CellAddress.new(2,11))
p run.getCellString(CellAddress.new(2,11))

print "\n\n"

print "Text input: " + Casting + "\n"
run.update(CellAddress.new(2,11) , Casting)
p run.R(CellAddress.new(2,11))
p run.getCellString(CellAddress.new(2,11))


print "\n\n"

print "Text input: " + Exponentiation + "\n"
run.update(CellAddress.new(2,11) , Exponentiation)
p run.R(CellAddress.new(2,11))
p run.getCellString(CellAddress.new(2,11))

print "\n\n"

print "Text input: " + Negationandbitwiseand + "\n"
run.update(CellAddress.new(2,11) , Negationandbitwiseand)
p run.R(CellAddress.new(2,11))
p run.getCellString(CellAddress.new(2,11))





print "\n\n"

ErrorStringOne = "5 + true"
print "Text input: " + ErrorStringOne + "\n"
begin
    run.update(CellAddress.new(2,11) , ErrorStringOne)
rescue ArgumentError => e
    print "Raised ArgumentError\n"
else
    print "failed to fail\n"
end
p run.getCellString(CellAddress.new(2,11))



print "\n\n"

ErrorStringThree = "False | $"
print "Text input: " + ErrorStringThree + "\n"
begin
    run.update(CellAddress.new(2,11) , ErrorStringThree)
rescue SyntaxError => e
    print "Raised SyntaxError\n"
else
    print "failed to fail\n"
end
p run.R(CellAddress.new(2,11))
p run.getCellString(CellAddress.new(2,11))

