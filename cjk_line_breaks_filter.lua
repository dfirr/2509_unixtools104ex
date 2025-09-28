-- Ignore soft break adjacent to Chinese characters
-- Reference: https://taoshu.in/unix/markdown-soft-break.html

function is_ascii(char)
  if char == nil then return false end
  local ascii_code = string.byte(char)
  -- Check whether a character is an ASCII character
  return ascii_code >= 0 and ascii_code <= 127
end

return {
  {
    Para = function(para)
      local cs = para.content
      for k, v in ipairs(cs) do
        if v.t == 'SoftBreak' and cs[k - 1] and cs[k + 1] then
          local p = cs[k - 1].text
          local n = cs[k + 1].text
          -- Remove SoftBreak if at least one adjacent character is non-ASCII
          if p and n and (not is_ascii(p:sub(-1)) or not is_ascii(n:sub(1, 1))) then
            para.content[k] = pandoc.Str("")
          end
        end
      end
      return para
    end,
  }
}
