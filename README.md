Dotfiles

A small collection of my dotfiles and configs for a Wayland desktop.

What you'll find here

-   Sway (window manager) and Wayland-related configs (waybar, mako, kanshi, nwg-displays)
-   Neovim (Lua config + plugin lockfile)
-   Alacritty terminal config
-   Rofi themes and launcher scripts
-   Dunst notifications, pavucontrol config
-   Handy scripts in `config/.config/scripts`
-   Shell and terminal: `config/.zshrc`, `config/.tmux.conf`, `config/.vimrc`
-   Editor tooling: `.clang-format`, `.clangd`
-   A wallpaper at `config/.config/wallpaper.jpg`

Quick install

1. Clone this repo somewhere (example):

    git clone https://github.com/guptaanurag2106/dotfiles.git ~/dotfiles

2. Use GNU `stow` to symlink the `config` directory into your home:

    cd ~/dotfiles && stow -t ~ config

3. Start or reload your desktop components (sway, waybar, etc.) as needed.

Neovim

-   Open Neovim — plugins should be managed automatically by the included `lazy` setup. If needed run `:Lazy sync`.

Notes

-   These are opinionated configs — back up your existing files before installing.
-   Edit files under `config/` to adapt to your machine.

If you want, I can help adapt this to your preferred install method or create a simple install script.
