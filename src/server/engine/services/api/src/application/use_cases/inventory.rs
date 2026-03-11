use crate::application::{AppError, AppResult};
use domain::entities::inventory::Item;
use uuid::Uuid;

pub use domain::ports::inventory::InventoryRepository;

// Similarly, use cases would use these traits.
