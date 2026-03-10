use xibalba_domain::entities::document::{DocumentRequest, DocumentOutput};
use crate::application::{AppError, AppResult};

pub trait DocumentRenderer: Send + Sync {
    async fn render(&self, request: &DocumentRequest) -> AppResult<DocumentOutput>;
}
