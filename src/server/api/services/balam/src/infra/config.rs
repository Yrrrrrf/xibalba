use std::env;

#[derive(Clone)]
pub struct AppConfig {
    pub db_url: String,
    pub server_port: u16,
    pub jwt_secret: String,
}

impl AppConfig {
    pub fn from_env() -> Self {
        Self {
            db_url: env::var("SURREAL_DB_URL").unwrap_or_else(|_| "ws://localhost:8000".to_string()),
            server_port: env::var("PORT")
                .unwrap_or_else(|_| "3000".to_string())
                .parse()
                .unwrap_or(3000),
            jwt_secret: env::var("JWT_SECRET").unwrap_or_else(|_| "default_secret".to_string()),
        }
    }
}
