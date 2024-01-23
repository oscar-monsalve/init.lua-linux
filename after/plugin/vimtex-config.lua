-- General viewer
-- vim.g["vimtex_view_method"] = "zathura"

-- PDF viewer
vim.g["vimtex_view_general_viewer"] = "okular"
vim.g["vimtex_view_general_options"] = "--unique file:@pdf\\#src:@line@tex"

-- Deactivate quickfix window
vim.g["vimtex_quickfix_mode"] = 0

-- Auto Indent
vim.g["vimtex_indent_enabled"] = 0

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

-- Local leader
vim.g.maplocalleader = ","
