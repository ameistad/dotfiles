vim.o.autoread = true
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true
vim.wo.number = true
vim.wo.relativenumber = true -- set relative line numbers
vim.wo.cursorline = true
vim.opt.cursorlineopt = 'number' -- highliht only the number
vim.opt.signcolumn = 'yes' -- Always show the sign column to prevent text shift
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
-- vim.o.wrap = false -- displays lines as one long line
vim.o.linebreak = true -- companion to wrap, don't split words
vim.o.undofile = true -- Save undo history
vim.o.mouse = 'a' -- enable mouse mode, for highlights
-- vim.o.mouse = '' -- disable mouse
vim.o.autoindent = true -- copy indent from current line when starting a new one
vim.o.ignorecase = true -- case-insensitive searching, unless \C or capital in search
vim.o.smartcase = true -- smart case
vim.opt.showmode = false -- disable showing mode
vim.opt.splitright = true -- split right by default
vim.opt.undofile = false -- do not save undo history
vim.opt.shortmess:append('I') -- hide the opening screen

-- Start typing immediately when launched without a file or directory.
vim.api.nvim_create_autocmd('VimEnter', {
	group = vim.api.nvim_create_augroup('startup_insert', { clear = true }),
	once = true,
	callback = function()
		if vim.fn.argc() == 0 and vim.bo.buftype == '' and vim.bo.modifiable then
			vim.cmd.startinsert()
		end
	end,
})

-- Force Normal mode when entering a window or buffer
vim.api.nvim_create_autocmd({ 'BufEnter', 'WinEnter' }, {
	callback = function()
		if vim.fn.mode() ~= 'n' then
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', true)
		end
	end,
})

-- no auto continue comments on new line
vim.api.nvim_create_autocmd('FileType', {
	group = vim.api.nvim_create_augroup('no_auto_comment', {}),
	callback = function()
		vim.opt_local.formatoptions:remove({ 'c', 'r', 'o' })
	end,
})

-- auto resize splits when the terminal's window is resized
vim.api.nvim_create_autocmd('VimResized', {
	command = 'wincmd =',
})

-- open help in vertical split
vim.api.nvim_create_autocmd('FileType', {
	pattern = 'help',
	command = 'wincmd L',
})

-- Setup lazy.nvim
require('lazy-bootstrap')
require('lazy').setup({
	spec = {
		-- import your plugins
		{ import = 'plugins' },
	},
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	install = { colorscheme = { 'habamax' } },
	-- automatically check for plugin updates
	checker = { enabled = false },
	-- check for changes
	change_detection = { enabled = false },
})

-- Keymaps
require('keymaps')
