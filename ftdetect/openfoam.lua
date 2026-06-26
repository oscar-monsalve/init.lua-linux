local openfoam_patterns = {
    "*/system/*",
    "*/constant/*",
    "*/0/*",
    "*/[0-9]*/*",
}

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = openfoam_patterns,
    callback = function(args)
        local file_dir = vim.fs.dirname(args.file)

        local control_dict = vim.fs.find("system/controlDict", {
            path = file_dir,
            upward = true,
            type = "file",
        })[1]

        if control_dict then
            vim.bo[args.buf].filetype = "foam"
        end
    end,
})
