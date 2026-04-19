return {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    ---@module "ibl"
    ---@type ibl.config
    opts = {
        indent = {
            char = "▏",
            highlight = "IblIndent",
        },
        scope = { enabled = false },
    },
    config = function(_, opts)
        local hooks = require("ibl.hooks")
        -- create the highlight groups in the highlight setup hook, so they are reset
        -- every time the colorscheme changes
        hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
            -- Replace "#E5C07B" with your preferred contrast color
            vim.api.nvim_set_hl(0, "IblIndent", { fg = "#636772" })
        end)

        require("ibl").setup(opts)
    end,
}
