download_latest_rubymine() {
  echo "Installing latest RubyMine"
  RM_VERSION_LINK=$(curl -s https://data.services.jetbrains.com/products\?code\=RM\&release.type\=eap%2Crc%2Crelease\&fields\=distributions%2Clink%2Cname%2Creleases | python3 -c "import sys, json; print(json.load(sys.stdin)[0]['releases'][0]['downloads']['linux']['link'])")
  mkdir -p /home/spin/.cache/JetBrains/RemoteDev/dist
  curl -L $RM_VERSION_LINK --output /tmp/rubymine.tar.gz
  tar -zxf /tmp/rubymine.tar.gz -C /home/spin/.cache/JetBrains/RemoteDev/dist
  touch /home/spin/.cache/JetBrains/RemoteDev/dist/latest/.expandSucceeded
}

install_latest_rubymine() {
  download_latest_rubymine

  ERROR_CODE=$?
  if [[ $ERROR_CODE -ne 0 ]]; then
    echo "Error installing RubyMine"
  fi
}

if [[ $SPIN ]]; then
  if [[ ! -d /home/spin/.cache/JetBrains/RemoteDev/dist/latest/.expandSucceeded ]]; then
    install_latest_rubymine
  fi
fi
