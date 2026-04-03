use crate::adapters::http::app_state::AppState;
use crate::application::AppError;
use axum::{
    extract::{Request, State},
    http::header,
    middleware::Next,
    response::Response,
};

pub async fn auth_middleware(
    State(state): State<AppState>,
    req: Request,
    next: Next,
) -> Result<Response, AppError> {
    let auth_header = req.headers().get(header::AUTHORIZATION);

    let auth_header = match auth_header {
        Some(header) => header
            .to_str()
            .map_err(|_| AppError::Unauthorized("Invalid header".into()))?,
        None => {
            return Err(AppError::Unauthorized(
                "Missing authorization header".into(),
            ));
        }
    };

    if !auth_header.starts_with("Bearer ") {
        return Err(AppError::Unauthorized(
            "Invalid authorization header format".into(),
        ));
    }

    let token = &auth_header[7..];

    // Verify session
    let _session = state
        .auth_repo
        .find_session_by_token(token)
        .await
        .map_err(|e| AppError::Internal(e.to_string()))?
        .ok_or_else(|| AppError::Unauthorized("Invalid or expired session".into()))?;

    // In a real app we might attach the user or session to the request extensions
    // req.extensions_mut().insert(_session);

    Ok(next.run(req).await)
}
