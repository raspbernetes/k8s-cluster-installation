.PHONY: help

help: ##show this help.
	@IFS=$$'\n' ; \
	help_lines=(`fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##/:/'`); \
	printf "%-30s %s\n" "target" "help" ; \
	printf "%-30s %s\n" "------" "----" ; \
	for help_line in $${help_lines[@]}; do \
			IFS=$$':' ; \
			help_split=($$help_line) ; \
			help_command=`echo $${help_split[0]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
			help_info=`echo $${help_split[2]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
			printf '\033[36m'; \
			printf "%-30s %s" $$help_command ; \
			printf '\033[0m'; \
			printf "%s\n" $$help_info; \
	done

install: ##install requirements
	ansible-galaxy install -r requirements.yml

lint: ##test files for syntax errors
	# https://formulae.brew.sh/formula/yamllint
	# https://formulae.brew.sh/formula/ansible-lint
	yamllint . || true
	ansible-lint playbooks/*.yml || true

pretty: ##correct formatting errors 
	# https://formulae.brew.sh/formula/prettier 
	prettier --parser=markdown --write '*.md' '**/*.md' || true
	prettier --parser=json --write '**/*.json' '**/*.json.j2' || true
	prettier --parser=yaml --write '*.y*ml' '**/*.y*ml' || true
