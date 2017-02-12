#!/bin/bash

if [ ! -f ./config/secrets.yml ]; then
  echo -e "\nGenerating a secrets.yml file"

  # Random Keys
  KEY_DEV=$(bin/rake secret)
  KEY_TEST=$(bin/rake secret)

  # Generate the file
  cat > ./config/secrets.yml <<EOL
development:
  secret_key_base: ${KEY_DEV}
  digital_ocean_token: <%= ENV["DIGITALOCEAN_TOKEN"] %>

test:
  secret_key_base: ${KEY_TEST}
  digital_ocean_token: <%= ENV["DIGITALOCEAN_TOKEN"] %>

production:
  secret_key_base: <%= ENV["SECRET_KEY_BASE"] %>
  digital_ocean_token: <%= ENV["DIGITALOCEAN_TOKEN"] %>
EOL
fi
