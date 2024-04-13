#!/bin/bash
if [[ "$TERM" != "linux" ]]; then
	alias exa='exa -hg --color=auto --icons -b'
else
	alias exa='exa -hg --color=auto -b'
fi
alias c=cd
alias dc=cd
alias cp='cp -i --one-file-system'
alias mv='mv -i'
alias rm='rm -i --one-file-system'
alias lsfs='lsfs -q -c'
alias less='less --RAW-CONTROL-CHARS'
alias tree='exa --tree'
alias ls=exa
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias diff='diff --color=auto'
alias l='exa -a'
alias la='exa -a'
alias ll='exa -la'
alias sl=exa
alias lsd=exa
alias lss=exa
alias lls=exa
alias lsc='exa -s created'
alias lc='exa -as created'
alias lac='exa -as created'
alias lca='exa -as created'
alias lcl='exa -las created'
alias cd..='cd ..'
alias ..='cd ..'
alias bat='bat --decorations never'
alias dmesg='doas dmesg'
alias gparted='doas gparted'
alias shutdown='/usr/local/sbin/do shutdown' # see https://github.com/mekb-turtle/do
alias restart='/usr/local/sbin/do restart'
alias poweroff='shutdown'
alias reboot='restart'
alias ctl='doas dinitctl'
alias uctl=dinitctl
alias doas='doas '
alias sudo='doas '

alias clone='git clone'
alias grm='git rm --cached'
alias gdiff='git diff'
alias glog='git log'
alias push='git push'
alias pull='git pull'
alias checkout='git checkout'
function ca() { git add . && git commit -S "$@"; }

eval "$(zoxide init bash)"
alias cd=z
alias cdi=zi
function copyfile() {
	if [[ "$#" == 0 ]]; then
		local TEMP
		TEMP="$(mktemp)"
		cat >"$TEMP"
		echo "File: $TEMP" >&2
		copyfile "$TEMP"
		return "$?"
	fi
	if [[ "$#" != 1 ]]; then
		echo "Usage: copy <file>"
		return 1
	fi
	if [[ ! -f "$1" ]]; then
		printf '"%s" is not a file\n' "$1"
		return 1
	fi
	local MIME
	MIME="$(file -Lb --mime-type -- "$1")"
	echo "Mime type: $MIME" >&2
	wl-copy --type "$MIME" <"$1"
}
alias copy=copyfile
alias clip=wl-copy
alias paste=wl-paste
alias xrandr=wlr-randr
alias xev=wev
which bat >/dev/null && alias cat=bat
which batcat >/dev/null && alias cat=batcat
function resetclear() {
	# actually clear the console
	printf "\x1b[H\x1b[2J\x1b[3J\x1bc\x1b]104\x1b[!p\x1b[?3;4l\x1b[4l\x1b>\x1b[?69l"
	stty sane
}
bind -x $'"\x0c":"resetclear"' # clear on ctrl+L
alias reset=resetclear
alias clear=resetclear

# a lot of the following aliases probably aren't going to be useful for other people so feel free to remove them
alias npm=pnpm
alias df='df -h'
alias ufw='doas ufw'
alias uf='ufw status numbered'
alias allowport="doas setcap 'cap_net_bind_service=+ep'" # allow a binary to bind to ports below 1024
alias nt='netstat -tnp'
alias ntl='netstat -ltnp'
alias rsy='rsync --archive --hard-links --acls --xattrs --verbose --one-file-system --atimes --times --numeric-ids' # preserves literally everything about files
# quick aliases for killing programs
function killjava() { killall -9 java; }
function killwine() { killall -9 winepath wineserver wine-preloader wine64-preloader wine64 wine; }

alias javav='doas archlinux-java'
alias ctemp='clone https://github.com/mekb-turtle/c-template.git c-template && cd c-template && rm -rf .git && cd ..' # clone the c-template
function pvc() { doas protonvpn c; }
function pvd() { doas protonvpn d; }
function gimp() {
	/usr/bin/gimp "$@" 2>/dev/null >/dev/null &
	disown
}
function nemo() {
	/usr/bin/nemo "$@" 2>/dev/null >/dev/null &
	disown
}
function file-roller() {
	/usr/bin/file-roller "$@" 2>/dev/null >/dev/null &
	disown
}
function Xephyr() {
	/usr/bin/Xephyr -resizeable "$@" &
	:
}

alias fr=file-roller
alias vi=nvim
alias vim=nvim
alias xephyr=Xephyr

. ~/.bin/misc/bash_aliases_ssh # more aliases for ssh commands
function updssh() { ~/.bin/updssh && exec bash; }

function termdown() { /bin/termdown "$@" && notify-send "Timer finished!"; } # Timer
alias drop='dragon-drop'
alias paclog='grep -aF "[PACMAN]" /var/log/pacman.log' # show pacman log
alias ej='sudo eject'
alias um='sudo umount'
alias m='sudo mount'

function mkcd() {
	test -n "$1" || return
	test -d "$1" || mkdir -- "$1" && builtin cd -- "$1"
}
function getrealpath() { # gets the real path of a file/directory, follows symlinks
	if [[ "$#" == "1" ]]; then
		path="$1"
		if [[ -n "$path" ]]; then
			if ! [[ "$path" == "/"* ]]; then
				oldpath="$path"
				path="$(env which -- "$path" 2>/dev/null)" || path="$oldpath"
			fi
			oldpath=""
			while [[ "$oldpath" != "$path" ]]; do
				oldpath="$path"
				path="$(env realpath -- "$path")"
			done
			printf "%s\n" "$path"
		fi
	else
		echo "Usage: real <file>"
	fi
}
function cdreal() {
	# changes directory to the real path
	local CDREALPATH
	CDREALPATH="$(getrealpath "${1-.}")"
	printf "%s\n" "$CDREALPATH"
	\cd -- "$CDREALPATH"
}
alias real=getrealpath
alias realpath=getrealpath

function cleanup() {
	pacman -Qdtq | paru -Rns - && paru -Sc
}
alias uxplay='uxplay -p'
alias dot='cd ~/.dotfiles/'
function x() {
	# run command through xwayland
	if [[ "$#" == 0 ]]; then
		echo "env -u WAYLAND_DISPLAY -u SDL_VIDEODRIVER -- " | clip
		echo "env -u WAYLAND_DISPLAY -u SDL_VIDEODRIVER -- %command%"
	else
		env -u WAYLAND_DISPLAY -u SDL_VIDEODRIVER -u MOZ_ENABLE_WAYLAND -- "$@"
	fi
}
function eslintrc() { cp ~/.eslintrc.json .; }
alias lns=symlink
alias dm='sudo cryptsetup'
alias dd='dd bs=4096'
function aursrc() { makepkg --printsrcinfo >.SRCINFO; }
alias libTAS='env -uWAYLAND_DISPLAY -uSDL_VIDEODRIVER /bin/libTAS'
alias sedw='sed "/^\s*\(#\|$\)/d"'
alias syu='paru -Syu'
alias Syu='paru -Syu'
alias S='paru -S'
alias waypipe='waypipe '
function uuid(){
	(IFS=' '; printf "%s\n" $(blkid "$@"))
}
