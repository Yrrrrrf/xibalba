use trait_variant;

#[trait_variant::make(MyTrait: Send)]
pub trait LocalMyTrait: Sync {
    async fn do_thing(&self) -> i32;
}

pub struct MyStruct;

impl MyTrait for MyStruct {
    async fn do_thing(&self) -> i32 {
        42
    }
}
