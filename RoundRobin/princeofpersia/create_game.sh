#!/bin/bash

npx create-dosbox@latest princeofpersia

cd princeofpersia
npm install
npm audit fix --force
