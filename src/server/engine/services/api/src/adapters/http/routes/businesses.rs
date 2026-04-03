use crate::adapters::http::app_state::AppState;
use crate::application::AppResult;
use axum::{Json, Router, extract::State, routing::get};
use serde_json::{Value, json};

pub fn r() -> Router<AppState> {
    Router::new()
        .route("/near", get(find_near))
        .route("/search", get(search))
        .route("/:id", get(get_by_id))
}

async fn find_near(State(_state): State<AppState>) -> AppResult<Json<Value>> {
    Ok(Json(json!([])))
}

async fn search(State(_state): State<AppState>) -> AppResult<Json<Value>> {
    Ok(Json(json!([])))
}

async fn get_by_id(State(_state): State<AppState>) -> AppResult<Json<Value>> {
    Ok(Json(json!({})))
}
