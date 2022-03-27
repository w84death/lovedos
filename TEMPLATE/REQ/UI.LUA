function drawCenter(message)
  local mid = font:getWidth(message)*0.5
  love.graphics.print(
      message,
      half_w-mid,
      half_h)	  
end

function drawHeader(message)
  love.graphics.print(
    message,
    margin, margin)
  love.graphics.line(
    0,margin+padding, w,margin+padding)  
end

function drawFooter(message)
  love.graphics.line(
    0,h-padding, w, h-padding)
  love.graphics.print(
    message,
    margin, h-char_height)
end
