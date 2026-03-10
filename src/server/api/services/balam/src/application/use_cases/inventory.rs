use uuid::Uuid;
use xibalba_domain::entities::inventory::Item;
use crate::application::{AppError, AppResult};

pub trait InventoryRepository: Send + Sync {
    async fn create_item(&self, item: Item) -> AppResult<()>;
    async fn get_item(&self, id: Uuid) -> AppResult<Option<Item>>;
    async fn update_stock(&self, id: Uuid, quantity: i32) -> AppResult<()>;
    async fn list_items(&self) -> AppResult<Vec<Item>>;
}

// Similarly, use cases would use these traits.
