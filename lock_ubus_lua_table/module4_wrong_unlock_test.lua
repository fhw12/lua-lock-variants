local util = require 'luci.util'
local socket = require 'socket'

local module_id = 4
local module_name = "module_" .. tostring(module_id)

socket.sleep(10)

while true do
    util.ubus("shared_module", "unlock", { module_name = module_name })
    socket.sleep(10)
end
