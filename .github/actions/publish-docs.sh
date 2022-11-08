#!/bin/bash

HOST="$1"
HOST_PATH="$2"
SSH_PRIVATE_KEY="$3"
SSH_KNOWN_HOST="$4"
SSH_PRIVATE_KEY_PATH="$HOME/.ssh/${GITHUB_REPOSITORY:-publish-docs}"

if [ "$#" -ne 4 ]; then
  echo -e "not enough arguments USAGE:\n\n$0 \$HOST \$HOST_PATH \$SSH_PRIVATE_KEY \$SSH_KNOWN_HOST\n\n" >&2
  exit 1
fi

(
  set -e
  #install -m 600 -D /dev/null "$SSH_PRIVATE_KEY_PATH"
  #echo "$SSH_PRIVATE_KEY" > "$SSH_PRIVATE_KEY_PATH"
  #echo "$SSH_KNOWN_HOST" > ~/.ssh/known_hosts
  if [ -n "$BUILD_REFNAME" ]; then
    VERSION_DIR=`find build/site -maxdepth 1 -type d \( -name '[0-9]*' \) -printf '%f\t' | cut -f1`
    if [ -n "$VERSION_DIR" ]; then
      rsync --include '/sitemap*.xml' --include /site-manifest.json --include "/$VERSION_DIR/" --include "/$VERSION_DIR/**" --exclude '/**' --delete -avze "ssh -i $SSH_PRIVATE_KEY_PATH" build/site/ "$HOST:$HOST_PATH"
    else
      rsync --exclude '/_/' --exclude /404.html --exclude /.htaccess --exclude '/[1-9].*' --exclude '/[1-9][0-9].*' --delete -avze "ssh -i $SSH_PRIVATE_KEY_PATH" build/site/ "$HOST:$HOST_PATH"
    fi
  else
    rsync --delete -avze "ssh -i $SSH_PRIVATE_KEY_PATH" build/site/ "$HOST:$HOST_PATH"
  fi
)
exit_code=$?

#rm -f "$SSH_PRIVATE_KEY_PATH"

exit $exit_code
