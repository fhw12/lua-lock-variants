local NOT_OWNER = "not_owner"

local lock = {
    owner = "",
    response = {
        [NOT_OWNER] = "not owner!",
        ["else"] = "ok",
    },
}

function lock.get_text_response(status)
    if status == NOT_OWNER then
        return lock.response[NOT_OWNER]
    end

    return lock.response["else"]
end

function lock.is_owner_or_unlocked(module_name)
    if lock.owner == "" or lock.owner == module_name then
        lock.owner = module_name
        return true
    end

    return false
end

function lock.is_owner(module_name)
    if lock.owner == module_name then
        return true
    end

    return false
end

function lock.unlock(module_name)
    print("Unlock request")
    print("Current owner: " .. lock.owner)
    print("Request from: " .. module_name)
    if not lock.is_owner(module_name) then return NOT_OWNER end
    lock.owner = ""
    print("[lock.lua] shared module is unlocked!")
    io.flush()
end

return lock