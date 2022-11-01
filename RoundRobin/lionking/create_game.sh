#!/bin/bash

npx create-dosbox@latest lionking

cd lionking
npm install
npm audit fix --force
