<h2 align="center">
🚀 mekb's bash shell config (WIP)<br/><br/>
</h2>

Usage:
- Clone repo with submodules
- Run `./install`

Uses [dotbot](https://github.com/anishathalye/dotbot)

Packages to install:

- `eza` `zoxide` `bat` (or `batcat`) `nvm`

Command to install packages: `paru -S eza zoxide bat nvm`

Install node:

    nvm ls-remote
    nvm install <version> # install node
    \npm i pnpm -g # replace npm with pnpm
    pnpm i pnpm -g
    \npm un corepack npm pnpm -g # 

Install script to open neovim for man pages:
    
    cd pager
    make
    sudo make install

Also see my [other dotfiles](https://github.com/mekb-turtle/dotfiles)
