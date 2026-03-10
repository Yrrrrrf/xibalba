use thiserror::Error;

#[derive(Error, Debug)]
pub enum AppError {
    #[error("Internal server error: {0}")]
    Internal(String),

    #[error("Not found: {0}")]
    NotFound(String),

    #[error("Unauthorized: {0}")]
    Unauthorized(String),

    #[error("Validation error: {0}")]
    Validation(String),

    #[error("Database error: {0}")]
    Database(String),

    #[error("Document generation error: {0}")]
    DocumentGeneration(String),
}

pub type AppResult<T> = Result<T, AppError>;

impl From<String> for AppError {
    fn from(err: String) -> Self {
        AppError::Database(err)
    }
}
