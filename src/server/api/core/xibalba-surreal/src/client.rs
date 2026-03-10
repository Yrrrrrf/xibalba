use surrealdb::engine::any::Any;
use surrealdb::Surreal;
use std::sync::Arc;

#[derive(Clone)]
pub struct SurrealClient {
    pub db: Arc<Surreal<Any>>,
}

impl SurrealClient {
    pub fn new(db: Arc<Surreal<Any>>) -> Self {
        Self { db }
    }
}
