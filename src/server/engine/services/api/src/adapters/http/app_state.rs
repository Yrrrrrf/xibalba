use crate::adapters::documents::typst::compiler::TypstCompiler;
use std::sync::Arc;
use store::repos::auth::SurrealAuthRepo;
use store::repos::inventory::SurrealInventoryRepo;

#[derive(Clone)]
pub struct AppState {
    pub auth_repo: Arc<SurrealAuthRepo>,
    pub inventory_repo: Arc<SurrealInventoryRepo>,
    pub document_renderer: Arc<TypstCompiler>,
}
