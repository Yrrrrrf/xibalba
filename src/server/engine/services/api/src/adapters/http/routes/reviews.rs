use crate::adapters::http::app_state::AppState;
use crate::application::AppResult;
use axum::{
    Json, Router,
    extract::State,
    routing::{get, post},
};
use serde_json::{Value, json};

pub fn r() -> Router<AppState> {
    Router::new()
        .route("/:business_id", get(list_for_business))
        .route("/", post(create))
}

async fn list_for_business(State(_state): State<AppState>) -> AppResult<Json<Value>> {
    Ok(Json(json!([])))
}

async fn create(State(_state): State<AppState>) -> AppResult<Json<Value>> {
    Ok(Json(json!({"status": "created"})))
}
