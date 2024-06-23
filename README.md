# nvim setup (lazy.nvim + kickstart)

1. `git clone git@github.com:Infatoshi/initlua-nvim.git` (ssh)
2. `cp initlua-nvim/init.lua ~/.config/nvim/init.lua`
3. `nvim .` -> let lazy do its thing
4. make sure you have an OPENAI_API_KEY in your bashrc or zshrc so the llm
   integration works (highlight text in visual mode -> press space -> "," to
stream GPT response. space + "g," for anthropic sonnet 3.5 response)
