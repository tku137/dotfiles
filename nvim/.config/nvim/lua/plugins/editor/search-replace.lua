return {
  {
    "MagicDuck/grug-far.nvim",
    -- Note (lazy loading): grug-far.lua defers all it's requires so it's lazy by default
    -- additional lazy config to defer loading is not really needed...
    cmd = { "GrugFar", "GrugFarWithin" },
    opts = { headerMaxWidth = 80 },
    keys = {
      -- general launcher
      {
        "<leader>srg",
        function()
          require("grug-far").open({ transient = true })
        end,
        desc = "GrugFar",
      },

      -- current buffer only
      {
        "<leader>srb",
        function()
          require("grug-far").open({
            transient = true,
            prefills = { paths = vim.fn.expand("%:p") },
          })
        end,
        desc = "Current buffer only",
      },

      -- cursor word OR visual selection
      {
        "<leader>srw",
        function()
          local grug = require("grug-far")
          local mode = vim.fn.mode()
          local search
          -- grab text differently for v-mode vs n-mode
          if mode:match("[vV]") then
            -- yank visual selection without clobbering default register
            local prev = vim.fn.getreg('"')
            vim.cmd('normal! "vy')
            search = vim.fn.getreg("v"):gsub("\n", "\\n")
            vim.fn.setreg('"', prev)
          else
            search = vim.fn.expand("<cword>")
          end
          grug.open({
            transient = true,
            prefills = { search = search, filesFilter = "*." .. vim.fn.expand("%:e") },
          })
        end,
        mode = { "n", "v" },
        desc = "Word or Selection",
      },

      -- visual-range restricted replace
      {
        "<leader>srv",
        "<cmd>'<,'>GrugFarWithin<CR>",
        mode = "v",
        desc = "Within visual range",
      },
    },
  },
}
