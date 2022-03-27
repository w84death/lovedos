local fps_now = 30
local fps = 30
local smooth = 0.9
local max_fps = 500

function tickFPS(dt)
  fps_now = 1/dt
  fps = fps * smooth + fps_now * (1-smooth)
  if fps>max_fps then fps = max_fps end
end

                                      
function drawFPS()
  local msg = "FPS:"..math.floor(fps)
  if show_fps then
    love.graphics.print(
      msg,
      w-font:getWidth(msg)-margin,margin)
  end
end
