use xibalba_domain::entities::user::{User, Session};
use crate::application::{AppError, AppResult};

pub trait AuthRepository: Send + Sync {
    async fn find_user_by_email(&self, email: &str) -> AppResult<Option<User>>;
    async fn create_session(&self, session: Session) -> AppResult<()>;
    async fn get_session(&self, token: &str) -> AppResult<Option<Session>>;
    async fn delete_session(&self, token: &str) -> AppResult<()>;
}

// In a real app, you'd also have use cases like login, validate, etc.
// For now, we provide the trait definitions to satisfy the architecture spec.
