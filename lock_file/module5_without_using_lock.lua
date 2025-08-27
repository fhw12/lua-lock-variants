local M = require 'posix.fcntl'
local unistd = require 'posix.unistd'
local socket = require 'socket'

local module_id = 5
local module_name = "module_" .. tostring(module_id)

socket.sleep(3)

local fd = M.open("shared_module.lock", M.O_WRONLY, 0)

local lock = {
    l_type = M.F_WRLCK,
    l_whence = M.SEEK_SET,
    l_start = 0,
    l_len = 0,
}

if M.fcntl(fd, M.F_SETLK, lock) == -1 then
    print("[module5] file locked !")
    io.flush()
    os.exit(0)
else
    unistd.lseek(fd, 0, unistd.SEEK_SET)
    unistd.write(fd, "locked file rewrited by " .. module_name)
    unistd.close(fd)

    print("["..module_name.."] file rewrite end")
    io.flush()
end