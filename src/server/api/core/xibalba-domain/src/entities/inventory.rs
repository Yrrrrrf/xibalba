use serde::{Deserialize, Serialize};
use uuid::Uuid;
use chrono::{DateTime, Utc};

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Category {
    pub id: Uuid,
    pub name: String,
    pub description: Option<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Location {
    pub id: Uuid,
    pub name: String,
    pub address: String,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Item {
    pub id: Uuid,
    pub name: String,
    pub sku: String,
    pub category_id: Uuid,
    pub location_id: Uuid,
    pub quantity: i32,
    pub price: f64,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
}
