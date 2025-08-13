# ENV

export PATH="/opt/homebrew/opt/ruby/bin:/opt/homebrew/lib/ruby/gems/3.1.0/bin:$PATH:$HOME/bin"
export NOTE_DIR="$HOME/googledrive/notes/daily-notes"
export DIARY_DIR="$HOME/googledrive/filippo/diary"
export SLURM_DPSS="filippo.gambarota@slurm.dpss.psy.unipd.it"

# COLORS

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

# PROMPT

autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%b '
setopt PROMPT_SUBST
PROMPT='%F{blue}%~%f %F{red}${vcs_info_msg_0_}%f$ '

# PYTHON VENV

function avenv() {
	ENV_NAME="${1:-venv}"
	source "$ENV_NAME/bin/activate"
}

function nvenv() {
	ENV_NAME="${1:-venv}"
	python3 -m venv $ENV_NAME
}

# ALIAS

alias tedit="subl"
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

# VSCODE

function codeh(){
	if [ $# -eq 0 ]; then
		code -n .
	else
		code -n $1
	fi
}

function posh(){
	if [ $# -eq 0 ]; then
		positron .
	else
		positron $1
	fi
}

# R/RSTUDIO

function rproj(){
  RPROJ=$(find . -type f -name "*.Rproj")
  rstudio $RPROJ
}

# GIT/GITHUB

function opengh(){
  USER=$(git config user.name)
  REPO=$(git config remote.origin.url)
  REPO=$(basename -- "$REPO")
  REPO="${REPO%.*}"
  URL="https://github.com/$USER/$REPO"
  open $URL
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
  pandoc -s --toc --toc-depth=2 --metadata title="Diary" -o $DIARY_DIR/fdiary/fdiary."${1:-html}" $DIARY_DIR/fdiary/fdiary.md
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

# GITIGNORE

function gitignore(){
  if [[ $1 == "r" ]]; then
    FILE="https://raw.githubusercontent.com/github/gitignore/main/R.gitignore"
  else
    FILE="none"
  fi

  if [[ $1 == "new" ]]; then
    if [[ -f ".gitignore"  ]]; then
      echo ".gitignore alread exist!"
    else
      touch .gitignore
    fi
  elif [[ $FILE != "none" ]]; then
    echo -e "\n" >> .gitignore
    wget -O- -q $FILE >> .gitignore
  else
    echo ".gitignore remote file not present!"
  fi
}

# BACKUP

function bmessage(){
  echo -e "backup for ${RED}$1 ${NC}created!"
}

function bdots(){
    brew leaves > ~/dev/dotfiles/brew.txt
    bmessage brew
    cp -fr ~/.zshrc ~/dev/dotfiles/.zshrc
    bmessage .zshrc
    cp -fr ~/.zshared ~/dev/dotfiles/.zshared
    bmessage .zshared
    cd ~/dev/dotfiles
    git add .
    git commit -m "updating dotfiles"
    git push
}

# PDF

function mpdf(){
    gs -dNOPAUSE -sDEVICE=pdfwrite -sOUTPUTFILE=$1 -dBATCH *.pdf
}

# clipboard 2 file

function clip2file(){
  pbpaste > $1
}

# SERVER

function pushserver(){
  rsync -a --exclude ".git" "$PWD" "$SLURM_DPSS:projects/"
}

function pullserver(){
  cdir=$(basename "$PWD")
  rsync -a --exclude ".git" "$SLURM_DPSS:projects/$cdir" .
}

source ~/.zshared

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
