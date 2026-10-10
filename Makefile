# Usage: make plan ENV=dev TF_STATE_BUCKET=my-state-bucket
ENV ?= dev
DIR := envs/$(ENV)

.PHONY: fmt validate lint init plan apply destroy

fmt:
	terraform fmt -recursive

validate:
	@for d in envs/*; do \
		echo "==> $$d"; \
		terraform -chdir=$$d init -backend=false -input=false >/dev/null && \
		terraform -chdir=$$d validate || exit 1; \
	done

lint:
	tflint --init && tflint --recursive

init:
	@test -n "$(TF_STATE_BUCKET)" || (echo "TF_STATE_BUCKET is required" && exit 1)
	terraform -chdir=$(DIR) init -backend-config="bucket=$(TF_STATE_BUCKET)"

plan: init
	terraform -chdir=$(DIR) plan -out=$(ENV).tfplan

apply:
	terraform -chdir=$(DIR) apply $(ENV).tfplan

destroy:
	terraform -chdir=$(DIR) destroy
