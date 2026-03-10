[doc('Clean generated WASM SDK bindings')]
[group('wasm')]
wasm-clean:
    rm -rf src/client/sdk/core/src/pkg

[doc('Build the balam-wasm crate')]
[group('wasm')]
wasm-build:
    cargo build --manifest-path api/Cargo.toml -p balam-wasm \
    	--lib \
    	--target wasm32-unknown-unknown \
    	--release

[doc('Generate JS/TS bindings from WASM')]
[group('wasm')]
wasm-bind:
    # Ensure directory exists
    mkdir -p src/client/sdk/core/src/pkg
    wasm-bindgen \
    	--target web \
    	--out-dir src/client/sdk/core/src/pkg \
    	api/target/wasm32-unknown-unknown/release/balam_wasm.wasm

[doc('Format the generated WASM SDK bindings and Rust crate')]
[group('wasm')]
wasm-fmt:
    cargo fmt -p balam-wasm
    deno fmt src/client/sdk/core/src/pkg

[doc('Run the full WASM build pipeline')]
[group('wasm')]
wasm: wasm-clean wasm-build wasm-bind wasm-fmt
