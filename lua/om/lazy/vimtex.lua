-- Local leader
vim.g.maplocalleader = ","

return {
    "lervag/vimtex",
    lazy = false,  -- we don't want to lazy load VimTex

    init = function()
        -- PDF viewer
        vim.g.vimtex_view_method = "general"
        vim.g.vimtex_view_general_viewer = "okular"
        vim.g.vimtex_view_general_options = "--unique file:@pdf\\#src:@line@tex"
        vim.g.vimtex_view_use_temp_files = 0
        vim.g.vimtex_view_enabled = 1

        -- Deactivate quickfix window
        vim.g["vimtex_quickfix_mode"] = 0

        -- Auto Indent
        vim.g["vimtex_indent_enabled"] = 1

        -- Syntax highlighting
        vim.g["vimtex_syntax_enabled"] = 1

        -- Ignore things
        vim.g["vimtex_log_ignore"] = ({
            "Underfull",
            "Overfull",
            "specifier changed to",
            "Token not allowed in a PDF string",
        })

        -- Compiler
        vim.g.vimtex_compiler_method = "latexmk"
        vim.g.vimtex_compiler_latexmk = {
            aux_dir = "/home/om/.texfiles",
            -- out_dir = "/home/om/.texfiles",
        }

    end
}
