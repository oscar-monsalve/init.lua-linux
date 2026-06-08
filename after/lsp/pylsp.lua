local function find_venv(root_dir)
  local venv = root_dir .. "/.venv"
  if vim.fn.isdirectory(venv) == 1 then
    return venv
  end

  return nil
end

return {
  before_init = function(_, config)
    local root_dir = config.root_dir
    if not root_dir then
      return
    end

    local venv = find_venv(root_dir)
    if not venv then
      return
    end

    config.settings = vim.tbl_deep_extend("force", config.settings or {}, {
      pylsp = {
        plugins = {
          jedi = {
            environment = venv,
          },
        },
      },
    })
  end,

  settings = {
    pylsp = {
      plugins = {
        jedi_completion = {
          enabled = true,
          fuzzy = true,
          include_params = true,
        },
        jedi_hover = {
          enabled = true,
        },
        jedi_signature_help = {
          enabled = true,
        },
      },
    },
  },
}
