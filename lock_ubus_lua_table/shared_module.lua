local lock = require 'lock'
local uloop = require 'uloop'
local ubus = require 'ubus'

uloop.init()

local app = {}

local conn = ubus.connect()
if not conn then print("[shared_module.lua] ubus connect error") end

local function print_text(module_name, text)
    if not lock.is_owner_or_unlocked(module_name) then return lock.NOT_OWNER end

    print("[shared_module.lua] text from UBUS: " .. text)
    io.flush()
end

function app.ubus_init()
    local ubus_methods = {
        ["shared_module"] = {
            print_text = {
                function(req, msg)
                    local module_name = msg["module_name"]
                    local text = msg["text"] or ""

                    local result = print_text(module_name, text)
                    local response = {result = lock.get_text_response(result)}
                    conn:reply(req, response)
                end, { module_name = ubus.STRING, text = ubus.STRING }
            },

            unlock = {
                function(req, msg)
                    local module_name = msg["module_name"]
                    local result = lock.unlock(module_name)
                    local response = {result = lock.get_text_response(result)}
                    conn:reply(req, response)
                end, { module_name = ubus.STRING }
            },
        }
    }

    conn:add(ubus_methods)
    app.ubus_methods = ubus_methods
end

app.ubus_init()
uloop.run()
