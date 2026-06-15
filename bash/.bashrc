# /home/ateebamateen/.bashrc

# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

eval "$(oh-my-posh init bash --config ~/.config/oh-my-posh/style_terminal.omp.json)"
# fastfetch --config ~/fastfetch_presets/examples/girl.jsonc
echo -ne '\e[5 q'

pyfiglet -s -f smslant "All  good ?" && fastfetch -l none --config ~/.config/fastfetch/examples/os_art.jsonc


#prefix search

bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

#bind a shortcut key 
bind '"\eOP": "yazi\n"'

# Set up fzf key bindings and fuzzy completion
eval "$(fzf --bash)"
export LIBGL_ALWAYS_SOFTWARE=0
alias obsidian="obsidian 2>/dev/null"
export PATH="$HOME/.cargo/bin:$PATH"

export EDITOR=nvim
export VISUAL=nvim

export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
unset SSH_ASKPASS

alias please='sudo'
alias vf='nvim $(fzf)'

. "$HOME/.atuin/bin/env"

[[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh
eval "$(atuin init bash)"
