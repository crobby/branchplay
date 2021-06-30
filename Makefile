BRANCH_TO_BACKUP ?= "main"
BRANCH_BACKUP_NAME ?= "backup"
BRANCH_BACKUP_REMOTE ?= "origin"
BRANCH_TO_FORCE ?= "branchtoforce"
BRANCH_TO_FORCE_REMOTE ?= "origin"
BRANCH_TO_FORCE_TARGET_NAME ?= "forcedbranch"
CURRENT_BRANCH = $(shell git rev-parse --abbrev-ref HEAD)

BOLDRED = '\033[1;31m'
NOCOLOR = '\033[0m'

.PHONY: backup
backup:
	git checkout -b ${BRANCH_BACKUP_NAME} ${BRANCH_TO_BACKUP}
	git push --set-upstream ${BRANCH_BACKUP_REMOTE} ${BRANCH_BACKUP_NAME}
	git checkout ${CURRENT_BRANCH}
	git branch -D ${BRANCH_BACKUP_NAME}


.PHONY: forcebranch
forcebranch:
	@echo $(shell printf "${BOLDRED}THIS CAN BE DESTRUCTIVE, PLEASE VERIFY THAT YOU ARE DOING WHAT YOU MEAN TO DO${NOCOLOR}\n")
	@(read -p "Are you sure you want to force push ${BRANCH_TO_FORCE} to ${BRANCH_BACKUP_REMOTE}/${BRANCH_TO_FORCE_TARGET_NAME}?!? [y/N]: " verify && case "$$verify" in [yY]) true;; *) false;; esac )
	git checkout -b ${BRANCH_TO_FORCE_TARGET_NAME} ${BRANCH_TO_FORCE}
	git push --force --set-upstream ${BRANCH_TO_FORCE_REMOTE} ${BRANCH_TO_FORCE_TARGET_NAME}
	git checkout $(CURRENT_BRANCH)
	git branch -D ${BRANCH_TO_FORCE_TARGET_NAME}
