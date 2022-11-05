# Setup {{{1
stty -ixon -ixoff # turns off CTRL-S
[[ $- != *i* ]] && return

bind '"\C-o":"cd_with_fzf\n"'
bind '"\C-f":"open_with_fzf\n"'
bind '"\C-v":"vim\n"'

export BROWSER=/usr/bin/firefox
export EDITOR=vim
export FZF_DEFAULT_COMMAND="fd -H"
export PROMPT_COMMAND=__prompt_command


__prompt_command() {
   code=$?
   [[ $code != 0 ]] && echo -e "$RED✗ ${code}${RESET_COLOR}"
   PS1="($CONDA_DEFAULT_ENV) $(ps1_hostname)\[\e[1;37m\]\W\[\e[1;31m\]:\[\e[0m\] "
}


ps1_hostname() {
   host=$(hostname)
   user=$(whoami)
   if [[ "$host" != "lemur" || "$user" != "joe" ]]; then
      echo "\[\e[2;31m\]$user\[\e[0;37m\]@\[\e[1;36m\]$host "
   fi
}

bind TAB:menu-complete

# less colors {{{2
#export LESS_TERMCAP_mb=$'\e[01;31m' # begin blinking
#export LESS_TERMCAP_md=$'\e[01;34m' # begin bold
#export LESS_TERMCAP_me=$'\e[0m'     # end mode
#export LESS_TERMCAP_se=$'\e[0m'     # end standout-mode
#export LESS_TERMCAP_so=$'\e[01;32m' # begin standout-mode - info box
#export LESS_TERMCAP_ue=$'\e[0m'     # end underline
#export LESS_TERMCAP_us=$'\e[01;36m' # begin underline

# Aliases {{{1
alias duh="du -h -d 0 [^.]*"
alias grep="grep --color=always"
alias htop="sudo htop"
alias l="ls -al"
alias ls='ls --color=auto'
alias open="xdg-open"
alias pandoc="pandoc --pdf-engine=lualatex -H $HOME/.config/pandoc/fonts.tex"
alias r='ranger'
alias syms="find . -maxdepth 1 -type l -print | while read line; do ls -alc "\$line"; done"
alias ll='ls -lah'

# Functions {{{1
open_with_fzf() {
file="$(fd -t f -H | fzf --preview="head -$LINES {}")"
if [ -n "$file" ]; then
    mimetype="$(xdg-mime query filetype $file)"
    default="$(xdg-mime query default $mimetype)"
    if [[ "$default" == "vim.desktop" ]]; then
        vim "$file"
    else
        &>/dev/null xdg-open "$file" & disown
    fi
fi
}
cd_with_fzf() {
cd "$(fd -t d | fzf --preview="tree -L 1 {}" --bind="space:toggle-preview" --preview-window=:hidden)" && clear
}
pacs() {
sudo pacman -Syy $(pacman -Ssq | fzf -m --preview="pacman -Si {}" --preview-window=:hidden --bind=space:toggle-preview)
}
pacman-purge() {
   sudo paccache -r
   sudo pacman -Rsn $(pacman -Qqdt)
}
pacsize() {
   sudo pacman -Qi | \
      awk 'BEGIN{sort="sort -k2 -n"} /Name/ {name=$3} /Size/ {size=$4/1024;print name":",size,"Mb"|sort}' | \
      less
}

[ -f /opt/miniconda3/etc/profile.d/conda.sh ] && source /opt/miniconda3/etc/profile.d/conda.sh
