use crate::adapters::http::app_state::AppState;
use crate::application::AppResult;
use axum::{
    Json, Router,
    extract::{Path, State},
    routing::{get, post},
};
use domain::ports::inventory::InventoryRepository;
use serde_json::{Value, json};
use uuid::Uuid;

pub fn r() -> Router<AppState> {
    Router::new()
        .route("/", get(list_items).post(create_item))
        .route("/{id}", get(get_item))
}

async fn list_items(State(state): State<AppState>) -> AppResult<Json<Value>> {
    let items = state.inventory_repo.list_items().await?;
    Ok(Json(json!(items)))
}

async fn create_item(
    State(_state): State<AppState>,
    Json(payload): Json<Value>,
) -> AppResult<Json<Value>> {
    Ok(Json(json!({"status": "created"})))
}

async fn get_item(State(_state): State<AppState>, Path(id): Path<Uuid>) -> AppResult<Json<Value>> {
    Ok(Json(json!({"id": id})))
}
