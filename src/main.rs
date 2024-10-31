mod expression;
mod visitor;
mod grid;
use core::ptr::copy;

fn main() {
	// add integer
    //let m = expression::make_integer("5");
	
    //let m2 = expression::make_integer("55");
    //let d = expression::make_integer("55");
	//let x = expression::make_add(m, m2);
	//println!("{}",x.left.value);
	//println!("{}",visitor::serializer(x));
	//let xx = expression::make_add(dd,x);
	//println!("{}",visitor::serializer(xx));
	let ret6 = expression::Node{
		Type: expression::Type::CellAddress,
		Value: "6,6".to_string(),
		Left: None,
		Right: None,
	};


	let add = expression::Node{
		Type: expression::Type::Add,
		Value: "+".to_string(),
		Left: Some(Box::new(expression::Node{
			Type: expression::Type::Float,
			Value: "5".to_string(),
			Left: None,
			Right: None,
		})),
		Right: None,
	};

	let cl = grid::Cell{
		Addy: ret6,
		Root: add,
		StringRep: "10".to_string(),
	};

	println!("{}:ret.value", add.Value);
	println!("{}:ret.value", add.Left.unwrap().Value);


}
