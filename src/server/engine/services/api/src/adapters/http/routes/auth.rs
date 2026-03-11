use crate::adapters::http::app_state::AppState;
use crate::application::AppResult;
use axum::{Json, Router, extract::State, routing::post};
use serde_json::{Value, json};

pub fn r() -> Router<AppState> {
    Router::new()
        .route("/login", post(login))
        .route("/refresh", post(refresh))
}

async fn login(
    State(_state): State<AppState>,
    Json(payload): Json<Value>,
) -> AppResult<Json<Value>> {
    // Basic stub
    Ok(Json(json!({"token": "stub_token"})))
}

async fn refresh(
    State(_state): State<AppState>,
    Json(payload): Json<Value>,
) -> AppResult<Json<Value>> {
    Ok(Json(json!({"token": "new_stub_token"})))
}
