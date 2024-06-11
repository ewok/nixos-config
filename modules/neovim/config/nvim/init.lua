-- pick your plugin manager

local pack = "lazy"

local function bootstrap(url, ref)
    local name = url:gsub(".*/", "")
    local path

    if pack == "lazy" then
        path = vim.fn.stdpath("data") .. "/lazy/" .. name
        vim.opt.rtp:prepend(path)
    else
        path = vim.fn.stdpath("data") .. "/site/pack/" .. pack .. "/start/" .. name
    end

    if vim.fn.isdirectory(path) == 0 then
        print(name .. ": installing in data dir...")

        vim.fn.system({ "git", "clone", url, path })
        if ref then
            vim.fn.system({ "git", "-C", path, "checkout", ref })
        end

        vim.cmd("redraw")
        print(name .. ": finished installing")

        _G.update = true
    end

    local ok, tang = pcall(require, "tangerine")
    if ok then
        tang.setup({
            keymaps = {
                eval_buffer = "<Nop>",
                peek_buffer = "<Nop>",
                goto_output = "<Nop>",
                float = {
                    kill = "q",
                },
            },
        })
        if _G.update == true then
            vim.cmd([[
                FnlClean
                FnlCompile!
                q]])
        end
    end
end

-- bootstrap("https://github.com/udayvir-singh/tangerine.nvim", "v2.8")
bootstrap("https://github.com/udayvir-singh/tangerine.nvim")
