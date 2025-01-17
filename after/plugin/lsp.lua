local lsp = require('lsp-zero')
local cmp = require('cmp')

lsp.on_attach(function(_, bufnr)
  local opts =  { buffer = bufnr, remap = false };

  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
  vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

local cmp_select = { behaviour = cmp.SelectBehavior.Select }

cmp.setup({
    sources = {
        { name = 'nvim_lsp' }
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<Tab>'] = nil,
        ['<S-Tab>'] = nil
    }),
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
})

lsp.set_sign_icons({
  error = 'E',
  warn = 'W',
  hint = 'H',
  info = 'I'
})

require('mason').setup({})

require('mason-lspconfig').setup({
  ensure_installed = {
      'tsserver',
      'rust_analyzer',
      'lua_ls'
  },
  handlers = {
    function(server_name)
      require('lspconfig')[server_name].setup({})
    end,
  },
})

require'lspconfig'.lua_ls.setup {
  settings = {
    Lua = {
      diagnostics = {
        globals = {'vim'}
      }
    }
  }
}

