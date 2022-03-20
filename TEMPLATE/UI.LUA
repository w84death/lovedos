local char_wide = 5

function drawCenter(message)
  local mid = string.len(message)*0.5
  love.graphics.print(
      message,
      half_w-mid*char_wide,
      half_h)	  
end

function drawHeader(message)
  love.graphics.print(
    message,
    4, 4)
  love.graphics.line(
    0,18, w,18)  
end

function drawFooter(message)
  love.graphics.line(
    0,h-14, w, h-14)
  love.graphics.print(
    message,
    4, h-10)
end