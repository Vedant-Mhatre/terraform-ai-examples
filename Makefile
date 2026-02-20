.PHONY: validate list-examples docs-build estimate-cost

validate:
	./scripts/validate_examples.sh

list-examples:
	@find examples -mindepth 2 -maxdepth 2 -type d | sort

docs-build:
	mkdocs build --strict

estimate-cost:
	@echo "Usage example:"
	@echo "python3 scripts/estimate_costs.py --example ecs-gpu-inference-service --tfvars examples/ai/ecs-gpu-inference-service/terraform.tfvars.example"
