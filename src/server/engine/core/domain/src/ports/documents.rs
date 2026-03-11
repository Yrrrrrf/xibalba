use super::Result;
use crate::entities::document::{DocumentOutput, DocumentRequest};

pub trait DocumentRenderer: Send + Sync {
    async fn render(&self, request: &DocumentRequest) -> Result<DocumentOutput>;
}
