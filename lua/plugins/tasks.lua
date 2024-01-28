local utils = require("utils.common")

local function merge_tasks(ts, new_ts)
    local start = #ts + 1
    local idx = 1
    while idx <= #new_ts do
        ts[start] = new_ts[idx]
        idx = idx + 1
        start = start + 1
    end

    return ts
end

local function common_tasks(win)
    return {}
end

local function docker_tasks(win)
    return {
        {
            name = "docker ps",
            cmd = "docker ps",
            close_on_exit = true,
            tags = { "docker" },
        },
        {
            name = "docker ps all",
            cmd = "docker ps -a",
            close_on_exit = true,
            tags = { "docker" }
        },
    }
end

local function makefile_tasks(win)
    local file = utils.find_file('Makefile', 1)
    if not file then
        return {}
    end

    local tasks = {}
    if #file ~= 0 then
        local taskNum = 0
        local dir = vim.fn.getcwd()

        local content = io.popen('cat ' .. file)
        if content == nil then
            return {}
        end

        for line in content:lines() do
            if #line == 0 then
                goto continue
            end

            local start, _end = line:find("^%S*:")
            if start == nil or _end == nil then
                goto continue
            end

            local target = line:sub(start, _end - 1)
            print(target)
            if target == ".PHONY" then
                goto continue
            end

            tasks[taskNum + 1] = {
                name = "make " .. target,
                cmd = "make " .. target,
                cwd = dir,
                tags = { "Makefile" }
            }

            taskNum = taskNum + 1
            ::continue::
        end
        content:close()
    end
    return tasks
end

local function yarn_tasks(win)
    local path = utils.find_file('package.json', 1)
    if not path then
        return {}
    end

    local file = io.open(path, 'r')
    if not file then
        return {}
    end

    local content = file:read("*a")
    local json = vim.json.decode(content)
    if not json or not json.scripts then
        return {}
    end
    file:close()

    local tasks = {}
    local taskNum = 0
    for name in pairs(json.scripts) do
        print(name)
        tasks[taskNum + 1] = {
            name = name,
            cmd = 'yarn run ' .. name,
            tags = { "yarn", "npm", "js" }
        }
        taskNum = taskNum + 1
    end

    return tasks
end

local function golang_tasks(win)
    local path = utils.find_file('go.mod', 1)
    if not path then
        return {}
    end

    return {
        {
            name = 'go mod tidy',
            cmd = 'go mod tidy ; read -',
            close_on_exit = true,
            tags = { 'golang' }
        },
        {
            name = 'go mod vendor',
            cmd = 'go mod vendor; read -',
            close_on_exit = true,
            tags = { 'golang' }
        },
    }
end

local function docker_compose_tasks(win)
    local name = vim.api.nvim_buf_get_name(0)
    local dir = name:match(".*/")
    if string.match(name, "^.*docker%-compose%.yml$") then
        return {
            {
                name = "docker-compose up",
                cmd = "docker-compose up -d",
                cwd = dir,
            },
            {
                name = "docker-compose down",
                cmd = "docker-compose down",
                cwd = dir,
            },
        }
    end

    return {}
end

local function global_tasks(win)
    local ts = {}
    ts = merge_tasks(ts, common_tasks(win))
    ts = merge_tasks(ts, docker_tasks(win))
    ts = merge_tasks(ts, makefile_tasks(win))
    ts = merge_tasks(ts, yarn_tasks(win))
    ts = merge_tasks(ts, golang_tasks(win))
    ts = merge_tasks(ts, docker_compose_tasks(win))
    return ts
end


return {
    "jedrzejboczar/toggletasks.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "akinsho/toggleterm.nvim",
        "nvim-telescope/telescope.nvim",
    },
    config = function()
        require("toggletasks").setup({
            debug = false,
            silent = false,     -- don't show "info" messages
            short_paths = true, -- display relative paths when possible
            -- Paths (without extension) to task configuration files (relative to scanned directory)
            -- All supported extensions will be tested, e.g. '.toggletasks.json', '.toggletasks.yaml'
            search_paths = {
                "toggletasks",
                ".toggletasks",
                ".nvim/toggletasks",
            },
            -- Directories to consider when searching for available tasks for current window
            scan = {
                global_cwd = true,   -- vim.fn.getcwd(-1, -1)
                tab_cwd = true,      -- vim.fn.getcwd(-1, tab)
                win_cwd = true,      -- vim.fn.getcwd(win)
                lsp_root = true,     -- root_dir for first LSP available for the buffer
                dirs = {},           -- explicit list of directories to search or function(win): dirs
                rtp = true,          -- scan directories in &runtimepath
                rtp_ftplugin = true, -- scan in &rtp by filetype, e.g. ftplugin/c/toggletasks.json
            },
            tasks = global_tasks,    -- list of global tasks or function(win): tasks
            -- this is basically the "Config format" defined using Lua tables
            -- Language server priorities when selecting lsp_root (default is 0)
            lsp_priorities = {
                ["null-ls"] = -10,
            },
            -- Defaults used when opening task's terminal (see Terminal:new() in toggleterm/terminal.lua)
            toggleterm = {
                close_on_exit = false,
                hidden = true,
            },
            -- Configuration of telescope pickers
            telescope = {
                spawn = {
                    open_single = true,   -- auto-open terminal window when spawning a single task
                    show_running = false, -- include already running tasks in picker candidates
                    -- Replaces default select_* actions to spawn task (and change toggleterm
                    -- direction for select horiz/vert/tab)
                    mappings = {
                        select_float = "<C-f>",
                        spawn_smart = "<C-a>", -- all if no entries selected, else use multi-select
                        spawn_all = "<M-a>",   -- all visible entries
                        spawn_selected = nil,  -- entries selected via multi-select (default <tab>)
                    },
                },
                -- Replaces default select_* actions to open task terminal (and change toggleterm
                -- direction for select horiz/vert/tab)
                select = {
                    mappings = {
                        select_float = "<C-f>",
                        open_smart = "<C-a>",
                        open_all = "<M-a>",
                        open_selected = nil,
                        kill_smart = "<C-q>",
                        kill_all = "<M-q>",
                        kill_selected = nil,
                        respawn_smart = "<C-s>",
                        respawn_all = "<M-s>",
                        respawn_selected = nil,
                    },
                },
            },
        })
    end,
}
