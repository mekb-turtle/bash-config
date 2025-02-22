#!/bin/bash
[[ "$-" != *i* ]] && return
HISTCONTROL=ignoreboth
[[ "$DISPLAY" ]] && shopt -s checkwinsize
shopt -s extglob
shopt -s histappend
shopt -s globstar
HISTFILE=~/.bash_history
HISTSIZE=100000
HISTFILESIZE=10000000
GLOBIGNORE=.:..
export BAT_PAGER=
export BAT_THEME="Catppuccin Mocha"
export LS_COLORS="fi=38;5;15:bd=38;5;13:cd=38;5;11:ln=38;5;14:pi=38;5;11:so=38;5;11:di=38;5;12:ex=38;5;10:or=38;5;1:*.jar=38;5;208:*.z64=38;5;48:*.n64=38;5;48:*.nds=38;5;48:*.cia=38;5;48:*.nes=38;5;48:*.gb=38;5;48:*.gbc=38;5;48:*.gba=38;5;48:*.sgm=38;5;48:*.sav=38;5;48:*.lua=38;5;126:*.py=38;5;184"
export EXA_COLORS="ur=38;5;11:uw=38;5;9:ux=38;5;10:ue=38;5;10:gr=38;5;11:gw=38;5;9:gx=38;5;10:tr=38;5;11:tw=38;5;9:tx=38;5;10:su=38;5;13:sf=38;5;13:xa=38;5;13:sn=38;5;14:sb=38;5;6:df=38;5;11:ds=38;5;11:uu=38;5;14:un=38;5;15:gu=38;5;10:gn=38;5;15:lc=38;5;9:lm=38;5;13:ga=38;5;10:gm=38;5;14:gd=38;5;9:gv=38;5;11:gt=38;5;13:xx=38;5;8:da=38;5;14:in=38;5;13:bl=38;5;13:hd=38;5;15:lp=38;5;14:cc=48;5;15;38;5;0"
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--color=selected-bg:#45475a \
--multi"
export EDITOR=/usr/bin/nvim
export MANPAGER='/usr/bin/nvim +Man!'
PROMPT_COMMAND=
function get_clean_return_value() {
	local RETVAL=$?
	if [[ $RETVAL -ne 0 ]]; then printf %s "$RETVAL "; fi
}
function get_clean_working_directory() {
	local N_CHAR
	N_CHAR=48
	local PWDHOME
	local P
	local ORIG
	PWDHOME="$PWD"
	PREFIX=""
	# replace home with ~
	if [[ "$PWDHOME" == "$HOME"* ]]; then PWDHOME="${PWDHOME/"$HOME"/"~"}"; fi
	while [[ "${#PWDHOME}" -gt "$N_CHAR" ]]; do
		# trim leading directory until less than n characters
		PREFIX="..."
		ORIG="${#PWDHOME}"
		PWDHOME="${PWDHOME#*\/}"
		if [[ "${#PWDHOME}" == "$ORIG" ]]; then break; fi
	done
	while [[ "${#PWDHOME}" -gt "$N_CHAR" ]]; do
		# trim leading characters until less than n characters
		# e.g if directory name is too long
		PREFIX="...—"
		PWDHOME="${PWDHOME:1}"
	done
	printf "%s" "$PREFIX$PWDHOME"
}
function get_clean_computer_name() {
	if [[ -n "$SSH_CLIENT" ]]; then printf "%s" "($(uname -n)) "; fi
}
PS0=
PS1='\[\e]2;\$ $(get_clean_working_directory)\a\]\[\e[0;2;37m\]'"$(get_clean_computer_name)"'$(get_clean_return_value)\[\e[0;38;5;10m\e]11;#1e1e2e\a\]\$\[\e[0;38;5;14m\] $(get_clean_working_directory)\[\e[0;37m\] > \[\e[0m\]'
PS2="\[\e[0;37m\]> \[\e[0m\]"
. ~/.bash_aliases
append_path() {
	case ":$PATH:" in
	*:"$1":*) ;;
	*)
		PATH="${PATH:+$PATH:}$1"
		;;
	esac
}
prepend_path() {
	case ":$PATH:" in
	*:"$1":*) ;;
	*)
		PATH="$1${PATH:+:$PATH}"
		;;
	esac
}
append_path "/usr/local/bin"
append_path "$HOME/.local/bin"
append_path "$HOME/.cargo/bin"
prepend_path "$HOME/.bin"
prepend_path "$HOME/.bin/convert"
export PNPM_HOME="$HOME/.local/share/pnpm"
[[ -f /usr/share/nvm/init-nvm.sh ]] && . /usr/share/nvm/init-nvm.sh
append_path "$PNPM_HOME"
export PATH
CDPATH=".:$HOME"
TMP_DIR="/tmp/env_${UID}"
mkdir -p -- "$TMP_DIR"
chmod 700 -- "$TMP_DIR"
SSH_ENV="$TMP_DIR/ssh_env"
if [[ ! -f "$SSH_ENV" ]]; then /usr/bin/ssh-agent | sed "/^echo/d;s/;.*//" >"$SSH_ENV"; fi
chmod 600 -- "$SSH_ENV"
[[ -s "$SSH_ENV" ]] && IFS=$'\n' export $(<"$SSH_ENV")
unset TMP_DIR SSH_ENV DBUS_ENV
export GPG_TTY="$(tty)"
export SSH_ASKPASS=/usr/local/bin/askpass
export SSH_ASKPASS_REQUIRE=force
export XDG_CONFIG_HOME=~/.config
if type mold >/dev/null 2>/dev/null; then export LDFLAGS=-fuse-ld=mold; fi
[[ -n "$UID" ]] && export XDG_RUNTIME_DIR="/run/user/$UID"
mkdir /run/user/1000/mpd -p
type setterm >/dev/null 2>/dev/null && setterm -cursor on
function check_todo() {
	local A
	A="$(script -qefc 'todo list' /dev/null)"
	if [[ "$?" -eq 0 ]]; then
		printf "%s\n" "$A"
	fi
}
check_todo
if [[ -f ~/.bashrc.local ]]; then
	. ~/.bashrc.local
fi
unset -f check_todo
if [[ $- == *i* ]]; then
	if [[ -f /usr/share/blesh/ble.sh ]]; then
		source /usr/share/blesh/ble.sh
	elif [[ -f ~/.local/share/blesh/ble.sh ]]; then
		source ~/.local/share/blesh/ble.sh
	fi
fi
true
