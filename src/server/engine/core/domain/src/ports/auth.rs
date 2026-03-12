use super::Result;
use crate::entities::user::{Session, User};

#[trait_variant::make(AuthRepository: Send)]
pub trait LocalAuthRepository: Sync {
    async fn find_user_by_email(&self, email: &str) -> Result<Option<User>>;
    async fn create_session(&self, session: Session) -> Result<()>;
    async fn get_session(&self, token: &str) -> Result<Option<Session>>;
    async fn delete_session(&self, token: &str) -> Result<()>;
}
