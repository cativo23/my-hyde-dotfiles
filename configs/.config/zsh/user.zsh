#  Startup 
# Commands to execute on startup (before the prompt is shown)
# Check if the interactive shell option is set
if [[ $- == *i* ]]; then
    # This is a good place to load graphic/ascii art, display system information, etc.
    if command -v fastfetch >/dev/null; then
        if do_render "image"; then
            fastfetch --logo-type file
        fi
    fi
fi

#   Overrides 
# HYDE_ZSH_NO_PLUGINS=1 # Set to 1 to disable loading of oh-my-zsh plugins, useful if you want to use your zsh plugins system 
# unset HYDE_ZSH_PROMPT # Uncomment to unset/disable loading of prompts from HyDE and let you load your own prompts
# HYDE_ZSH_COMPINIT_CHECK=1 # Set 24 (hours) per compinit security check // lessens startup time
# HYDE_ZSH_OMZ_DEFER=1 # Set to 1 to defer loading of oh-my-zsh plugins ONLY if prompt is already loaded

if [[ ${HYDE_ZSH_NO_PLUGINS} != "1" ]]; then
    #  OMZ Plugins 
    # manually add your oh-my-zsh plugins here
    plugins=(
        "sudo"
    )
fi

# Quick navigation aliases
alias cdp='cd ~/projects/personal'
alias cdw='cd ~/projects/work'

# List projects quickly
alias lsp='ls -1 ~/projects/personal'
alias lsw='ls -1 ~/projects/work'

# Aliases
alias cat='bat --theme=tokyonight_night'
alias sysup='__package_manager upgrade; flatpak update'
# Machine-specific aliases (vpn, etc.) go in user.local.zsh

# Create new personal project
mkpersonal() {
  mkdir -p ~/projects/personal/"$1" && cd ~/projects/personal/"$1"
}

# Create new work project under a company
mkwork() {
  mkdir -p ~/projects/work/"$1"/"$2" && cd ~/projects/work/"$1"/"$2"
}

# Archive project (move to archives)
archive_project() {
  if [[ -d ~/projects/work/"$1"/"$2" ]]; then
    mv ~/projects/work/"$1"/"$2" ~/projects/archives/
    echo "Project $2 archived"
  elif [[ -d ~/projects/personal/"$1" ]]; then
    mv ~/projects/personal/"$1" ~/projects/archives/
    echo "Personal project $1 archived"
  else
    echo "Project not found"
  fi
}

# NVM (load only if installed)
[[ -f /usr/share/nvm/init-nvm.sh ]] && source /usr/share/nvm/init-nvm.sh

# Machine-specific overrides (tokens, env vars, paths)
# Create ~/.config/zsh/user.local.zsh for per-machine config
[[ -f "${ZDOTDIR:-$HOME/.config/zsh}/user.local.zsh" ]] && source "${ZDOTDIR:-$HOME/.config/zsh}/user.local.zsh"