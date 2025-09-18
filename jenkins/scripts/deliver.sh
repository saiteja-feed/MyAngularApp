#!/usr/bin/env bash

# Install dependencies
npm install

# Build Angular app (production mode)
ng build --configuration production

echo "Angular build complete"
