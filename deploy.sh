#!/usr/bin/env bash

set -e

PROJECT=$HOME/workspace/cade/cade_onibus/cade-onibus-mobile
ENV_FOLDER="$PROJECT"/lib/environments

cd "$ENV_FOLDER"
echo "Trocando environments"
mv environment.dart /tmp
mv environment_prod.dart environment.dart

cd "$PROJECT"
echo "Fazendo build do projeto"
flutter clean
flutter build appbundle

cd "$ENV_FOLDER"
echo "Trocando environments"
mv environment.dart environment_prod.dart
mv /tmp/environment.dart environment.dart
