local lock = require 'lock'
local socket = require 'socket'

local module_id = 3
local module_name = "module_" .. tostring(module_id)

math.randomseed(os.time() + module_id)

while true do
    local ok, fd = lock.do_lock(module_name)
    if ok then
        local lock_time = math.random(1, 3)
        socket.sleep(lock_time)
        lock.do_unlock(fd, module_name)
    end

    local wait_time = math.random(1, 3)
    socket.sleep(wait_time)
end
