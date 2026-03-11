use crate::client::SurrealClient;
use domain::entities::inventory::Item;
use uuid::Uuid;

pub struct SurrealInventoryRepo {
    client: SurrealClient,
}

use domain::ports::DomainError;
use domain::ports::inventory::InventoryRepository;

impl SurrealInventoryRepo {
    pub fn new(client: SurrealClient) -> Self {
        Self { client }
    }
}

impl InventoryRepository for SurrealInventoryRepo {
    async fn create_item(&self, _item: Item) -> Result<(), DomainError> {
        Ok(())
    }

    async fn get_item(&self, _id: Uuid) -> Result<Option<Item>, DomainError> {
        Ok(None)
    }

    async fn update_stock(&self, _id: Uuid, _quantity: i32) -> Result<(), DomainError> {
        Ok(())
    }

    async fn list_items(&self) -> Result<Vec<Item>, DomainError> {
        Ok(vec![])
    }
}
