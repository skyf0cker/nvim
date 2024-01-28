local function trim_space(s)
    return s:match("^%s*(.-)%s*$")
end

local function find_file(name, max_depth)
    local h = io.popen("find . -name " .. name .. " -maxdepth " .. max_depth)
    if not h then
        return nil, "find command exec failed"
    end

    local output = h:read("*a")
    return trim_space(output)
end

return {
    trim_space = trim_space,
    find_file = find_file,
}
