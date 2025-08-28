local M = require 'posix.fcntl'
local S = require 'posix.sys.stat'
local unistd = require 'posix.unistd'

local lock = {
    shared_module_lock_file = 'shared_module.lock'
}

function lock.do_lock(module_name)
    local fd = M.open(lock.shared_module_lock_file, M.O_CREAT + M.O_RDWR, S.S_IRUSR + S.S_IWUSR + S.S_IRGRP + S.S_IROTH)
    local lock_ = {
        l_type = M.F_WRLCK,
        l_whence = M.SEEK_SET,
        l_start = 0,
        l_len = 0,
    }

    if M.fcntl(fd, M.F_GETLK, lock_) == -1 then
        return false, nil
    end

    if lock_.l_type ~= M.F_UNLCK then
        -- print("File locked!")
        return false, nil
    else
        lock_.l_type = M.F_WRLCK
        if M.fcntl(fd, M.F_SETLKW, lock_) == -1 then
            print("[" .. os.date("%X") .. "] "..tostring(module_name) .. ": Error when do lock")
            io.flush()
            unistd.close(fd)

            return false, nil
        else
            print("[" .. os.date("%X") .. "] "..tostring(module_name) .. ": Lock started")
            io.flush()
            unistd.ftruncate(fd, 0)
            unistd.write(fd, module_name)
            unistd.fsync(fd)

            return true, fd
        end
    end
end

function lock.do_unlock(fd, module_name)
    local lock_ = {
        l_type = M.F_UNLCK,
        l_whence = M.SEEK_SET,
        l_start = 0,
        l_len = 0,
    }

    if M.fcntl(fd, M.F_SETLK, lock_) == -1 then
        print("[" .. os.date("%X") .. "] "..tostring(module_name) .. ": Error when do unlock")
        io.flush()

        return false
    else
        print("[" .. os.date("%X") .. "] "..tostring(module_name) .. ": Lock ended")
        io.flush()
        unistd.close(fd)

        return true
    end
end

function lock.check_lock()
    local fd = M.open(lock.shared_module_lock_file, M.O_RDWR, S.S_IRUSR + S.S_IWUSR + S.S_IRGRP + S.S_IROTH)
    if fd < 0 then
        return false, nil
    end

    local lock_ = {
        l_type = M.F_WRLCK,
        l_whence = M.SEEK_SET,
        l_start = 0,
        l_len = 0,
    }

    local status = M.fcntl(fd, M.F_GETLK, lock_)

    if status == nil then
        unistd.close(fd)
        return false, nil
    end

    if lock_.l_type == M.F_UNLCK then
        unistd.close(fd)
        return false, nil
    else
        unistd.lseek(fd, 0, unistd.SEEK_SET)
        local file_text = unistd.read(fd, 100) or ""
        unistd.close(fd)

        return true, lock_.l_pid, file_text
    end
end

return lock