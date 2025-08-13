# Environment

export PATH="/opt/homebrew/opt/ruby/bin:/opt/homebrew/lib/ruby/gems/3.1.0/bin:$PATH:$HOME/bin"
export NOTE_DIR="$HOME/googledrive/notes/daily-notes"
export DIARY_DIR="$HOME/googledrive/filippo/diary"
export SLURM_DPSS="filippo.gambarota@slurm.dpss.psy.unipd.it"
export SSH_WORK="filippogambarota@147.162.71.133"
export EDITOR="zed --wait"

# Colors

BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LRED='\033[1;31m'
LGREEN='\033[1;32m'
YELLOW='\033[1;33m'
LBLUE='\033[1;34m'
LPURPLE='\033[1;35m'
NC='\033[0m'

# Promt

autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%b '
setopt PROMPT_SUBST
PROMPT='%F{blue}%~%f %F{red}${vcs_info_msg_0_}%f$ '

# Python

function avenv() {
	ENV_NAME="${1:-venv}"
	source "$ENV_NAME/bin/activate"
}

function nvenv() {
	ENV_NAME="${1:-venv}"
	python3 -m venv $ENV_NAME
}

# Alias

alias tedit="zed"
alias dvenv="deactivate"
alias nf="touch"
alias relz="source ~/.zshrc" # reload zsh
alias r="radian"
alias rstudio="open -na Rstudio"
alias note="daily-notes"
alias diary="daily-diary"
alias ediz="tedit ~/.zshrc"
alias gaa="git add ."
alias gcm="git commit -m"
alias server="ssh $SLURM_DPSS"
alias rmds="find . -name '.DS_Store' -type f -delete" # remove all '.DS_Store' files from a folder
alias posh="positron ."
alias sshwork="ssh $SSH_WORK"

# vscode

function codeh(){
	if [ $# -eq 0 ]; then
		code -n .
	else
		code -n $1
	fi
}

# positron

function posh(){
	if [ $# -eq 0 ]; then
		positron .
	else
		positron $1
	fi
}

# rstudio

function rproj(){
  RPROJ=$(find . -type f -name "*.Rproj")
  rstudio $RPROJ
}

# creating a quick R project

function qr(){
    dt=$(date '+%Y-%m-%d');
    name="$1"
    fname="${dt}_${name}"
    mkdir $HOME/work/quick-r/$fname
    touch $HOME/work/quick-r/$fname/$fname.R

    if test "$2" = "rproj"
    then
      touch $HOME/work/quick-r/$fname/$fname.Rproj
      #rstudio $HOME/work/quick-r/$fname/$fname.Rproj
    else
      positron $HOME/work/quick-r/$fname
    fi
}

# GIT/GITHUB

function opengh(){
    ssh=$(git config --get remote.origin.url)
    # Extract the repository path by removing the 'git@github.com:' part
    repo_path=$(echo "$ssh" | sed -E 's/git@github.com://; s/\.git$//')

    # Construct the HTTPS URL
    web_url="https://github.com/$repo_path"

    # Print the result
    open $web_url
}

function qgit(){
  git add .
  git commit -m "update"
  git push
}

# PDF

function pdf2note(){
	file=`basename $1 .pdf`
	pdfannots $1 -o "$file-notes.md"
}

function mpdf(){
    gs -dNOPAUSE -sDEVICE=pdfwrite -sOUTPUTFILE=$1 -dBATCH *.pdf
}

# NOTES

function notes(){
  [ -e $NOTE_DIR/notes/notes.md ] && rm $NOTE_DIR/notes/notes.md

  #echo "# Daily Notes" >> $NOTE_DIR/notes/notes.md

  for f in $NOTE_DIR/*.md
  do
    cat $f >> $NOTE_DIR/notes/notes.md
    echo >> $NOTE_DIR/notes/notes.md
    echo >> $NOTE_DIR/notes/notes.md
  done
  pandoc -s --toc --toc-depth=2 --metadata title="Daily Notes" -o $NOTE_DIR/notes/notes."${1:-html}" $NOTE_DIR/notes/notes.md
  open $NOTE_DIR/notes/notes."${1:-html}"
}

function fdiary(){
  [ -e $DIARY_DIR/fdiary/fdiary.md ] && rm $DIARY_DIR/fdiary/fdiary.md

  #echo "# Daily Notes" >> $NOTE_DIR/notes/notes.md

  for f in $DIARY_DIR/*.md
  do
    cat $f >> $DIARY_DIR/fdiary/fdiary.md
    echo >> $DIARY_DIR/fdiary/fdiary.md
    echo >> $DIARY_DIR/fdiary/fdiary.md
  done
  pandoc -s --embed-resources --standalone --resource-path=$DIARY_DIR/fdiary --toc --toc-depth=2 --metadata title="Diary" -o $DIARY_DIR/fdiary/fdiary."${1:-html}" $DIARY_DIR/fdiary/fdiary.md
  #pandoc -s --css files/diary.css --toc --toc-depth=2 --metadata title="Diary" -o $DIARY_DIR/fdiary/fdiary."${1:-html}" $DIARY_DIR/fdiary/fdiary.md
  open $DIARY_DIR/fdiary/fdiary."${1:-html}"
}

# render and view project note into a folder

function pnote(){
  CDIR="`basename $PWD`"
  if ! test -f "notes.md"; then
    touch "notes.md"
    echo "# $CDIR" >> notes.md
    echo "## Notes" >> notes.md
  else
    pandoc -s --toc -o --metadata title="Project Notes" notes.html notes.md
  fi
}

# backup dotfiles

function bmessage(){
  echo -e "backup for ${RED}$1 ${NC}created!"
}

function bdots(){
    brew leaves > ~/dev/dotfiles/mac/brew.txt
    brew list --cask > ~/dev/dotfiles/mac/brew-cask.txt
    bmessage brew

    cp -fr ~/.zshrc ~/dev/dotfiles/mac/.zshrc
    bmessage .zshrc

    pip freeze > ~/dev/dotfiles/mac/pip.txt
    bmessage pip

    ls /Applications > ~/dev/dotfiles/mac/apps.txt

    cd ~/dev/dotfiles
    git add .
    git commit -m "updating dotfiles"
    git push
}

# Clipboard

function clip2file(){
    pbpaste > $1
}

function file2clip(){
    cat $1 | pbcopy
}

## create a string for naming files without spaces and with dashes

function fname(){
  a="`pbpaste`"
  lower=$(echo "$a" | tr '[:upper:]' '[:lower:]')
  lower_no_spaces="${lower// /-}"
  echo $lower_no_spaces | pbcopy
  echo $lower_no_spaces
}

# Server

function pushserver(){
  rsync -a --exclude ".git" "$PWD" "$SLURM_DPSS:projects/"
}

function pullserver(){
  cdir=$(basename "$PWD")
  rsync -a --exclude ".git" "$SLURM_DPSS:projects/$cdir" .
}

# ZSH

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
