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
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build= ":TSUpdate",
  },
}
