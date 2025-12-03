return {
    "linux-cultist/venv-selector.nvim",
    branch = "regexp",
    cmd = { "VenvSelectCached", "VenvSelect" },
    config = function()
        require("venv-selector").setup()
    end,
}
