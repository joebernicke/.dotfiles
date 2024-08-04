 vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv",vim.cmd.Ex)

vim.keymap.set("n", "<leader>pv", ":Ex<CR>")
vim.keymap.set("n", "<leader>u", ":UndotreeShow<CR>")

-- Move lines up and down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '>-2<CR>gv=gv")


-- append following line to current 
vim.keymap.set("n", "J", "mzJ`z")

--Navigate up/down by half page
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")

-- keep search terms in the middle
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Copy to clipboard
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+Y")
vim.keymap.set("n", "<leader>Y", "\"+Y")


-- Don't click capital Q
vim.keymap.set("n","Q", "<nop>")

-- Change project (not working I may need tmux)
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
 
-- replace all occurences of current selected word
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])


vim.keymap.set("i", "oj", "<esc>")
vim.keymap.set("n", "<leader>q", ":q!<CR>")
vim.keymap.set("n", "<leader>w", ":w<CR>")
vim.keymap.set("t", "<Esc>", "<C-\\><C-n><C-w><C-w>")
vim.keymap.set("n", "\\\\", "<C-w><C-w>")
