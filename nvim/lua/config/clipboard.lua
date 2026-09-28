-- Clipboard: system clipboard locally; over SSH, copy via OSC 52 (or tmux) and read back
-- from the local terminal on paste.
if vim.env.SSH_TTY or vim.env.SSH_CONNECTION or vim.env.SSH_CLIENT then
  local ok, osc52 = pcall(require, 'vim.ui.clipboard.osc52')

  if ok then
    local copy_provider = osc52.copy('+')
    local provider_name = 'OSC 52 copy-only'
    local use_tmux_clipboard = false
    local should_try_system_paste = true
    local clipboard_read_retry_after = 0

    if vim.env.TMUX and vim.fn.executable('tmux') == 1 then
      local tmux_version = vim.version.parse(vim.fn.system({ 'tmux', '-V' }))

      if tmux_version and not vim.version.lt(tmux_version, { 3, 2, 0 }) then
        copy_provider = { 'tmux', 'load-buffer', '-w', '-' }
        provider_name = 'tmux copy-only'
        use_tmux_clipboard = true
      end
    end

    local function run_system(cmd, timeout_ms)
      if not vim.system then
        return nil
      end

      local job = vim.system(cmd, { text = true })
      local result = job:wait(timeout_ms)

      if not result then
        pcall(function()
          job:kill(15)
        end)
        return nil
      end

      if result.code ~= 0 then
        return nil
      end

      return result.stdout
    end

    local function now_ms()
      return (vim.uv or vim.loop).now()
    end

    local function read_tmux_clipboard()
      run_system({ 'tmux', 'refresh-client', '-l' }, 100)
      vim.wait(50)
      return run_system({ 'tmux', 'save-buffer', '-' }, 200)
    end

    local function read_osc52_clipboard()
      local contents = nil
      local id = vim.api.nvim_create_autocmd('TermResponse', {
        callback = function(ev)
          local encoded = ev.data.sequence:match('\027%]52;%w?;([A-Za-z0-9+/=]*)')

          if encoded then
            contents = vim.base64.decode(encoded)
            return true
          end
        end,
      })

      vim.api.nvim_ui_send('\027]52;c;?\027\\')

      local ok = vim.wait(250, function()
        return contents ~= nil
      end)

      pcall(vim.api.nvim_del_autocmd, id)

      if not ok then
        return nil
      end

      return contents
    end

    local function read_system_clipboard(force)
      if not force and now_ms() < clipboard_read_retry_after then
        return nil
      end

      local contents = use_tmux_clipboard and read_tmux_clipboard() or nil
      contents = contents or read_osc52_clipboard()

      if contents == nil then
        clipboard_read_retry_after = now_ms() + 5000
      else
        clipboard_read_retry_after = 0
      end

      return contents
    end

    local function system_clipboard_register(force)
      local contents = read_system_clipboard(force)

      if not contents or contents == '' then
        return nil, nil
      end

      local regtype = 'v'

      if contents:sub(-1) == '\n' then
        regtype = 'V'
        contents = contents:sub(1, -2)
      end

      return vim.split(contents, '\n', { plain = true }), regtype
    end

    local function paste_from_system(key, force)
      if force or should_try_system_paste then
        local lines, regtype = system_clipboard_register(force)

        if lines then
          local previous_reg = vim.fn.getreg('"')
          local previous_type = vim.fn.getregtype('"')
          local count = vim.v.count > 0 and tostring(vim.v.count) or ''

          vim.fn.setreg('"', lines, regtype)
          vim.cmd('normal! ' .. count .. key)
          vim.fn.setreg('"', previous_reg, previous_type)
          return
        end
      end

      local count = vim.v.count > 0 and tostring(vim.v.count) or ''
      vim.cmd('normal! ' .. count .. key)
    end

    local function paste_provider()
      local lines = system_clipboard_register(false)
      return lines or {}
    end

    vim.g.clipboard = {
      name = provider_name,
      copy = {
        ['+'] = copy_provider,
        ['*'] = copy_provider,
      },
      paste = {
        ['+'] = paste_provider,
        ['*'] = paste_provider,
      },
    }

    vim.api.nvim_create_autocmd('TextYankPost', {
      group = vim.api.nvim_create_augroup('ssh_clipboard_yank', { clear = true }),
      callback = function()
        if vim.v.event.regname == '' then
          should_try_system_paste = vim.v.event.operator == 'y'

          if vim.v.event.operator == 'y' then
            vim.fn.setreg('+', vim.v.event.regcontents, vim.v.event.regtype)
          end
        end
      end,
    })

    vim.keymap.set('n', 'p', function()
      paste_from_system('p', false)
    end, { desc = 'Paste from system clipboard over SSH' })

    vim.keymap.set('n', 'P', function()
      paste_from_system('P', false)
    end, { desc = 'Paste before from system clipboard over SSH' })

    vim.keymap.set('n', '<leader>p', function()
      paste_from_system('p', true)
    end, { desc = '[P]aste from System Clipboard' })
  end
else
  vim.schedule(function() -- Sync clipboard between OS and Neovim.
    vim.o.clipboard = 'unnamedplus'
  end)
end
