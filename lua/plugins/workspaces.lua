local function workspace_hook(workspace, cb)
    return function(actucl_workspace, path)
        if not (actucl_workspace == workspace) then
            return
        end

        local success, result = pcall(cb, workspace, path)
        if not success then
            vim.notify(result, vim.log.levels.ERROR)
        end
    end
end

return {
    "natecraddock/workspaces.nvim",
    lazy = true,
    config = function()
        require("workspaces").setup({
            hooks = {
                open = {
                    workspace_hook("appstack", function()
                        require("telescope.builtin").find_files()
                    end),
                },
            },
        })
    end,
    cmd = { "WorkspacesAdd", "WorkspacesList" },
}
