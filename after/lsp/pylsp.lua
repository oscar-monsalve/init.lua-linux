local function find_venv_python(root_dir)
  if not root_dir then
    return nil
  end

  local python = root_dir .. "/.venv/bin/python"

  if vim.fn.executable(python) == 1 then
    return python
  end

  return nil
end

local function base_settings()
  return {
    pylsp = {
      configurationSources = { "flake8" },

      plugins = {
        -- Disable these to avoid duplicated diagnostics, because Flake8
        -- already includes pycodestyle, pyflakes, and mccabe checks.
        pycodestyle = {
          enabled = false,
        },

        pyflakes = {
          enabled = false,
        },

        mccabe = {
          enabled = false,
        },

        flake8 = {
          enabled = true,

          -- Previous pycodestyle ignores:
          -- E302: expected 2 blank lines
          -- E241: multiple spaces after ','
          -- E226: missing whitespace around arithmetic operator
          --
          -- Manim star-import ignores:
          -- F403: 'from manim import *' used; unable to detect undefined names
          -- F405: name may be undefined, or defined from star imports
          extendIgnore = {
            "E302",
            "E241",
            "E226",
            "F403",
            "F405",
          },

          maxLineLength = 500,
        },

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

        jedi_definition = {
          enabled = true,
        },

        jedi_references = {
          enabled = true,
        },
      },
    },
  }
end

local function with_project_venv(settings, root_dir)
  local venv_python = find_venv_python(root_dir)

  if not venv_python then
    return settings
  end

  return vim.tbl_deep_extend("force", settings, {
    pylsp = {
      plugins = {
        jedi = {
          environment = venv_python,
        },
      },
    },
  })
end

return {
  settings = base_settings(),

  on_init = function(client)
    local settings = with_project_venv(base_settings(), client.config.root_dir)

    client.config.settings = settings

    -- Send the dynamically resolved settings to pylsp immediately.
    -- Use the modern Neovim method-call form, not deprecated client.notify().
    client:notify("workspace/didChangeConfiguration", {
      settings = settings,
    })
  end,
}
