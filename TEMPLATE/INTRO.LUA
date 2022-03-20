local t = 0
local sec_time = 100

function drawIntro()
  if t<sec_time then
    drawCenter("P1X Presents")
  elseif t<sec_time*2 then
    drawCenter("a Krzysztof Krystian Jankowski game")
  else
    drawCenter(">>> "..game_name.." <<<")
    drawFooter("Press spacebar to continue")
  end
end

function tickIntro(dt)
  t=t+1
end