return {
    {
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)

        build = "make install_jsregexp",

        dependencies = { "rafamadriz/friendly-snippets" },


        config = function()
            local ls = require("luasnip")
            local s = ls.snippet
            local fmt = require("luasnip.extras.fmt").fmt

            --- TODO: What is expand?
            vim.keymap.set({"i"}, "<C-s>e", function() ls.expand() end, {silent = true})
            vim.keymap.set({"i", "s"}, "<C-s>;", function() ls.jump(1) end, {silent = true})
            vim.keymap.set({"i", "s"}, "<C-s>,", function() ls.jump(-1) end, {silent = true})

            ls.add_snippets(nil, {
                tex = {
                    s(
                        "init", -- type "init" to trigger the snippet
                        fmt(
                            [[
                            \documentclass[12pt,spanish,a4paper]{{article}}
                            \pagenumbering{{arabic}}
                            \usepackage[margin=1.5cm,includeheadfoot]{{geometry}}
                            \usepackage[spanish,mexico]{{babel}}
                            \usepackage{{xcolor}}
                            \usepackage[utf8]{{inputenc}}
                            \usepackage{{times}}
                            \usepackage{{graphicx}}
                            \usepackage{{multirow}}
                            \usepackage{{ragged2e}}
                            \usepackage{{amsmath}}
                            \usepackage{{indentfirst}}
                            \usepackage{{subcaption}}
                            \usepackage{{steinmetz}}
                            \usepackage{{tabularx}}
                            \usepackage[bookmarks=true]{{hyperref}}
                            \usepackage[open]{{bookmark}}
                            \usepackage[noabbrev,spanish]{{cleveref}}
                            \hypersetup{{
                              colorlinks = true, % Colours links instead of ugly boxes
                              urlcolor   = blue, % Colour for external hyperlinks
                              linkcolor  = blue, % Colour of internal links
                              citecolor  = blue  % Colour of citations
                            }}

                            % Change nested enumarate to arabic numbers instead of letters
                            \renewcommand{{\labelenumii}}{{\theenumii}}
                            \renewcommand{{\theenumii}}{{\theenumi.\arabic{{enumii}}.}}

                            \usepackage{{lastpage}}
                            \usepackage{{fancyhdr}}
                            \pagestyle{{fancy}}
                            \fancyhf{{}}
                            % \lhead{{\includegraphics[width=6.5cm]{{images/ITM_LOGO AZUL 80.pdf}}}}
                            % \rhead{{\vspace{{3ex}}Asignatura: Circuitos Eléctricos AC\\Docente: \textbf{{Ing. $-$ M.Sc. Oscar Darío Monsalve Cifuentes}} }}
                            % %\setlength\headheight{{pt}}
                            % \fancypagestyle{{plain}}{{
                            %     \fancyhf{{}}
                            %     \lhead{{\includegraphics[width=6.5cm]{{images/ITM_LOGO AZUL 80.pdf}}}}
                            % }}

                            \fancyfoot[R]{{Página \thepage \hspace{{1pt}} de \pageref{{LastPage}}}}

                            \begin{{document}}

                            \end{{document}}
                        ]],
                            {}
                        )
                    ),
                },
            })


        end,
    }
}
