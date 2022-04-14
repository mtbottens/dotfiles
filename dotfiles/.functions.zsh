download_latest_rubymine() {
  echo "Installing latest RubyMine"
  echo "This doesn't currently work, check in on https://youtrack.jetbrains.com/issue/CWM-4358 periodically"

  # also interesting: https://youtrack.jetbrains.com/issue/GTW-782
  if [[ $FORCE_RUBYMINE_INSTALL ]]; then
    RM_VERSION_LINK=$(curl -s https://data.services.jetbrains.com/products\?code\=RM\&release.type\=eap%2Crc%2Crelease\&fields\=distributions%2Clink%2Cname%2Creleases | python3 -c "import sys, json; print(json.load(sys.stdin)[0]['releases'][0]['downloads']['linux']['link'])")
    mkdir -p /home/spin/.cache/JetBrains/RemoteDev/dist
    curl -L $RM_VERSION_LINK --output /tmp/rubymine.tar.gz
    tar -zxf /tmp/rubymine.tar.gz -C /home/spin/.cache/JetBrains/RemoteDev/dist
    touch /home/spin/.cache/JetBrains/RemoteDev/dist/latest/.expandSucceeded
  fi
}

install_latest_rubymine() {
  download_latest_rubymine

  ERROR_CODE=$?
  if [[ $ERROR_CODE -ne 0 ]]; then
    echo "Error installing RubyMine"
  fi
}

if [[ $SPIN ]]; then
  # todo: latest needs to be replaced with version of extracted rubymine archive, can get this value from curl request
  if [[ ! -d /home/spin/.cache/JetBrains/RemoteDev/dist/latest/.expandSucceeded ]]; then
    install_latest_rubymine
  fi
fi
