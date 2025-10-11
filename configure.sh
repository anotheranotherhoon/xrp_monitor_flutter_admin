#!/bin/sh
git submodule update --init --recursive
fvm flutter clean
# if [ ! -f .env ]; then
#   cp .env.dev.android .env
# fi
# ./sync_locale.sh
fvm flutter pub get
fvm dart run build_runner build --delete-conflicting-outputs
# flutter test --coverage`