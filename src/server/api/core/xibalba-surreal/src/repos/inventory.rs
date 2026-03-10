use xibalba_domain::entities::inventory::Item;
use crate::client::SurrealClient;
use uuid::Uuid;

pub struct SurrealInventoryRepo {
    client: SurrealClient,
}

impl SurrealInventoryRepo {
    pub fn new(client: SurrealClient) -> Self {
        Self { client }
    }

    pub async fn create_item(&self, _item: Item) -> Result<(), String> {
        Ok(())
    }

    pub async fn get_item(&self, _id: Uuid) -> Result<Option<Item>, String> {
        Ok(None)
    }

    pub async fn update_stock(&self, _id: Uuid, _quantity: i32) -> Result<(), String> {
        Ok(())
    }

    pub async fn list_items(&self) -> Result<Vec<Item>, String> {
        Ok(vec![])
    }
}
