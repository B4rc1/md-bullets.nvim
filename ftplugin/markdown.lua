local citation_regex = vim.regex([[^\s*\(> \)\+]])


local function handle_lists (line, row, citation_start, citation_end)
  -- NOTE: - is a special character in lua string matching so it needs to be escaped
  local citation_markers
  local is_citation = false

  if citation_end then
    is_citation = true
    citation_markers = line:sub(citation_start, citation_end)
    local after_citation = line:sub(citation_end+1, -1)
    line = after_citation
  end

  if line:match("^%s*%-%s+.+") then
    -- continue "-" list
    local whitespace = line:match("^(%s*)%-%s+.+")

    local output = whitespace .. "- "
    if is_citation then
      output = citation_markers .. output
    end
    vim.api.nvim_set_current_line(output)
  elseif line:match("^%s-%-%s$") and not is_citation then
    -- end "-" list
    local whitespace = line:match("^(%s*)%-.*")

    vim.api.nvim_buf_set_lines(0, row - 2, row, true, { whitespace .. "  " })
    vim.api.nvim_win_set_cursor(0, {row - 1, 0})
  end
end

local auto_list = function ()
  local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
  local preceding_line = vim.api.nvim_buf_get_lines(0, row - 2, row - 1, true)

  if #preceding_line ~= 1 then
    return
  end


  -- Citation markers like:
  -- > some text
  -- > > aaa

  local citation_start, citation_end = citation_regex:match_str(preceding_line[1])

  if citation_start and citation_end then
    local citation_markers = preceding_line[1]:sub(citation_start, citation_end)
    local after_citation = preceding_line[1]:sub(citation_end, -1)

    if not after_citation:match("^%s*$") then
      -- continue citaion
      vim.api.nvim_set_current_line(citation_markers)
    else
      -- if the citation is empty, decrease its level by one
      local pre_preceeding_line = vim.api.nvim_buf_get_lines(0, row - 3, row - 2, true)

      pre_preceeding_line = pre_preceeding_line[1] or ""

      local _, preceeding_citation_end = citation_regex:match_str(pre_preceeding_line)

      if preceeding_citation_end and pre_preceeding_line:sub(preceeding_citation_end, -1):match("^%s*$") then
        -- prev cition was also empty, delete one level + one line
        citation_markers = citation_markers:sub(1, -3)

        vim.api.nvim_buf_set_lines(0, row - 3, row, true, { citation_markers })
        vim.api.nvim_win_set_cursor(0, {row - 2, 0})
      else
        -- continue citation
        vim.api.nvim_set_current_line(citation_markers)
      end
    end
  end

  handle_lists(preceding_line[1], row, citation_start, citation_end)
end

vim.keymap.set("i", "<CR>", function()

  -- *e*scape
  local e = vim.api.nvim_replace_termcodes

  vim.api.nvim_feedkeys(e("i<CR>", true, true, true), "nx", false)

  auto_list()

  vim.api.nvim_feedkeys(e("<ESC>A", true, true, true), "n", true)

end)
