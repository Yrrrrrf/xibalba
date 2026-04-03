use crate::adapters::http::app_state::AppState;
use crate::application::AppResult;
use axum::{Json, Router, extract::State, routing::get};
use serde_json::{Value, json};

pub fn r() -> Router<AppState> {
    Router::new().route("/", get(get_recommendations))
}

async fn get_recommendations(State(_state): State<AppState>) -> AppResult<Json<Value>> {
    Ok(Json(json!([])))
}
