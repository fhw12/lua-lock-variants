local NOT_OWNER = "not_owner"

local lock = {
    owner = "",
    response = {
        [NOT_OWNER] = "not owner!",
        ["else"] = "ok",
    },
    NOT_OWNER = NOT_OWNER,
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
    print("[lock.lua] unlock request from " .. module_name .. " (current lock owner: " .. lock.owner .. ")")
    if not lock.is_owner(module_name) then
        print("[lock.lua] module is not the owner!")
        return NOT_OWNER
    end
    lock.owner = ""
    print("[lock.lua] shared module is unlocked!")
    io.flush()
end

return lock