export PATH="$PATH:$HOME/bin"
export PS1='%F{cyan}%n@%m%f %F{green}%1~%f %# '
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/takeshi/miniforge3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/takeshi/miniforge3/etc/profile.d/conda.sh" ]; then
        . "/Users/takeshi/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/takeshi/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


# >>> mamba initialize >>>
# !! Contents within this block are managed by 'mamba shell init' !!
export MAMBA_EXE='/Users/takeshi/miniforge3/bin/mamba';
export MAMBA_ROOT_PREFIX='/Users/takeshi/miniforge4';
__mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias mamba="$MAMBA_EXE"  # Fallback on help from mamba activate
fi
unset __mamba_setup
# <<< mamba initialize <<<
