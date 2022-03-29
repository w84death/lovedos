local fps_now = 30
local fps = 30
local smooth = 0.9
local max_fps = 500
local fps_x = w-64
local fps_y = margin_y

function tickFPS(dt)
  fps_now = 1/dt
  fps = fps * smooth + fps_now * (1-smooth)
  if fps>max_fps then fps = max_fps end
end

                                      
function drawFPS()             
  if show_fps then
    love.graphics.setColor(239,236,241)
    love.graphics.print(
      "FPS:\n"..math.floor(fps),
      fps_x,fps_y)
  end
end
