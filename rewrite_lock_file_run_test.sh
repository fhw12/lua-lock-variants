#!/bin/sh

cd lock_file

lua check.lua &
lua module4_infinity_lock.lua &
lua module5_without_using_lock.lua &
wait
