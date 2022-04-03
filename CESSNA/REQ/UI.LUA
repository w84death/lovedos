function drawCenter(message, y_offset)
  local mid = font:getWidth(message)*0.5
  if y_offset == nil then y_offset = 0 end
  love.graphics.print(
      message,
      half_w-mid,
      half_h+y_offset)	  
end

function drawHeader(message)
  love.graphics.setColor(23,34,38)
  love.graphics.print(
    message,
    margin_x, margin_y)
  love.graphics.line(
    margin_x,margin_y+padding, 
    w-margin_x,margin_y+padding)  
end

function drawFooter(message)
  local mid = font:getWidth(message)*0.5
  love.graphics.setColor(23,34,38)
  love.graphics.line(
    margin_x,h-margin_y-padding, 
    w-margin_x, h-margin_y-padding)
  love.graphics.print(
    message,
    half_w-mid, h-margin_y-char_height)
end
