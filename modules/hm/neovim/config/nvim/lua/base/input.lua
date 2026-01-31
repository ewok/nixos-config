local M = {}

-- Configuration
M.config = {
  max_history = 10,
  window = {
    relative = "cursor",
    width = 60,
    height = 1,
    row = -3,
    col = 0,
    style = "minimal",
    border = "rounded",
    zindex = 50,
  },
}

-- History storage (in-memory, per prompt type)
M.history = {}
M.history_index = {}

-- Store original vim.ui.input
local original_input = vim.ui.input

---Add entry to history
---@param prompt string
---@param value string
local function add_to_history(prompt, value)
  if value == "" then
    return
  end

  if not M.history[prompt] then
    M.history[prompt] = {}
  end

  -- Don't add duplicates
  if M.history[prompt][1] == value then
    return
  end

  -- Add to front of history
  table.insert(M.history[prompt], 1, value)

  -- Keep only max_history items
  while #M.history[prompt] > M.config.max_history do
    table.remove(M.history[prompt])
  end
end

---Get previous history entry
---@param prompt string
---@return string|nil
local function get_prev_history(prompt)
  if not M.history[prompt] or #M.history[prompt] == 0 then
    return nil
  end

  local idx = M.history_index[prompt] or 0
  idx = idx + 1
  if idx > #M.history[prompt] then
    idx = #M.history[prompt]
  end
  M.history_index[prompt] = idx

  return M.history[prompt][idx]
end

---Get next history entry
---@param prompt string
---@return string|nil
local function get_next_history(prompt)
  if not M.history[prompt] or #M.history[prompt] == 0 then
    return nil
  end

  local idx = M.history_index[prompt] or 0
  idx = idx - 1
  if idx < 1 then
    M.history_index[prompt] = 0
    return ""
  end
  M.history_index[prompt] = idx

  return M.history[prompt][idx]
end

---Completion function for omnifunc
---@param findstart number
---@param base string
---@return number|table
function M.complete(findstart, base)
  if findstart == 1 then
    -- Return the start position of completion
    local line = vim.api.nvim_get_current_line()
    return #line:gsub("%S+$", "")
  end

  -- Get completion results
  if not M.current_completion then
    return {}
  end

  local ok, results = pcall(vim.fn.getcompletion, base, M.current_completion)
  return ok and results or {}
end

---Main input function
---@param opts table Options table with prompt, default, completion, etc.
---@param on_confirm function Callback function called with the input value
function M.input(opts, on_confirm)
  opts = opts or {}
  local prompt = opts.prompt or "Input"
  local default = opts.default or ""
  local completion = opts.completion

  -- Clean up prompt (remove trailing colons, spaces)
  prompt = vim.trim(prompt):gsub(":$", "")

  -- Store completion type for the complete function
  M.current_completion = completion

  -- Reset history index for this prompt
  M.history_index[prompt] = 0

  -- Save current window and mode
  local parent_win = vim.api.nvim_get_current_win()
  local parent_mode = vim.fn.mode()

  -- Create buffer
  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].buftype = "prompt"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].filetype = "input"

  -- Set up completion if provided
  if completion then
    vim.bo[buf].completefunc = "v:lua.require'base.input'.complete"
    vim.bo[buf].omnifunc = "v:lua.require'base.input'.complete"
  end

  -- Configure window
  local win_config = vim.tbl_extend("force", M.config.window, {
    title = " " .. prompt .. " ",
    title_pos = "center",
  })

  -- Adjust zindex to be above parent window if needed
  local parent_config = vim.api.nvim_win_get_config(parent_win)
  if parent_config.zindex then
    win_config.zindex = parent_config.zindex + 1
  end

  -- Create window
  local win = vim.api.nvim_open_win(buf, true, win_config)
  vim.wo[win].winhighlight = "Normal:Normal,FloatBorder:FloatBorder"

  -- Set up prompt
  vim.fn.prompt_setprompt(buf, "")

  -- Set default text if provided
  if default ~= "" then
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { default })
  end

  -- Flag to track if callback was called
  local callback_called = false

  -- Helper to close and cleanup
  local function close_input(value)
    if callback_called then
      return
    end
    callback_called = true

    -- Add to history if confirmed with value
    if value and value ~= "" then
      add_to_history(prompt, value)
    end

    -- Close window and buffer
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
    if vim.api.nvim_buf_is_valid(buf) then
      vim.api.nvim_buf_delete(buf, { force = true })
    end

    -- Restore parent window and mode
    vim.schedule(function()
      if vim.api.nvim_win_is_valid(parent_win) then
        vim.api.nvim_set_current_win(parent_win)
        if parent_mode == "i" then
          vim.cmd("startinsert")
        end
      end
      -- Call the callback
      on_confirm(value)
    end)
  end

  -- Set prompt callbacks
  vim.fn.prompt_setcallback(buf, function(text)
    close_input(text)
  end)

  vim.fn.prompt_setinterrupt(buf, function()
    close_input(nil)
  end)

  -- Set up keymaps
  local opts_map = { buffer = buf, nowait = true, silent = true }

  -- Escape to cancel
  vim.keymap.set("n", "<Esc>", function()
    close_input(nil)
  end, opts_map)

  vim.keymap.set("i", "<Esc>", function()
    close_input(nil)
  end, opts_map)

  -- Enter to confirm
  vim.keymap.set("i", "<CR>", function()
    local line = vim.api.nvim_get_current_line()
    close_input(line)
  end, opts_map)

  -- Up arrow for previous history
  vim.keymap.set("i", "<Up>", function()
    local prev = get_prev_history(prompt)
    if prev then
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, { prev })
      vim.api.nvim_win_set_cursor(win, { 1, #prev })
    end
  end, opts_map)

  vim.keymap.set("n", "<Up>", function()
    local prev = get_prev_history(prompt)
    if prev then
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, { prev })
      vim.api.nvim_win_set_cursor(win, { 1, #prev })
    end
  end, opts_map)

  -- Down arrow for next history
  vim.keymap.set("i", "<Down>", function()
    local next = get_next_history(prompt)
    if next then
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, { next })
      vim.api.nvim_win_set_cursor(win, { 1, #next })
    end
  end, opts_map)

  vim.keymap.set("n", "<Down>", function()
    local next = get_next_history(prompt)
    if next then
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, { next })
      vim.api.nvim_win_set_cursor(win, { 1, #next })
    end
  end, opts_map)

  -- Tab for completion (if available)
  if completion then
    vim.keymap.set("i", "<Tab>", function()
      if vim.fn.pumvisible() == 1 then
        return "<C-n>"
      else
        return "<C-x><C-u>"
      end
    end, { buffer = buf, expr = true, silent = true })

    vim.keymap.set("i", "<S-Tab>", "<C-p>", { buffer = buf, silent = true })
  end

  -- Start insert mode
  vim.cmd("startinsert!")
end

---Setup function to replace vim.ui.input
---@param config? table Optional configuration overrides
function M.setup(config)
  -- Merge config
  if config then
    M.config = vim.tbl_deep_extend("force", M.config, config)
  end

  -- Replace vim.ui.input
  vim.ui.input = M.input
end

---Restore original vim.ui.input
function M.disable()
  vim.ui.input = original_input
end

function M.health()
    if vim.ui.input == M.input then
      vim.notify("`vim.ui.input` is set to `Enhanced`")
    else
      vim.notify("`vim.ui.input` is NOT set to `Enhanced`")
    end
end

return M
