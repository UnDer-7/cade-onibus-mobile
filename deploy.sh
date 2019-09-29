#!/usr/bin/env bash

ENV_FOLDER=$HOME/workspace/cade/cade_onibus/cade-onibus-mobile/lib/environments

echo "Movendo environment.dart para /tmp"
mv "$ENV_FOLDER"/environment.dart /tmp

echo "Renomeando environment_prod.dart"
mv "$ENV_FOLDER"/environment_prod.dart environment.dart


