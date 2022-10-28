#!/bin/bash

npx create-dosbox@latest app

cd app
npm install
npm audit fix --force
