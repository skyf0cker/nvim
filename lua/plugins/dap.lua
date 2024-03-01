return {
    "mfussenegger/nvim-dap",
    lazy = true,
    config = function()
        local dap, dapui = require("dap"), require("dapui")
        dap.listeners.before.attach.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function()
            dapui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
            dapui.close()
        end
    end,
    keys = {
        {
            "<space>b",
            function()
                require("dap").toggle_breakpoint()
            end,
            desc = "[D]ebug [b]reakpoint",
        },
        {
            "<space>c",
            function()
                require("dap").continue()
            end,
            desc = "[D]ebug [C]ontinue",
        },
        {
            "<space>n",
            function()
                require("dap").step_over()
            end,
            desc = "[D]ebug [N]ext",
        },
        {
            "<space>s",
            function()
                require("dap").step_into()
            end,
            desc = "[D]ebug [S]tep into",
        },
        {
            "<space>dr",
            function()
                require("dap").restart()
            end,
            desc = "[D]ebug [r]estart",
        },
        {
            "<space>dt",
            function()
                require("dap").terminate()
            end,
            desc = "[D]ebug [t]erminate",
        },
    },
}
