# Stash your environment variables in ~/.localrc. This means they'll stay out
# of your main dotfiles repository (which may be public, like this one), but
# you'll have access to them in your scripts.
if [[ -a ~/.localrc ]]
then
  source ~/.localrc
fi

# all of our zsh files
typeset -U config_files
config_files=($ZSH/**/*.zsh)

# load the path files
for file in ${(M)config_files:#*/path.zsh}
do
  source $file
done

# load everything but the path and completion files
for file in ${${config_files:#*/path.zsh}:#*/completion.zsh}
do
  source $file
done

# load every completion after autocomplete loads
for file in ${(M)config_files:#*/completion.zsh}
do
  source $file
done

unset config_files

# Function paths (fpath)
# Add each topic folder to fpath so that they can add functions and completion scripts.
for topic_folder ($ZSH/*)
  if [ -d $topic_folder ];
    then  fpath=($topic_folder $fpath);
  fi;

# Autocomplete
# Needs to load after adding the fpath(s).
autoload -Uz compinit
compinit

# Functions
fpath=($ZSH/functions $fpath)
autoload -U $ZSH/functions/*(:t)

# Added by Windsurf
export PATH="/Users/andreas/.codeium/windsurf/bin:$PATH"
