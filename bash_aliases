#!/bin/bash
HAS_EXA=false
if type exa >/dev/null 2>/dev/null; then HAS_EXA=true; fi
if $HAS_EXA; then
	if [[ "$TERM" != "linux" ]]; then
		alias exa='exa -hg --color=auto --icons -b'
	else
		alias exa='exa -hg --color=auto -b'
	fi
	alias tree='exa --tree'
	alias ls='exa -s modified'
	alias lg='exa -s size -l'
	alias l='ls -a'
	alias la='ls -a'
	alias ll='ls -la'
	alias sl=ls
	alias lsd=ls
	alias lac='ls -a'
	alias lca='ls -a'
	alias lcl='ls -la'
else
	alias ls='ls --color=auto -b -k -t'
	alias lg='ls -l --color=auto -S -k'
	alias l='ls -A'
	alias la='ls -A'
	alias ll='ls -lA'
	alias sl=ls
	alias lsd=ls
	alias lac='ls -A'
	alias lca='ls -A'
	alias lcl='ls -lA'
fi
alias c=cd
alias dc=cd
if cp --help | grep --quiet -- --one-file-system; then
	alias cp='cp -i --one-file-system'
else
	alias cp='cp -i'
fi
alias mv='mv -i'
if rm --help | grep --quiet -- --one-file-system; then
	alias rm='rm -i --one-file-system'
	alias rmu='\rm --one-file-system'
else
	alias rm='rm -i'
	alias rmu='\rm'
fi
alias lsfs='lsfs -q -c'
alias less='less --RAW-CONTROL-CHARS'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias diff='diff --color=auto'
alias cd..='cd ..'
alias ..='cd ..'
alias vg='valgrind --track-origins=yes --show-leak-kinds=all --leak-check=full'
alias trash='trash -v'
if [[ "$OS" == "Windows_NT" ]]; then
	alias shutdown='\shutdown -s -t 0'
	alias restart='\shutdown -r -t 0'
	alias sudo='sudo '
	alias doas='sudo '
else
	alias dmesg='sudo dmesg'
	alias gparted='sudo gparted'
	if [[ -f /usr/local/sbin/do ]]; then
		alias shutdown='/usr/local/sbin/do shutdown' # see https://github.com/mekb-turtle/do
		alias restart='/usr/local/sbin/do restart'
	else
		alias shutdown='sudo env poweroff'
		alias restart='sudo env reboot'
	fi
	alias ctl='sudo dinitctl'
	alias uctl=dinitctl
	alias doas='sudo '
	if [[ -n "$DISPLAY" ]]; then
		alias sudo='sudo -A '
	else
		alias sudo='sudo '
	fi

	if type paru >/dev/null 2>/dev/null; then
		function cleanup() {
			local pkg
			pkg="$(paru -Qdtq)"
			if [[ -n "$pkg" ]]; then
				paru -Rns - <<<"$pkg" || return "$?"
			fi
			paru -Sc
		}
	fi
fi
alias poweroff='shutdown'
alias reboot='restart'

alias neofetch=hyfetch

alias clone='git clone'
alias grm='git rm --cached'
alias gdiff='git diff'
alias gstatus='git status'
alias gstat='git status'
alias glog='git log'
alias push='git push'
alias pull='git pull'
alias checkout='git checkout'
alias commit='git commit'
alias ca='git commit -S'

eval "$(zoxide init bash)"
alias cd=z
alias cdi=zi
alias copy=copyfile
alias clip=wl-copy
alias paste=wl-paste
alias xrandr=wlr-randr
alias xev=wev
if type bat >/dev/null 2>/dev/null; then
	alias bat='bat --decorations never'
	alias cat=bat
fi
if type batcat >/dev/null 2>/dev/null; then
	alias batcat='batcat --decorations never'
	alias bat=batcat
	alias cat=batcat
fi
function resetclear() {
	# actually clear the console
	printf "\x1b[0m"     # reset colors
	printf "\x1b[u"      # restore cursor position
	printf "\x1b[?25h"   # show cursor
	printf "\x1b[?47l"   # restore screen
	printf "\x1b[?1049l" # disable alternative buffer
	printf "\x1b[H"      # move cursor to top left
	printf "\x1b[2J"     # clear screen
	printf "\x1b[3J"     # clear scrollback
	printf "\x1b]2;\x07" # reset title
	stty sane
}
alias reset=resetclear
alias clear=resetclear

# a lot of the following aliases probably aren't going to be useful for other people so feel free to remove them
alias npm=pnpm
alias npx=pnpx
alias df='df -h'
alias ufw='sudo ufw'
alias uf='ufw status numbered'
function allowport() {
	if [[ "$#" -lt 1 ]]; then
		echo "Usage: allowport <binary>"
		return 1
	fi
	local path
	for i in "$@"; do
		path="$(realpath -- "$i")"
		if [[ "$?" != 0 ]]; then
			continue
		fi
		if [[ ! -e "$path" ]]; then
			echo "File not found: $path" >&2
			continue
		fi
		sudo setcap 'cap_net_bind_service=+ep' "$path"
	done
}
alias nt='netstat -tp'
alias ntl='netstat -ltp'
alias rsy='rsync --archive --hard-links --acls --xattrs --one-file-system --atimes --times --numeric-ids --info=progress2' # preserves literally everything about files
alias tarall='tar --one-file-system --xattrs --acls --numeric-owner --preserve-permissions --xattrs --xattrs-include=* --acls --atime-preserve'
# quick aliases for killing programs
function killjava() { killall -9 java; }
function killwine() { killall -9 winepath wineserver wine-preloader wine64-preloader wine64 wine; }

alias javav='sudo archlinux-java'
alias ctemp='clone https://github.com/mekb-turtle/c-template.git c-template && cd c-template && rm -rf .git && cd ..' # clone the c-template
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

GIT_INIT=4b825dc642cb6eb9a060e54bf8d69288fbee4904

# more aliases for ssh and other commands
# obviously not provided in this repository
if [[ -f ~/.bin/misc/bash_aliases_ssh ]]; then . ~/.bin/misc/bash_aliases_ssh; fi # more aliases for ssh commands
function updssh() { ~/.bin/updssh && exec bash; }

function termdown() { /bin/termdown "$@" && notify-send "Timer finished!"; } # Timer
alias drop='dragon-drop'
alias paclog='grep -aF "[PACMAN]" /var/log/pacman.log' # show pacman log
alias ej='sudo eject'
alias um='sudo umount'
alias m='sudo mount'
alias mr='sudo mount -r'

function mkcd() {
	test -n "$1" || return
	test -d "$1" || mkdir -- "$1" && builtin cd -- "$1"
}
function cdreal() {
	# changes directory to the real path
	local CDREALPATH
	CDREALPATH="$(realpath -- "${1-.}")"
	printf "%s\n" "$CDREALPATH"
	\cd -- "$CDREALPATH"
}
alias real=realpath

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
alias cal='cal --sunday --year'
alias waypipe='waypipe '
function uuid() {
	(
		IFS=' '
		printf "%s\n" $(blkid "$@")
	)
}
alias fd='sudo fdisk -l'
function scr() {
	echo "Reattach: screen -R <screen>"
	echo "Detach: Ctrl+A, D"
	echo "New: screen -T xterm-kitty -S <screen>"
	echo "List: screen -ls"
	screen -ls
}
function meson-setup() {
	if [[ ! -f meson.build ]]; then
		echo "meson.build not found" >&2
		return 1
	fi
	if [[ ! -f build/meson-info/intro-projectinfo.json ]]; then
		meson setup build "$@" || return "$?"
	fi
}
alias mes='meson-setup && meson compile -C build'
alias mtest='meson-setup && meson test -C build'
alias vts='vt scan file -o'
alias mpvlive='mpv --profile=low-latency --cache=no --untimed'
alias mpva='mpv --no-video'
function suppress() {
	"$@" >/dev/null 2>/dev/null
}
