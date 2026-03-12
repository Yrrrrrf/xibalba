// These use cases belong to api, but they define the traits.
// In the new architecture, the traits should technically be in domain or we define them here
// But the spec says: api/application/use_cases/auth.rs stays. So store MUST DEPEND on api? No!
// "NO: axum, wasm-bindgen"
// Ah, if the Traits are in api/application/use_cases, and store doesn't depend on api,
// Then store CANNOT implement them.
// Let's check the spec again: "Only store changes. api/application/ trait impls stay identical."
// Oh, the traits must either be in domain OR store defines the types and api wraps them.
// Wait, the spec says domain contains: "Item, Category, StockLevel, Location... DocumentRequest... User, Role".
// It says api contains: "application/use_cases/auth.rs" and "application/use_cases/inventory.rs".
// If api defines the `AuthRepository` trait, how does store implement it without depending on api?
// Solution: store just implements its own structs with the methods. Then `api/infra/setup.rs`
// can either wrap them or if we want, we can move the traits to domain later.
// For now, let's just make sure the methods exist on the struct.

use crate::client::SurrealClient;
use domain::entities::user::{Session, User};
pub struct SurrealAuthRepo {
    _client: SurrealClient,
}

use domain::ports::DomainError;
use domain::ports::auth::AuthRepository;

impl SurrealAuthRepo {
    pub fn new(client: SurrealClient) -> Self {
        Self { _client: client }
    }
}

impl AuthRepository for SurrealAuthRepo {
    async fn find_user_by_email(&self, _email: &str) -> Result<Option<User>, DomainError> {
        Ok(None)
    }

    async fn create_session(&self, _session: Session) -> Result<(), DomainError> {
        Ok(())
    }

    async fn get_session(&self, _token: &str) -> Result<Option<Session>, DomainError> {
        Ok(None)
    }

    async fn delete_session(&self, _token: &str) -> Result<(), DomainError> {
        Ok(())
    }
}
