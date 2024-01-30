return {
    "terraformls",
    root_dir = function(fname)
        return require("lspconfig").util.root_pattern(".terraform")(fname) or vim.fn.getcwd()
    end,
}
