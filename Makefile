.PHONY: validate list-examples

validate:
	./scripts/validate_examples.sh

list-examples:
	@find examples -mindepth 2 -maxdepth 2 -type d | sort
