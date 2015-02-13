#!/bin/sh -ex

cd client
npm install
gulp recompile

cd ..
cd server
npm install
gulp scripts
