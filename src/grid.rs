 
use crate::expression::Node;
use crate::expression::CellAddress;

 pub struct Cell{
    pub Addy: CellAddress,
    pub Root: Node,
    pub StringRep: String,
}
