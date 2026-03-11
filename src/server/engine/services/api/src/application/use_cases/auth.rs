use crate::application::{AppError, AppResult};
use domain::entities::user::{Session, User};

pub use domain::ports::auth::AuthRepository;

// In a real app, you'd also have use cases like login, validate, etc.
// For now, we provide the trait definitions to satisfy the architecture spec.
