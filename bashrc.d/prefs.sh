# auto cd
shopt -s autocd
# auto complete
bind 'set show-all-if-ambiguous on'
bind 'TAB:menu-complete'
# vi mode
set -o vi
LS_COLORS=$LS_COLORS:'ow=1;34:' ; export LS_COLORS
