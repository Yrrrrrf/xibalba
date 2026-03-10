use axum::{middleware, Router};
use tower_http::cors::CorsLayer;
use tower_http::trace::TraceLayer;
use crate::adapters::http::app_state::AppState;
use crate::adapters::http::routes;
use crate::adapters::http::middleware as app_middleware;

pub fn create_app(state: AppState) -> Router {
    let auth_routes = routes::auth::r();
    let inventory_routes = routes::inventory::r()
        .layer(middleware::from_fn_with_state(state.clone(), app_middleware::auth::auth_middleware));
    let documents_routes = routes::documents::r()
        .layer(middleware::from_fn_with_state(state.clone(), app_middleware::auth::auth_middleware));

    Router::new()
        .nest("/auth", auth_routes)
        .nest("/inventory", inventory_routes)
        .nest("/documents", documents_routes)
        .with_state(state)
        // Global middlewares
        .layer(CorsLayer::permissive()) // Configure properly in production
        .layer(TraceLayer::new_for_http())
        .layer(middleware::from_fn(app_middleware::logger::request_logger))
}
