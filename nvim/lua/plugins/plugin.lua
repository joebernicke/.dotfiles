return {
  -- the colorscheme should be available when starting Neovim
  {
    "rose-pine/neovim",
    name= "rose-pine",
    config = function()
      -- load the colorscheme here
      vim.cmd([[colorscheme rose-pine]])
    end,
  },
  {
    "vhyrro/luarocks.nvim",
    priority = 1000, 
    config = true,
  },
  {
    "nvim-lua/plenary.nvim",
    name= "plenary",
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies= "plenary",
    config = function()
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
        vim.keymap.set('n', '<leader>ps', function()
	        builtin.grep_string({ search = vim.fn.input("Grep > ") });
        end)
    end
  },
  {
        "nvim-treesitter/nvim-treesitter",
        build= ":TSUpdate",
        config = function()
            ensure_installed = { "rust","python","c", "lua", "vim", "vimdoc", "query" }
            sync_install = false
            auto_install = true
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            }
        end
  },
  {
      "theprimeagen/harpoon",
      config = function()
            local mark = require("harpoon.mark")
            local ui = require("harpoon.ui")
            vim.keymap.set("n", "<leader>a", mark.add_file)
            vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)
            vim.keymap.set("n", "<C-h>", function() ui.nav_file(1) end)
            vim.keymap.set("n", "<C-j>", function() ui.nav_file(2) end)
            vim.keymap.set("n", "<C-k>", function() ui.nav_file(3) end)
            vim.keymap.set("n", "<C-l>", function() ui.nav_file(4) end)
        end
    },
  {
      "mbbill/undotree",
      config = function()
          vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
      end
    },
  {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/nvim-cmp",
    config = function()
        local cmp = require('cmp')
local cmp_lsp = require("cmp_nvim_lsp")




require('mason').setup({})
require('mason-lspconfig').setup({
	-- Replace the language servers listed here 
	-- with the ones you want to install
	ensure_installed = {'pylsp','tsserver', 'rust_analyzer'},
	handlers = {
		function(server_name)
			require('lspconfig')[server_name].setup({})
		end,
	},
})


local cmp_select = { behavior = cmp.SelectBehavior.Select }
cmp.setup({
	mapping = cmp.mapping.preset.insert({
		['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
		['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
		['<C-y>'] = cmp.mapping.confirm({ select = true }),
		["<C-Space>"] = cmp.mapping.complete(),
	}),
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
	}, {
		{ name = 'buffer' },
	})
})
end
    },
    {'Vigemus/iron.nvim'},
   {'mtikekar/nvim-send-to-term'}
}
