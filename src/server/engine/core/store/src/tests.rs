#[cfg(test)]
mod tests {
    use crate::client::SurrealClient;
    use crate::repos::business::SurrealBusinessRepo;
    use domain::ports::business::BusinessRepository;
    use std::sync::Arc;
    use surrealdb::engine::any::connect;
    use surrealdb::opt::auth::Root;

    #[tokio::test]
    async fn test_list_active_businesses() {
        let db = connect("ws://localhost:8000").await.unwrap();
        db.signin(Root {
            username: "root".to_string(),
            password: "root".to_string(),
        })
        .await
        .unwrap();
        db.use_ns("app").use_db("main").await.unwrap();

        let client = SurrealClient::new(Arc::new(db));
        let repo = SurrealBusinessRepo::new(client);

        let businesses = repo.list_active().await.unwrap();
        assert!(!businesses.is_empty());
    }
}
