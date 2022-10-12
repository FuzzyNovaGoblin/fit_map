use const_names::*;
use node::Node;
use project_root::get_project_root;
use std::{error::Error, fs, path::Path};
use xml::reader::{EventReader, XmlEvent};

mod const_names;
mod node;

fn main() -> Result<(), Box<dyn Error>> {
    let data_file = fs::File::open(format!(
        "{}/map.osm",
        get_project_root()?.to_str().unwrap_or(".")
    ))?;

    let mut nodes: Vec<Node> = Vec::new();
    let mut valid_nodes: Vec<Node> = Vec::new();

    let mut working_way = Vec::new();
    let mut in_way: bool = false;
    let mut way_is_valid = false;

    let parser = EventReader::new(data_file);

    for e in parser {
        match e {
            Ok(XmlEvent::StartElement {
                name, attributes, ..
            }) => {
                if name.to_string() == WAY_NAME {
                    in_way = true;
                    working_way = Vec::new();
                } else if in_way {
                    if name.to_string() == ND_NAME {
                        for attr in attributes {
                            if attr.name.to_string() == REF_NAME {
                                working_way.push(attr.value);
                            }
                        }
                    } else if name.to_string() == TAG_NAME {
                        for attr in attributes {
                            if attr.value.to_string().contains("cycle") || attr.value.to_string().contains("footway") {
                                way_is_valid = true;
                            }
                        }
                    }
                } else if name.to_string() == NODE_NAME {
                    let mut lat = String::new();
                    let mut lon = String::new();
                    let mut id = String::new();
                    for attr in attributes {
                        match attr.name.to_string() {
                            name if name == LAT_NAME => lat = attr.value,
                            name if name == LON_NAME => lon = attr.value,
                            name if name == ID_NAME => id = attr.value,
                            _ => (),
                        }
                    }
                    nodes.push(Node::new(id, lat, lon));
                }
            }
            Ok(XmlEvent::EndElement { name }) => {
                if name.to_string() == WAY_NAME {
                    in_way = false;
                    if way_is_valid {
                        for node_id in working_way.drain(..) {
                            for node in nodes.iter() {
                                if node.id == node_id {
                                    valid_nodes.push(node.clone());
                                    break;
                                }
                            }
                        }
                    }
                    way_is_valid = false;
                }
            }

            Err(e) => {
                println!("Error: {}", e);
                break;
            }
            _ => {}
        }
    }

    let mut contents = String::from("List data = [");
    for node in valid_nodes {
        println!("node: {:?}", node);
        contents.push_str(format!("Coord({},  {}),\n", node.lat, node.lon).as_str());
    }
    contents.push_str("];");

    if let Err(e) = fs::write(
        Path::new(format!("{}/data.dart", get_project_root()?.to_str().unwrap_or(".")).as_str()),
        contents,
    ) {
        println!("faid to write file\t{:?}", e);
    }

    Ok(())
}
