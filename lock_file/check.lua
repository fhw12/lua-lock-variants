local lock = require 'lock'
local socket = require 'socket'

while true do
    local is_locked, process_id, file_text = lock.check_lock()
    if is_locked then
        local module_str = tostring(file_text) or ""
        local pid_str = tostring(process_id) or ""
        print("[" .. os.date("%X") .. "] Locked by (module: " .. module_str .. ", pid: " .. tostring(pid_str) .. ")")
    else
        print("[" .. os.date("%X") .. "] No lock")
    end
    io.flush()
    socket.sleep(1)
end