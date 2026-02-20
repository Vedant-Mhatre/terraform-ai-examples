#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
EXAMPLES_DIR="$ROOT_DIR/examples"

required_files=(
  "README.md"
  "architecture.svg"
  "versions.tf"
  "main.tf"
  "variables.tf"
  "outputs.tf"
  "terraform.tfvars.example"
)

required_sections=(
  "## Architecture"
  "## What You'll Learn"
  "## Real-World Use Case"
  "## Usage"
  "## Validation Steps"
  "## Cost and Safety"
  "## Cleanup"
  "## Next Improvements"
)

errors=0

check_dir() {
  local dir="$1"
  local rel_dir
  rel_dir="${dir#"$ROOT_DIR/"}"

  echo "Checking $rel_dir"

  for file in "${required_files[@]}"; do
    if [[ ! -f "$dir/$file" ]]; then
      echo "  [ERROR] Missing $file"
      errors=$((errors + 1))
    fi
  done

  if [[ -f "$dir/README.md" ]]; then
    for section in "${required_sections[@]}"; do
      if ! grep -Fq "$section" "$dir/README.md"; then
        echo "  [ERROR] README missing section: $section"
        errors=$((errors + 1))
      fi
    done
  fi

  if [[ -f "$dir/architecture.svg" ]]; then
    local size
    size=$(wc -c < "$dir/architecture.svg")
    if [[ "$size" -lt 200 ]]; then
      echo "  [ERROR] architecture.svg looks too small ($size bytes)"
      errors=$((errors + 1))
    fi
  fi

  if command -v terraform >/dev/null 2>&1; then
    (
      cd "$dir"
      terraform init -backend=false -input=false -no-color >/dev/null
      terraform validate -no-color >/dev/null
    ) || {
      echo "  [ERROR] Terraform init/validate failed"
      errors=$((errors + 1))
    }
  else
    echo "  [WARN] Terraform CLI not found; skipping init/validate"
  fi
}

while IFS= read -r dir; do
  check_dir "$dir"
done < <(find "$EXAMPLES_DIR" -mindepth 2 -maxdepth 2 -type d | sort)

if [[ "$errors" -gt 0 ]]; then
  echo
  echo "Validation failed with $errors issue(s)."
  exit 1
fi

echo

echo "All example checks passed."
