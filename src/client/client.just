rune_lab := "/home/yrrrrrf/docs/lab/code/typescript/rune-lab"
rune_lab_dest := "node_modules/rune-lab"

[group('Client')]
[doc('Full setup: nuke node_modules, reinstall, then inject local rune-lab')]
[working-directory('src/client')]
client-reborn: (inject-rune-lab "reborn")

[group('Client')]
[doc('Quick sync: just rebuild rune-lab and re-inject')]
[working-directory('src/client')]
client-sync: (inject-rune-lab "sync")

[private]
build-rune-lab:
    @echo "🔨 Building rune-lab..."
    just --justfile {{ rune_lab }}/justfile --working-directory {{ rune_lab }} build
    @echo "✅ rune-lab built!"

[private]
[working-directory('src/client')]
inject-rune-lab mode: build-rune-lab
    #!/usr/bin/env bash
    set -euo pipefail

    if [ "{{ mode }}" = "reborn" ]; then
        echo "💀 Running yog reborn --deep..."
        yog reborn --deep
    fi

    echo "🗑  Removing stale node_modules/rune-lab..."
    rm -rf {{ rune_lab_dest }}

    echo "📦 Injecting local rune-lab dist..."
    mkdir -p {{ rune_lab_dest }}
    cp -r {{ rune_lab }}/dist {{ rune_lab_dest }}/dist
    cp    {{ rune_lab }}/package.json {{ rune_lab_dest }}/package.json

    echo "🎉 Done! node_modules/rune-lab is now your local build."
