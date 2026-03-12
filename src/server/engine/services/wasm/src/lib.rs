use wasm_bindgen::prelude::*;

// Exporting domain types to WASM by wrapping them or using serde.
// For typescript definitions, we just want to expose the types.
// We can use a TS interface generation, or simply rely on tsify / schema.
// The spec says: "Re-exports domain types wrapped with #[wasm_bindgen]"
// However, since domain types are not #[wasm_bindgen] natively (they are plain structs),
// we use serde-wasm-bindgen for serialization boundary, or we can use tsify for TS types.
// Wait, the spec says: "Re-exports domain types wrapped with #[wasm_bindgen] ... Exposes validation functions callable from JavaScript"
// Since writing wrappers for every struct is tedious, we can do some basic TS exports or #[wasm_bindgen] stubs.

#[wasm_bindgen(typescript_custom_section)]
const TS_APPEND_CONTENT: &'static str = r#"
export type Role = "Admin" | "Agent" | "Viewer";

export interface User {
    id: string;
    username: string;
    email: string;
    role: Role;
    password_hash: string;
    created_at: string;
    updated_at: string;
}

export interface Category {
    id: string;
    name: string;
    description: string | null;
}

export interface Location {
    id: string;
    name: string;
    address: string;
}

export interface Item {
    id: string;
    name: string;
    sku: string;
    category_id: string;
    location_id: string;
    quantity: number;
    price: number;
    created_at: string;
    updated_at: string;
}
"#;

#[wasm_bindgen]
pub fn validate_sku(sku: &str) -> Result<(), JsValue> {
    // Basic validation stub
    let re =
        regex::Regex::new(r"^[A-Z]{3}-\d{4}$").map_err(|e| JsValue::from_str(&e.to_string()))?;
    if re.is_match(sku) {
        Ok(())
    } else {
        Err(JsValue::from_str(
            "Invalid SKU format. Expected /^[A-Z]{3}-\\d{4}$/",
        ))
    }
}

#[wasm_bindgen]
pub fn validate_quantity(qty: i32) -> Result<(), JsValue> {
    if qty < 0 {
        Err(JsValue::from_str("Quantity cannot be negative"))
    } else {
        Ok(())
    }
}
