local util = require 'luci.util'
local socket = require 'socket'

local module_id = 3
local module_name = "module_" .. tostring(module_id)

local messages = {
    "First message from " .. module_name,
    "Second message from " .. module_name,
    "Another message from " .. module_name,
}

math.randomseed(os.time() + module_id)
socket.sleep(math.random(1, 2))

while true do
    for msg_id = 1, #messages do
        local msg = messages[msg_id]

        while true do
            local res = util.ubus("shared_module", "print_text", {module_name = module_name, text = msg})
            socket.sleep(math.random(1, 2))
            if res.result == "ok" then break end
        end
    end

    util.ubus("shared_module", "unlock", { module_name = module_name })
    socket.sleep(math.random(1, 2))
end
