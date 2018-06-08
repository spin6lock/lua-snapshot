local print_r = require "print_r"

local tmp = {
    ["userdata: 0x1a47f70"] = "table\n0x1a45e30 : player2",
    ["userdata: 0x1a47f71"] = "table\n0x2168ef0 : [1]",
    ["userdata: 0x1a47f72"] = "func: dump.lua:23\n0x215d018 : foo : dump.lua:31",
    ["userdata: 0x6c74e0"]  = "table\n0x6b6018 : S1 : dump.lua:31",
}

local function cleanup_key_value(input)
    local ret = {}
    for k, v in pairs(input) do
        local clean_key = k:gmatch("userdata: 0x(%w+)")()
        local val_type
        if v:find("^table") then
            val_type = "table"
        elseif v:find("^func:") then
            val_type = "func"
        elseif v:find("^thread:") then
            val_type = "thread"
        else
            val_type = "userdata"
        end
        local parent = v:match("0x(%w+) :")
        local _, finish = v:find("0x(%w+) : ")
        local extra = v:sub(finish + 1, #v)
        local key = extra:match("(%w+) :")
        if not key then
            key = extra
        end
        ret[clean_key] = {
            val_type = val_type,
            parent = parent,
            extra = extra,
            key = key,
        }
    end
    return ret
end

print_r(cleanup_key_value(tmp))

