use std::sync::Arc;
use surrealdb::engine::any::connect;
use surrealdb::opt::auth::Root;
use tracing_subscriber::{layer::SubscriberExt, util::SubscriberInitExt};

use crate::adapters::documents::typst::compiler::TypstCompiler;
use crate::adapters::http::app_state::AppState;
use crate::infra::config::AppConfig;
use store::client::SurrealClient;
use store::repos::auth::SurrealAuthRepo;
use store::repos::inventory::SurrealInventoryRepo;

pub fn init_tracing() {
    // In production we would output JSON to a file and pretty logs to stdout
    tracing_subscriber::registry()
        .with(tracing_subscriber::EnvFilter::new(
            std::env::var("RUST_LOG").unwrap_or_else(|_| "info,api=debug".into()),
        ))
        .with(tracing_subscriber::fmt::layer())
        .init();
}

pub async fn init_app_state(config: &AppConfig) -> AppState {
    let db = connect(&config.db_url)
        .await
        .expect("Failed to connect to SurrealDB");

    if let Err(_) = db
        .signin(Root {
            username: "root".to_string(),
            password: "password".to_string(),
        })
        .await
    {
        tracing::warn!("Failed to sign in to DB. Ignore if mock.");
    }

    db.use_ns("test").use_db("test").await.unwrap_or_default();

    let surreal_client = SurrealClient::new(Arc::new(db));

    let auth_repo = Arc::new(SurrealAuthRepo::new(surreal_client.clone()));
    let inventory_repo = Arc::new(SurrealInventoryRepo::new(surreal_client));
    let document_renderer = Arc::new(TypstCompiler::new());

    AppState {
        auth_repo,
        inventory_repo,
        document_renderer,
    }
}
