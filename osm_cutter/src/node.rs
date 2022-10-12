#[derive(Clone, Debug)]
pub struct Node {
    pub id: String,
    pub lat: String,
    pub lon: String
}

impl Node {
    pub fn new(id: String, lat: String, lon: String) -> Self { Self { id, lat, lon } }
}