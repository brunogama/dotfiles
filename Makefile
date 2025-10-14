# Bruno's Dotfiles - Makefile
# Standard Unix interface for installation and management

SHELL := /bin/bash
HOME_DIR := $(HOME)
DOTFILES_DIR := $(shell pwd)
CONFIG_DIR := $(DOTFILES_DIR)/config
SCRIPTS_DIR := $(DOTFILES_DIR)/scripts
DOCS_DIR := $(DOTFILES_DIR)/docs
BACKUP_DIR := $(HOME)/.dotfiles-backup-$(shell date +%Y%m%d-%H%M%S)

# Colors
BLUE := \033[0;34m
GREEN := \033[0;32m
YELLOW := \033[1;33m
RED := \033[0;31m
NC := \033[0m

.PHONY: help install uninstall link unlink backup clean test setup-prezto check-prezto

help:
	@echo "$(BLUE)Bruno's Dotfiles - Makefile$(NC)"
	@echo "================================"
	@echo ""
	@echo "Available targets:"
	@echo "  $(GREEN)install$(NC)        - Install all dotfiles (backup, link configs & scripts)"
	@echo "  $(GREEN)install-zsh$(NC)    - Install ZSH configuration only"
	@echo "  $(GREEN)install-git$(NC)    - Install Git configuration only"
	@echo "  $(GREEN)install-scripts$(NC) - Install scripts to ~/.local/bin"
	@echo "  $(GREEN)setup-prezto$(NC)   - Install Prezto framework (one-time setup)"
	@echo "  $(GREEN)check-prezto$(NC)   - Check if Prezto is installed"
	@echo "  $(GREEN)uninstall$(NC)      - Remove all symlinks"
	@echo "  $(GREEN)link$(NC)           - Create all symlinks"
	@echo "  $(GREEN)unlink$(NC)         - Remove all symlinks"
	@echo "  $(GREEN)backup$(NC)         - Backup existing dotfiles"
	@echo "  $(GREEN)test$(NC)           - Test installation (dry-run)"
	@echo "  $(GREEN)clean$(NC)          - Clean up backup files"
	@echo ""

# Full installation
install: backup link install-scripts
	@echo "$(GREEN)✓ Installation complete!$(NC)"
	@echo ""
	@echo "Next steps:"
	@echo "  1. Restart terminal or: source ~/.zshrc"
	@echo "  2. Review configs in: $(CONFIG_DIR)"
	@echo "  3. Check available scripts: ls ~/.local/bin"

# Backup existing dotfiles
backup:
	@echo "$(BLUE)Creating backup...$(NC)"
	@mkdir -p $(BACKUP_DIR)
	@test -f $(HOME_DIR)/.zshrc && cp $(HOME_DIR)/.zshrc $(BACKUP_DIR)/ || true
	@test -f $(HOME_DIR)/.zprofile && cp $(HOME_DIR)/.zprofile $(BACKUP_DIR)/ || true
	@test -f $(HOME_DIR)/.zpreztorc && cp $(HOME_DIR)/.zpreztorc $(BACKUP_DIR)/ || true
	@test -f $(HOME_DIR)/.p10k.zsh && cp $(HOME_DIR)/.p10k.zsh $(BACKUP_DIR)/ || true
	@test -d $(HOME_DIR)/.config/zsh && cp -R $(HOME_DIR)/.config/zsh $(BACKUP_DIR)/ || true
	@test -d $(HOME_DIR)/.config/git && cp -R $(HOME_DIR)/.config/git $(BACKUP_DIR)/ || true
	@echo "$(GREEN)✓ Backup created at: $(BACKUP_DIR)$(NC)"

# Create all symlinks
link: link-zsh link-git link-homebrew link-misc
	@echo "$(GREEN)✓ All symlinks created$(NC)"

# Individual component linking
link-zsh: check-prezto
	@echo "$(BLUE)Linking ZSH configuration...$(NC)"
	@mkdir -p $(HOME_DIR)/.config
	@ln -sfn $(CONFIG_DIR)/zsh $(HOME_DIR)/.config/zsh
	@ln -sf $(CONFIG_DIR)/zsh/.zshrc $(HOME_DIR)/.zshrc
	@ln -sf $(CONFIG_DIR)/zsh/.zprofile $(HOME_DIR)/.zprofile
	@ln -sf $(CONFIG_DIR)/zsh/.zpreztorc $(HOME_DIR)/.zpreztorc
	@ln -sf $(CONFIG_DIR)/zsh/.p10k.zsh $(HOME_DIR)/.p10k.zsh
	@test -f $(CONFIG_DIR)/zsh/.zsh_history || touch $(CONFIG_DIR)/zsh/.zsh_history
	@echo "$(GREEN)✓ ZSH linked$(NC)"

# Check if Prezto is installed
check-prezto:
	@if [ ! -d "$(HOME_DIR)/.zprezto" ]; then \
		echo "$(YELLOW)⚠ Prezto not found at ~/.zprezto$(NC)"; \
		echo "$(YELLOW)  Your custom configs will be linked, but Prezto framework is missing.$(NC)"; \
		echo "$(YELLOW)  Run 'make setup-prezto' to install it.$(NC)"; \
	fi

# Install Prezto framework (one-time setup)
setup-prezto:
	@echo "$(BLUE)Setting up Prezto framework...$(NC)"
	@if [ -d "$(HOME_DIR)/.zprezto" ]; then \
		echo "$(GREEN)✓ Prezto already installed$(NC)"; \
	else \
		echo "$(BLUE)Cloning Prezto...$(NC)"; \
		git clone --recursive https://github.com/sorin-ionescu/prezto.git "$(HOME_DIR)/.zprezto"; \
		echo "$(GREEN)✓ Prezto installed$(NC)"; \
		echo "$(YELLOW)Note: Your custom configs from $(CONFIG_DIR)/zsh/ will be used$(NC)"; \
	fi

link-git:
	@echo "$(BLUE)Linking Git configuration...$(NC)"
	@mkdir -p $(HOME_DIR)/.config
	@ln -sfn $(CONFIG_DIR)/git $(HOME_DIR)/.config/git
	@echo "$(GREEN)✓ Git linked$(NC)"

link-homebrew:
	@echo "$(BLUE)Linking Homebrew configuration...$(NC)"
	@mkdir -p $(HOME_DIR)/.config
	@ln -sfn $(CONFIG_DIR)/homebrew $(HOME_DIR)/.config/homebrew
	@echo "$(GREEN)✓ Homebrew linked$(NC)"

link-misc:
	@echo "$(BLUE)Linking misc configurations...$(NC)"
	@mkdir -p $(HOME_DIR)/.config
	@test -d $(CONFIG_DIR)/mise && ln -sfn $(CONFIG_DIR)/mise $(HOME_DIR)/.config/mise || true
	@test -d $(CONFIG_DIR)/fish && ln -sfn $(CONFIG_DIR)/fish $(HOME_DIR)/.config/fish || true
	@test -d $(CONFIG_DIR)/ios-cli && ln -sfn $(CONFIG_DIR)/ios-cli $(HOME_DIR)/.config/ios-cli || true
	@test -d $(CONFIG_DIR)/sync-service && ln -sfn $(CONFIG_DIR)/sync-service $(HOME_DIR)/.config/sync-service || true
	@echo "$(GREEN)✓ Misc configs linked$(NC)"

# Install scripts
install-scripts:
	@echo "$(BLUE)Installing scripts...$(NC)"
	@mkdir -p $(HOME_DIR)/.local/bin
	@find $(SCRIPTS_DIR) -type f -not -name "*.md" -exec ln -sf {} $(HOME_DIR)/.local/bin/ \;
	@chmod +x $(HOME_DIR)/.local/bin/*
	@echo "$(GREEN)✓ Scripts installed to ~/.local/bin$(NC)"

# Install specific components
install-zsh: backup link-zsh
	@echo "$(GREEN)✓ ZSH installed$(NC)"

install-git: backup link-git
	@echo "$(GREEN)✓ Git installed$(NC)"

# Unlink all
unlink:
	@echo "$(YELLOW)Removing symlinks...$(NC)"
	@rm -f $(HOME_DIR)/.zshrc
	@rm -f $(HOME_DIR)/.zprofile
	@rm -f $(HOME_DIR)/.zpreztorc
	@rm -f $(HOME_DIR)/.p10k.zsh
	@rm -f $(HOME_DIR)/.config/zsh
	@rm -f $(HOME_DIR)/.config/git
	@rm -f $(HOME_DIR)/.config/homebrew
	@rm -f $(HOME_DIR)/.config/mise
	@rm -f $(HOME_DIR)/.config/fish
	@rm -f $(HOME_DIR)/.config/ios-cli
	@rm -f $(HOME_DIR)/.config/sync-service
	@find $(HOME_DIR)/.local/bin -type l -exec rm {} \; 2>/dev/null || true
	@echo "$(GREEN)✓ Symlinks removed$(NC)"

# Uninstall
uninstall: unlink
	@echo "$(GREEN)✓ Uninstallation complete$(NC)"

# Test (dry-run)
test:
	@echo "$(BLUE)Testing installation (dry-run)...$(NC)"
	@echo ""
	@echo "Would create these symlinks:"
	@echo "  $(HOME_DIR)/.config/zsh -> $(CONFIG_DIR)/zsh"
	@echo "  $(HOME_DIR)/.config/git -> $(CONFIG_DIR)/git"
	@echo "  $(HOME_DIR)/.zshrc -> $(CONFIG_DIR)/zsh/.zshrc"
	@echo ""
	@echo "Would install $(shell find $(SCRIPTS_DIR) -type f -not -name "*.md" | wc -l | tr -d ' ') scripts to ~/.local/bin"
	@echo ""
	@echo "$(GREEN)Test complete. Run 'make install' to proceed.$(NC)"

# Clean backups
clean:
	@echo "$(YELLOW)Cleaning old backups...$(NC)"
	@find $(HOME_DIR) -maxdepth 1 -name ".dotfiles-backup-*" -type d -mtime +30 -exec rm -rf {} \;
	@echo "$(GREEN)✓ Old backups cleaned$(NC)"
