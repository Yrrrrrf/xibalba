use crate::adapters::http::app_state::AppState;
use crate::application::AppResult;
use crate::application::use_cases::documents::DocumentRenderer;
use axum::{Json, Router, extract::State, routing::post};
use domain::entities::document::DocumentRequest;
use serde_json::{Value, json};

pub fn r() -> Router<AppState> {
    Router::new().route("/generate", post(generate_report))
}

async fn generate_report(
    State(state): State<AppState>,
    Json(payload): Json<DocumentRequest>,
) -> AppResult<Json<Value>> {
    let output = state.document_renderer.render(&payload).await?;
    Ok(Json(json!({
        "id": output.id,
        "generated_at": output.generated_at,
        // In a real app we might return the PDF bytes or a URL
        "status": "success",
    })))
}
