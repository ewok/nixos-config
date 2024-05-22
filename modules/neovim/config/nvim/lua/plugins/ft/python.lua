return {
    "linux-cultist/venv-selector.nvim",
    branch = "regexp",
    config = function()
        require("venv-selector").setup()
    end,
    cmd = { "VenvSelectCached", "VenvSelect" },
}