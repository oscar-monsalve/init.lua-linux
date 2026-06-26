# OpenFOAM LSP Setup

To install `foam_ls` through Mason, make sure Node.js LTS and npm are installed:

```sh
sudo pacman -S nodejs-lts-jod npm
```

If Mason installation fails, clean the previous failed install:

```sh
rm -rf ~/.local/share/nvim/mason/staging/foam-language-server
rm -rf ~/.local/share/nvim/mason/packages/foam-language-server
rm -f ~/.local/share/nvim/mason/bin/foam-ls
```

Then reinstall inside Neovim:

```vim
:MasonInstall foam-language-server
```
