local lock = require 'lock'
local socket = require 'socket'

local module_id = 4
local module_name = "module_" .. tostring(module_id)

local ok, fd = lock.do_lock(module_name)
if ok then
    print("["..module_name.."] infinity_lock started")
    io.flush()
    socket.sleep(1000000000)
end
