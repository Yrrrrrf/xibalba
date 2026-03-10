use crate::application::use_cases::documents::DocumentRenderer;
use crate::application::{AppError, AppResult};
use xibalba_domain::entities::document::{DocumentOutput, DocumentRequest};
use chrono::Utc;
use uuid::Uuid;

pub struct TypstCompiler;

impl TypstCompiler {
    pub fn new() -> Self {
        Self
    }
}

impl DocumentRenderer for TypstCompiler {
    async fn render(&self, request: &DocumentRequest) -> AppResult<DocumentOutput> {
        // Here we would interact with the typst crate to compile the template.
        // For the spec, we provide a stub implementation.
        let fake_pdf_bytes = vec![0x25, 0x50, 0x44, 0x46, 0x2d]; // "%PDF-"
        
        Ok(DocumentOutput {
            id: Uuid::new_v4(),
            content: fake_pdf_bytes,
            generated_at: Utc::now(),
            request: request.clone(),
        })
    }
}
