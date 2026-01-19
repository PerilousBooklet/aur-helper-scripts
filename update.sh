#!/bin/bash


PKGS=$(find packages/ -maxdepth 1 -type d | sed 's|packages/||g' | sort)


if [[ ! -d ./packages ]]; then
  mkdir -v ./packages
fi


cd "./packages" || exit
for i in $PKGS; do
  if [ -d "$i/.git" ]; then
    echo -e "\e[32m[INFO]\e[0m Checking $i..."
    cd "$i" || continue
    git fetch origin
    LOCAL_HASH=$(git rev-parse HEAD)
    REMOTE_HASH=$(git rev-parse origin/HEAD)
    if [ "$LOCAL_HASH" = "$REMOTE_HASH" ]; then
      echo -e "\e[32m[INFO]\e[0m $i is up to date."
    else
      echo -e "\e[33m[WARNING]\e[0m $i is out of date."
      echo -e "\e[33m[WARNING]\e[0m Pulling latest changes..."
      REMOTE_BRANCH=$(git remote show origin | awk '/HEAD branch/ {print $NF}')
      if git show-ref --verify --quiet "refs/remotes/origin/$REMOTE_BRANCH"; then
        git fetch origin
        LOCAL_HASH=$(git rev-parse HEAD)
        REMOTE_HASH=$(git rev-parse origin/HEAD)
        if [ "$LOCAL_HASH" != "$REMOTE_HASH" ]; then
          echo -e "\e[33m[WARNING]\e[0m $i is out of date."
          echo -e "\e[33m[WARNING]\e[0m Showing diff..."
          git diff "$LOCAL_HASH" "$REMOTE_HASH"
          echo -e "\e[33m[WARNING]\e[0m Pulling latest changes..."
          git pull origin "$REMOTE_BRANCH"
        fi
      else
        echo -e "\e[31m[ERROR]\e[0m Remote branch '$REMOTE_BRANCH' not found for $i."
      fi
    fi
    cd ..
  else
    echo -e "\e[32m[INFO]\e[0m Cloning $i..."
    git clone "https://aur.archlinux.org/$i.git"
    sleep 1 # Avoid spamming requests
  fi
done
