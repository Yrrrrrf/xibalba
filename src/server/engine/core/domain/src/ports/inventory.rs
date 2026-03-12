use super::Result;
use crate::entities::inventory::Item;
use uuid::Uuid;

#[trait_variant::make(InventoryRepository: Send)]
pub trait LocalInventoryRepository: Sync {
    async fn create_item(&self, item: Item) -> Result<()>;
    async fn get_item(&self, id: Uuid) -> Result<Option<Item>>;
    async fn update_stock(&self, id: Uuid, quantity: i32) -> Result<()>;
    async fn list_items(&self) -> Result<Vec<Item>>;
}
