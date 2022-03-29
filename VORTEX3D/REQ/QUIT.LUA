local t = 0
local sec_timer = 1

function drawQuit()
  if t<sec_timer then
    love.graphics.draw(gif_bg_dark,0,0)
    if t<sec_timer*0.33 then
      drawCenter(game_name)
    end
  else
    love.event.quit()
  end
end

function tickQuit(dt)
  t=t+dt
end
