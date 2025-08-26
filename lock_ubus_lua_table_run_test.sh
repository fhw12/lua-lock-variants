#!/bin/sh

cd lock_ubus_lua_table

lua shared_module.lua &
lua module1.lua &
lua module2.lua &
lua module3.lua &
wait
