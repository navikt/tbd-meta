.PHONY: $(shell sed -n -e '/^$$/ { n ; /^[^ .\#][^ ]*:/ { s/:.*$$// ; p ; } ; }' $(MAKEFILE_LIST))

root_dir := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
meta_project := $(notdir $(patsubst %/,%,$(dir $(root_dir))))

help:
	@echo "$$(grep -hE '^\S+:.*##' $(MAKEFILE_LIST) | sed -e 's/:.*##\s*/:/' -e 's/^\(.\+\):\(.*\)/\\x1b[36m\1\\x1b[m:\2/' | column -c2 -t -s :)"

meta-update: ## Clone any repos that exist in your .meta file but aren't cloned locally
	@meta git update

pull: ## Run git pull --all --rebase --autostash on all repos
	@meta exec "$(root_dir)bin/pull_from_repo.sh" --parallel

mainline: ## Switch all repos to mainline (main/master)
	@meta exec "$(root_dir)bin/switch_to_mainline.sh"  --parallel

build: ## Run ./gradlew build
	@meta exec "$(root_dir)bin/build.sh" --exclude "tbd-meta"

gw: ## Run ./gradlew <target> - (e.g run using make gw clean build)
	@meta exec "$(root_dir)bin/gw.sh $(filter-out $@,$(MAKECMDGOALS))" --exclude "$(meta_project)" --parallel

upgrade-gradle: ## Upgrade gradle in all projects - usage GRADLEW_VERSION=x.x.x make upgrade-gradle
	@meta exec "$(root_dir)bin/upgrade_gradle.sh" --exclude "$(meta_project)"
	script/upgrade_gradle.sh

check-if-up-to-date: ## check if all changes are commited and pushed - and that we are on the mainline with all changes pulled
	@meta exec "$(root_dir)bin/check_if_we_are_up_to_date.sh" --exclude "$(meta_project)" # --parallel seemed to skip some projects(?!)

list-local-commits: ## shows local, unpushed, commits
	@meta exec "git log --oneline origin/HEAD..HEAD | cat"

prepush-review: ## let's you look at local commits across all projects and decide if you want to push
	@meta exec 'output=$$(git log --oneline origin/HEAD..HEAD) ; [ -n "$$output" ] && (git show --oneline origin/HEAD..HEAD | cat && echo "Pushe? (y/N)" && read a && [ "$$a" = "y" ] && git push) || true' --exclude "$(meta_project)"