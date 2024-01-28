return {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    lazy = true,
    config = function()
        local lib = require("nvim-tree.lib")
        local view = require("nvim-tree.view")

        local function vsplit_preview()
            -- open as vsplit on current node
            local action = "vsplit"
            local node = lib.get_node_at_cursor()

            -- Just copy what's done normally with vsplit
            if node.link_to and not node.nodes then
                require("nvim-tree.actions.node.open-file").fn(action, node.link_to)
            elseif node.nodes ~= nil then
                lib.expand_or_collapse(node)
            else
                require("nvim-tree.actions.node.open-file").fn(action, node.absolute_path)
            end

            -- Finally refocus on tree if it was lost
            view.focus()
        end

        local tree_actions = {
            {
                name = "Create node",
                handler = require("nvim-tree.api").fs.create,
            },
            {
                name = "Remove node",
                handler = require("nvim-tree.api").fs.remove,
            },
            {
                name = "Trash node",
                handler = require("nvim-tree.api").fs.trash,
            },
            {
                name = "Copy node",
                handler = require("nvim-tree.api").fs.copy.node,
            },
            {
                name = "Paste node",
                handler = require("nvim-tree.api").fs.paste,
            },
            {
                name = "Rename node",
                handler = require("nvim-tree.api").fs.rename,
            },
            {
                name = "Fully rename node",
                handler = require("nvim-tree.api").fs.rename_sub,
            },
            {
                name = "Copy filename",
                handler = require("nvim-tree.api").fs.copy.filename,
            },
            {
                name = "Copy path",
                handler = require("nvim-tree.api").fs.copy.absolute_path,
            },
            {
                name = "Open in a new tab",
                handler = require("nvim-tree.api").node.open.tab,
            },
            {
                name = "find file",
                handler = require("utils.tree").launch_find_files,
            },
            {
                name = "live grep",
                handler = require("utils.tree").launch_live_grep,
            },
        }

        local function tree_actions_menu()
            local node = lib.get_node_at_cursor()
            local entry_maker = function(menu_item)
                return {
                    value = menu_item,
                    ordinal = menu_item.name,
                    display = menu_item.name,
                }
            end

            local finder = require("telescope.finders").new_table({
                results = tree_actions,
                entry_maker = entry_maker,
            })

            local sorter = require("telescope.sorters").get_generic_fuzzy_sorter()

            local default_options = {
                finder = finder,
                sorter = sorter,
                attach_mappings = function(prompt_buffer_number)
                    local actions = require("telescope.actions")

                    -- On item select
                    actions.select_default:replace(function()
                        local state = require("telescope.actions.state")
                        local selection = state.get_selected_entry()
                        -- Closing the picker
                        actions.close(prompt_buffer_number)
                        -- Executing the callback
                        selection.value.handler(node)
                    end)

                    -- The following actions are disabled in this example
                    -- You may want to map them too depending on your needs though
                    actions.add_selection:replace(function() end)
                    actions.remove_selection:replace(function() end)
                    actions.toggle_selection:replace(function() end)
                    actions.select_all:replace(function() end)
                    actions.drop_all:replace(function() end)
                    actions.toggle_all:replace(function() end)

                    return true
                end,
            }

            -- Opening the menu
            require("telescope.pickers").new({ prompt_title = "Tree menu" }, default_options):find()
        end

        local function on_attach(bufnr)
            local api = require("nvim-tree.api")

            local function opts(desc)
                return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
            end

            vim.keymap.set("n", "a", api.fs.create, opts("Create"))
            vim.keymap.set("n", "l", api.node.open.edit, opts("Open"))
            vim.keymap.set("n", "L", vsplit_preview, opts("vsplit_preview"))
            vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close Directory"))
            vim.keymap.set("n", "C", api.tree.collapse_all, opts("Collapse"))
            vim.keymap.set("n", "<leader>o", tree_actions_menu, opts("tree actions"))
        end

        require("nvim-tree").setup({
            reload_on_bufenter = true,
            sort_by = "case_sensitive",
            on_attach = on_attach,
            git = {
                ignore = false,
            },
            tab = {
                sync = {
                    open = true,
                },
            },
            renderer = {
                group_empty = true,
            },
            filters = {
                dotfiles = true,
            },
        })
    end,
    keys = {
        {
            "<c-b>",
            function()
                require("nvim-tree.api").tree.toggle()
            end
        },
    }
}
