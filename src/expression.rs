//I have no clue how to use rust!
#[derive(Default)]
pub struct Node{
	pub Type: Type,
	pub Value: String,
	pub Left: Option<Box<Node>>,
	pub Right: Option<Box<Node>>,	
}

pub struct CellAddress{
	pub x: i3
}


pub enum Type{
	Float,
	Integer,
	Boolean,
	String,
	Add,
}
impl Default for Type{
	fn default() -> Self {Type::String}
}




