use super::Result;
use crate::entities::document::{DocumentOutput, DocumentRequest};

#[trait_variant::make(DocumentRenderer: Send)]
pub trait LocalDocumentRenderer: Sync {
    async fn render(&self, request: &DocumentRequest) -> Result<DocumentOutput>;
}
