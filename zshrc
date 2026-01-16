# Enable Powerlevel10k instant prompt. Should stay close to the top of ${HOME}/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

# Enable colors and change prompt:
autoload -U colors && colors

# Enable calculator
autoload zcalc

setopt +o nomatch

# # Enable substitution in the prompt.
# setopt prompt_subst

# Config for the prompt. PS1 synonym.
setopt autocd

# History in cache directory:
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=${HOME}/.cache/zsh/history

# Enabling zoxide
# eval "$(zoxide init zsh)"
# additional shell scripts
# source_z() {
#     source ${HOME}/.zshrc.d/zsh-z/zsh-z.plugin.zsh
#     autoload -U compinit
#     zstyle ':completion:*' menu select
#     zmodload zsh/complist
#     compinit
#     _comp_options+=(globdots)
# }

load_nvm() {
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
}
load_nvm_completion() {
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
}

# Lazy loading stuffs to speed up start time
source ${HOME}/.zshrc.d/zsh-lazyload/zsh-lazyload.zsh
# lazyload zshz -- "source_z"
# lazyload pip pip3 -- 'eval "$(pip completion --zsh)"'
lazyload nvm npm node nvim vim nnn -- 'export NVM_DIR="$HOME/.nvm"; [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"'

# Some nice zsh utils
source ${HOME}/.zshrc.d/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# source ${HOME}/.zshrc.d/zsh-highlight-config.zsh
source ${HOME}/.zshrc.d/zsh-autosuggestions/zsh-autosuggestions.zsh

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)   # Include hidden files.
#
# Load aliases and shortcuts if existent.
source "$HOME/.config/aliasrc"

# More additional shell scripts
source ${HOME}/.zshrc.d/vi-mode.zsh
source ${HOME}/.zshrc.d/conda.zsh
source ${HOME}/.zshrc.d/fzf-funcs.zsh
source ${HOME}/.zshrc.d/ros_config.zsh
source ${HOME}/.zshrc.d/nvim-funcs.zsh
source ${HOME}/.zshrc.d/yazi.zsh
source ${HOME}/.zshrc.d/nnn.zsh
source ${HOME}/.zshrc.d/zshenvs.zsh
source ${HOME}/.zshrc.d/kitty.zsh
# # P10k prompt
source ${HOME}/.zshrc.d/powerlevel10k/powerlevel10k.zsh-theme
source ${HOME}/.zshrc.d/.p10k.zsh
# source ${HOME}/.config/aliasrc
# ## To customize prompt, run `p10k configure` or edit ${HOME}/.p10k.zsh.
# [[ ! -f ${HOME}/.p10k.zsh ]] || source ${HOME}/.p10k.zsh
# # pip autocompletion
#
# #export TERM=xerm-color
#
# source ${HOME}/.zshrc.d/ssh.zsh
# #THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
ssdk() {
    export SDKMAN_DIR="$HOME/.sdkman"
    [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
}
# FZF source
[ -f ${HOME}/.zshrc.d/.fzf.zsh ] && source ${HOME}/.zshrc.d/.fzf.zsh
# Rust source
[ -f "${HOME}/.cargo/env" ] && source "${HOME}/.cargo/env"
# eval "$(zoxide init zsh)"
# # Enabling starship prompt
# eval "$(starship init zsh)"
#
# For Pyright to work with ros packages
# LS color
export LS_COLORS='no=00:fi=00:di=34:ow=34;40:ln=35:pi=30;44:so=35;44:do=35;44:bd=33;44:cd=37;44:or=05;37;41:mi=05;37;41:ex=01;31:*.cmd=01;31:*.exe=01;31:*.com=01;31:*.bat=01;31:*.reg=01;31:*.app=01;31:*.txt=32:*.org=32:*.md=32:*.mkd=32:*.h=32:*.c=32:*.C=32:*.cc=32:*.cpp=32:*.cxx=32:*.objc=32:*.sh=32:*.csh=32:*.zsh=32:*.el=32:*.vim=32:*.java=32:*.pl=32:*.pm=32:*.py=32:*.rb=32:*.hs=32:*.php=32:*.htm=32:*.html=32:*.shtml=32:*.erb=32:*.haml=32:*.xml=32:*.rdf=32:*.css=32:*.sass=32:*.scss=32:*.less=32:*.js=32:*.coffee=32:*.man=32:*.0=32:*.1=32:*.2=32:*.3=32:*.4=32:*.5=32:*.6=32:*.7=32:*.8=32:*.9=32:*.l=32:*.n=32:*.p=32:*.pod=32:*.tex=32:*.go=32:*.bmp=33:*.cgm=33:*.dl=33:*.dvi=33:*.emf=33:*.eps=33:*.gif=33:*.jpeg=33:*.jpg=33:*.JPG=33:*.mng=33:*.pbm=33:*.pcx=33:*.pdf=33:*.pgm=33:*.png=33:*.PNG=33:*.ppm=33:*.pps=33:*.ppsx=33:*.ps=33:*.svg=33:*.svgz=33:*.tga=33:*.tif=33:*.tiff=33:*.xbm=33:*.xcf=33:*.xpm=33:*.xwd=33:*.xwd=33:*.yuv=33:*.aac=33:*.au=33:*.flac=33:*.m4a=33:*.mid=33:*.midi=33:*.mka=33:*.mp3=33:*.mpa=33:*.mpeg=33:*.mpg=33:*.ogg=33:*.ra=33:*.wav=33:*.anx=33:*.asf=33:*.avi=33:*.axv=33:*.flc=33:*.fli=33:*.flv=33:*.gl=33:*.m2v=33:*.m4v=33:*.mkv=33:*.mov=33:*.MOV=33:*.mp4=33:*.mp4v=33:*.mpeg=33:*.mpg=33:*.nuv=33:*.ogm=33:*.ogv=33:*.ogx=33:*.qt=33:*.rm=33:*.rmvb=33:*.swf=33:*.vob=33:*.webm=33:*.wmv=33:*.doc=31:*.docx=31:*.rtf=31:*.dot=31:*.dotx=31:*.xls=31:*.xlsx=31:*.ppt=31:*.pptx=31:*.fla=31:*.psd=31:*.7z=1;35:*.apk=1;35:*.arj=1;35:*.bin=1;35:*.bz=1;35:*.bz2=1;35:*.cab=1;35:*.deb=1;35:*.dmg=1;35:*.gem=1;35:*.gz=1;35:*.iso=1;35:*.jar=1;35:*.msi=1;35:*.rar=1;35:*.rpm=1;35:*.tar=1;35:*.tbz=1;35:*.tbz2=1;35:*.tgz=1;35:*.tx=1;35:*.war=1;35:*.xpi=1;35:*.xz=1;35:*.z=1;35:*.Z=1;35:*.zip=1;35:*.ANSI-30-black=30:*.ANSI-01;30-brblack=01;30:*.ANSI-31-red=31:*.ANSI-01;31-brred=01;31:*.ANSI-32-green=32:*.ANSI-01;32-brgreen=01;32:*.ANSI-33-yellow=33:*.ANSI-01;33-bryellow=01;33:*.ANSI-34-blue=34:*.ANSI-01;34-brblue=01;34:*.ANSI-35-magenta=35:*.ANSI-01;35-brmagenta=01;35:*.ANSI-36-cyan=36:*.ANSI-01;36-brcyan=01;36:*.ANSI-37-white=37:*.ANSI-01;37-brwhite=01;37:*.log=01;32:*~=01;32:*#=01;32:*.bak=01;33:*.BAK=01;33:*.old=01;33:*.OLD=01;33:*.org_archive=01;33:*.off=01;33:*.OFF=01;33:*.dist=01;33:*.DIST=01;33:*.orig=01;33:*.ORIG=01;33:*.swp=01;33:*.swo=01;33:*,v=01;33:*.gpg=34:*.gpg=34:*.pgp=34:*.asc=34:*.3des=34:*.aes=34:*.enc=34:*.sqlite=34:'

# For Pyright to work with ros packages
export PYTHONPATH=$PYTHONPATH:$HOME/workspace/src/egg/python:$HOME/third_party/VideoRefer/

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
