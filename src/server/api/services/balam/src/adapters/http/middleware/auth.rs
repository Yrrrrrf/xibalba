use axum::{
    extract::{Request, State},
    http::{header, StatusCode},
    middleware::Next,
    response::Response,
};
use crate::adapters::http::app_state::AppState;
use crate::application::AppError;

pub async fn auth_middleware(
    State(state): State<AppState>,
    mut req: Request,
    next: Next,
) -> Result<Response, AppError> {
    let auth_header = req.headers().get(header::AUTHORIZATION);

    let auth_header = match auth_header {
        Some(header) => header.to_str().map_err(|_| AppError::Unauthorized("Invalid header".into()))?,
        None => return Err(AppError::Unauthorized("Missing authorization header".into())),
    };

    if !auth_header.starts_with("Bearer ") {
        return Err(AppError::Unauthorized("Invalid authorization header format".into()));
    }

    let token = &auth_header[7..];

    // Verify session
    let session = state
        .auth_repo
        .get_session(token)
        .await?
        .ok_or_else(|| AppError::Unauthorized("Invalid or expired session".into()))?;

    // In a real app we might attach the user or session to the request extensions
    // req.extensions_mut().insert(session);

    Ok(next.run(req).await)
}
