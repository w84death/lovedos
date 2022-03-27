local t = 0
local sec_time = 200

function drawIntro()
  if t<sec_time then
    love.graphics.draw(gif_p1x,half_w-60,half_h-60)
    --drawCenter("P1X Presents")
  elseif t<sec_time*2 then
    love.graphics.draw(gif_kkj,0,0)
    drawCenter("a Krzysztof Krystian Jankowski game")
  else
    drawCenter(">>> "..game_name.." <<<")
    drawFooter("Press spacebar to continue")
  end
end

function tickIntro(dt)
  t=t+1
end
