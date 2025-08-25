# Dotfiles!

Orignally forked from the excellent [holman/dotfiles](https://github.com/holman/dotfiles)

## Install

Create ~/.localrc and add the following:
```sh
export PATH="/opt/homebrew/bin:$PATH"
# Your dotfiles folder path
export ZSH=$HOME/Projects/dotfiles
# Your project folder that we can `p [tab]` to
export PROJECTS_DIRECTORY=$HOME/Projects
```

Create a symlink between the zshrc.symlink and ~/.zshrc
```sh
ln -s /path/to/dotfiles/.zshrc ~/.zshrc
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
