#!/bin/sh

cd lock_file

lua check.lua &
lua module1.lua &
lua module2.lua &
lua module3.lua &
wait
