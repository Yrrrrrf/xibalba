use std::sync::Arc;
use xibalba_surreal::repos::auth::SurrealAuthRepo;
use xibalba_surreal::repos::inventory::SurrealInventoryRepo;
use crate::adapters::documents::typst::compiler::TypstCompiler;

#[derive(Clone)]
pub struct AppState {
    pub auth_repo: Arc<SurrealAuthRepo>,
    pub inventory_repo: Arc<SurrealInventoryRepo>,
    pub document_renderer: Arc<TypstCompiler>,
}
