use serde::{Deserialize, Serialize};
use uuid::Uuid;
use chrono::{DateTime, Utc};
use serde_json::Value;

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct DocumentRequest {
    pub template: String,
    pub data: Value,
    pub user_id: Uuid,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct DocumentOutput {
    pub id: Uuid,
    pub content: Vec<u8>,
    pub generated_at: DateTime<Utc>,
    pub request: DocumentRequest,
}
