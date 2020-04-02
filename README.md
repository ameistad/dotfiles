# Dotfiles!

This is my dotfiles. I orignally forked my dotfiles from the excellent [holman/dotfiles](https://github.com/holman/dotfiles), but as I did more and more edits it was time I simplified it a bit. It's a bit faster too.

## Install

To install you just create a symlink between the zshrc.symlink and ~/.zshrc
```sh
ln -s /path/to/dotfiles/zshrc.zsh ~/.zshrc
```

## How it works
The main file is the zshrc.symlink. This file is run everytime a new shell is created. The script is setup to add every file in which is called:
- */path.zsh
- */completion.zsh
- */aliases.zsh
- */functions

### Modules
You can arrange everything under modules. So if you have Node.js specific aliases you make a directory under /modules named node.
Here you can add a aliases.zsh.
