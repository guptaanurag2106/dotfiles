Dotfiles

A small collection of my dotfiles and configs for a Wayland desktop.

What you'll find here

-   Sway (window manager) and Wayland-related configs (waybar, mako, nwg-displays)
-   Neovim (Lua config + plugin lockfile)
-   Alacritty terminal config
-   Rofi themes and launcher scripts
-   Dunst notifications, pavucontrol config
-   Handy scripts in `.config/scripts`
-   Shell and terminal: `.zshrc`, `.tmux.conf`, `.vimrc`
-   Editor tooling: `.clang-format`, `.clangd`

Quick install

1. Clone this repo:

    git clone https://github.com/guptaanurag2106/dotfiles.git ~/dotfiles

2. Manually create symlinks for the configuration files:

    ```bash
    # Link top-level files to home directory
    ln -s ~/dotfiles/.zshrc ~/.zshrc
    ln -s ~/dotfiles/.tmux.conf ~/.tmux.conf
    ln -s ~/dotfiles/.vimrc ~/.vimrc

    # Link .config directory contents
    ln -s ~/dotfiles/.config/* ~/.config/
    ```

3. Start or reload your desktop components (sway, waybar, etc.) as needed.

Neovim

-   Open Neovim — plugins should be managed automatically by the included `lazy` setup. If needed run `:Lazy sync`.

Notes

-   These are opinionated configs — back up your existing files before installing.
-   Edit files under `.config/` to adapt to your machine.
