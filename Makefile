SHELL := /bin/bash # Use bash syntax
GREEN  := $(shell tput setaf 2)
YELLOW := $(shell tput setaf 3)
WHITE  := $(shell tput setaf 7)
CYAN   := $(shell tput setaf 6)
RESET  := $(shell tput sgr0)

.PHONY: all link install-core install-dev install-apps install-utils install-fonts install-kde install-konsave uninstall-src basic nvm typescript yay zsh tldr spotify media audio rust starship anaconda uv vscode docker firefox teams nordvpn fonts-nerd zimfw cli-tools zotero trayscale rate-mirrors openssh-askpass tmux-plugins help

all: help

## GLOBAL
link: ## run stow to create symlinks
	@cd ~/dotfiles && stow .

install-core: basic yay zsh zimfw cli-tools starship rust ## Install essential packages: basic, yay, zsh, zimfw, cli-tools, starship, rust

install-dev: install-core anaconda uv vscode docker ## Install development environment: anaconda, uv, vscode, docker

install-apps: firefox teams nordvpn ## Install applications: firefox, teams, nordvpn

install-fonts: fonts-nerd ## Install fonts: nerd fonts collection

install-utils: zotero trayscale rate-mirrors openssh-askpass ## Install utilities: zotero, trayscale, rate-mirrors, openssh-askpass

install-kde: ## Install KDE desktop environment and utilities
	sudo pacman -S --noconfirm plasma-desktop kdeplasma-addons sddm{,-kcm} dolphin bluedevil kscreen spectacle

install-konsave: ## Install konsave to backup KDE settings
	python -m pip install --user konsave

uninstall-src: ## Remove the src folder from dotfiles
	@rm -rf "${HOME}/dotfiles/src" && echo "src folder removed."

## INSTALL
basic: ## Install basic packages: pkg-config, curl, git, etc.
	sudo pacman -S --noconfirm pkg-config curl git lua neofetch vim kitty jq stow

nvm: yay ## Install nvm for Node.js version management
	yay -S --noconfirm nvm && \
	echo 'source /usr/share/nvm/init-nvm.sh' >> ~/.zshrc && \
	nvm install --lts && \
	nvm use --lts

typescript: nvm ## Install TypeScript globally via npm
	npm install -g typescript @types/node

yay: ## Install yay (AUR helper)
	sudo pacman -S --needed --noconfirm git base-devel && \
	git clone https://aur.archlinux.org/yay.git && \
	cd yay && makepkg -si --noconfirm

zsh: yay ## Install zsh and completions (syntax highlighting already installed)
	yay -S --noconfirm zsh zsh-completions

zimfw: zsh ## Install Zim framework for zsh
	@if [ ! -d "${HOME}/.zim" ]; then \
		curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh; \
	else \
		echo 'Zim framework already installed'; \
	fi

cli-tools: ## Install modern CLI tools: fzf, ripgrep, bat, btop, tree
	sudo pacman -S --noconfirm fzf ripgrep bat btop tree

tldr: ## Install tldr
	yay -S --noconfirm tldr

spotify: ## Install Spotify
	yay -S --noconfirm spotify

audio: ## Install audio packages
	yay -S --noconfirm plasma-pa pulseaudio pulseaudio-alsa pulseaudio-bluetooth

media: ## Install media packages: VLC, Gwenview, image tools
	sudo pacman -S --noconfirm vlc gwenview imagemagick

starship: rust ## Install Starship prompt
	cargo install starship --locked

rust: basic ## Install Rustup for Rust development
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && \
	source ~/.cargo/env

## DEVELOPMENT TOOLS
anaconda: ## Install Anaconda Python distribution
	@if [ ! -d "~/anaconda3" ]; then \
		curl -O https://repo.anaconda.com/archive/Anaconda3-2024.10-1-Linux-x86_64.sh && \
		bash Anaconda3-2024.10-1-Linux-x86_64.sh -b -p ~/anaconda3 && \
		rm Anaconda3-2024.10-1-Linux-x86_64.sh && \
		echo 'Anaconda installed'; \
	else \
		echo 'Anaconda already installed'; \
	fi

uv: ## Install UV Python package manager
	sudo pacman -S --noconfirm uv

vscode: yay ## Install Visual Studio Code
	yay -S --noconfirm visual-studio-code-bin

docker: ## Install Docker and Docker Compose
	sudo pacman -S --noconfirm docker docker-compose && \
	sudo systemctl enable docker && \
	sudo usermod -aG docker $$USER && \
	echo 'Please log out and back in for Docker group changes to take effect'

## APPLICATIONS
firefox: ## Install Firefox browser
	sudo pacman -S --noconfirm firefox

teams: yay ## Install Microsoft Teams
	yay -S --noconfirm teams

nordvpn: yay ## Install NordVPN
	yay -S --noconfirm nordvpn-bin nordvpn-gui && \
	sudo systemctl enable nordvpn

## FONTS
fonts-nerd: yay ## Install comprehensive Nerd Fonts collection
	yay -S --noconfirm ttf-jetbrains-mono-nerd ttf-firacode-nerd ttf-hack-nerd \
		ttf-sourcecodepro-nerd ttf-cascadia-code-nerd ttf-iosevka-nerd \
		ttf-victor-mono-nerd ttf-ubuntu-mono-nerd adobe-source-code-pro-fonts

## UTILITIES
zotero: yay ## Install Zotero reference manager
	yay -S --noconfirm zotero-bin

trayscale: yay ## Install Trayscale (Tailscale system tray)
	yay -S --noconfirm trayscale

rate-mirrors: yay ## Install rate-mirrors for fast Arch mirror ranking
	yay -S --noconfirm rate-mirrors

openssh-askpass: yay ## Install OpenSSH askpass utility
	yay -S --noconfirm openssh-askpass

tmux: ## Install tmux
	sudo pacman -S --noconfirm tmux

tmux-plugins: tmux ## Install and configure tmux plugins via TPM
	@echo "Installing tmux plugin manager (TPM)..."
	@if [ ! -d "$$HOME/.tmux/plugins/tpm" ]; then \
		git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm; \
	else \
		echo 'TPM already installed'; \
	fi
	@echo "Installing tmux plugins..."
	@if command -v tmux >/dev/null 2>&1; then \
		tmux new-session -d -s tmux-install || true; \
		tmux send-keys -t tmux-install 'tmux source ~/.config/tmux/tmux.conf' Enter; \
		tmux send-keys -t tmux-install '~/.tmux/plugins/tpm/scripts/install_plugins.sh' Enter; \
		sleep 3; \
		tmux kill-session -t tmux-install || true; \
		echo 'Tmux plugins installed successfully'; \
	else \
		echo 'Tmux not found. Please install tmux first: sudo pacman -S tmux'; \
	fi

## HELP
help: ## Show this help message.
	@echo ''
	@echo 'Usage:'
	@echo '  $(YELLOW)make$(RESET) $(GREEN)<target>$(RESET)'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} { \
		if (/^[a-zA-Z_-]+:.*?##.*$$/) {printf "    $(YELLOW)%-30s$(GREEN)%s$(RESET)\n", $$1, $$2} \
		else if (/^## .*$$/) {printf "  $(CYAN)%s$(RESET)\n", substr($$1,4)} \
		}' $(MAKEFILE_LIST)

