#!/bin/bash

npx create-dosbox@latest doom

cd doom
npm install
npm audit fix --force
