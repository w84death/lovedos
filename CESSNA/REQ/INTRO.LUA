local t = 0
local sec_time = 2

function drawIntro()
  if t<sec_time then
    love.graphics.draw(gif_p1x,half_w-60,half_h-60)
    drawCenter("P1X DOS Division Presents", 64)
  elseif t<sec_time*2 then
    love.graphics.draw(gif_kkj,half_w-80,0)
    --love.graphics.setColor(0,0,0)
    drawCenter("a Krzysztof Krystian Jankowski game", 64)
  elseif t<sec_time*2.2 then
    love.graphics.draw(gif_bg_dark,0,0)
  elseif t<sec_time*2.5 then
    love.graphics.draw(gif_bg_light,0,0)
  elseif t<sec_time*2.6 then
    love.graphics.draw(gif_bg_dark,0,0)
  else 
    love.graphics.draw(gif_bg_light,0,0)
    love.graphics.setColor(0,0,0)
    love.graphics.draw(gif_cover,half_w-80,half_h-80)
    drawFooter("Press spacebar to continue")
  end
end

function tickIntro(dt)
  t=t+dt
end
