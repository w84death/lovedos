local size = 160
local min_x, min_y = margin_x, margin_y
local max_x, max_y = min_x+size, min_y+size
local heightmap = love.graphics.newImage('gfx/map_h.gif')
local colormap = love.graphics.newImage('gfx/map_c.gif')

local map_zoom_scale = 1.0
local map_z_scale = 32

local x = 256
local y = 256
local z = 250 
local horizon = 20
local phi = -1
local rotate_speed = 0.75
local move_speed = 30
local mx_speed = 0.15
local my_speed = 8
local deadzone = 32
local camera_height = 25

-- QUALITY SETTINGS
local max_lod = 0.8
local min_lod = 0.15
local lod = 0.5
local max_planes = 256
local first_step = 12
local min_step = 2
local vstep = 4
local fps = 15

local t = 0

function prepareGame()
end

function drawGame()
  drawHorizon()
  drawVertexSpace()
  
  if game_mode == game_demo then
    drawHeader("Demo mode, ESC to go back")        
  else
    drawHeader("Location: Earth")
  end
  --love.graphics.draw(gif_cabin,0,0)
end

function tickGame(dt)
  sinphi = math.sin(phi)
  cosphi = math.cos(phi)
  t=t+dt
  if game_mode == game_demo then
    phi = -math.sin(0.1*t)*2
    horizon = 20 +math.sin(0.5*t)*20
    z = 250 + (50+math.sin(0.5*t)*50)
    x = x - sinphi * move_speed * dt
    y = y - cosphi * move_speed * dt

    return
  end

  if love.keyboard.isDown("a") then
    phi = phi + rotate_speed*dt
  end
  if love.keyboard.isDown("d") then
    phi = phi - rotate_speed*dt
  end    
  
    
  if love.keyboard.isDown("s") then
    new_x =x + sinphi * move_speed * dt
    new_y =  y + cosphi * move_speed * dt
    x = new_x
    y = new_y
  end

  if love.keyboard.isDown("w") or love.mouse.isDown(1) or is_flying then 
    new_x = x - sinphi * move_speed * dt
    new_y =  y - cosphi * move_speed * dt
    x = new_x
    y = new_y
  end

  if love.keyboard.isDown("q") or (horizon < 20 and is_flying) then
    new_z = z - move_speed*dt
    z = new_z
  end

  if love.keyboard.isDown("e") or (horizon > 60 and is_flying) then
    new_z = z + move_speed*dt
    z = new_z        
  end
end

function drawHorizon()                                              
  love.graphics.setColor(208,211,233)
  love.graphics.rectangle("fill",0,0,w,half_h)
end

function drawVertexSpace()
  p = max_planes
  step = first_step
  while p > 1 do
    pleft_x  = (-cosphi*p - sinphi*p)+x
    pleft_y  = ( sinphi*p - cosphi*p)+y
    pright_x = ( cosphi*p - sinphi*p)+x
    pright_y = (-sinphi*p - cosphi*p)+y

    dx = (pright_x - pleft_x) / w
    dy = (pright_y - pleft_y) / w
    
    step_x = 1 + math.ceil(vstep*(p*0.005))
    if step_x < min_step then step_x = min_step end

    for screen_x = 0, w, step_x do
      getx=pleft_x*map_zoom_scale%512
      gety=pleft_y*map_zoom_scale%512
      hmap = heightmap:getPixel(getx, gety)
      r, g, b = colormap:getPixel(getx, gety)
      screen_y = (z - hmap) / p * map_z_scale + horizon
      if p > max_planes-16 then
        love.graphics.setColor(201,191,221)       
      elseif p > max_planes-32 then
        love.graphics.setColor(188,183,199)   
      else
        love.graphics.setColor(r, g, b)
      end
      love.graphics.rectangle("fill",
        screen_x, screen_y,
        step_x, quater_h+max_planes-p)
      pleft_x = pleft_x+dx*step_x
      pleft_y = pleft_y+dy*step_x
    end
    p = p - step
    if (step < min_step) then step = min_step else step = step - lod end
  end
end

function drawGPS()
  getx=x*map_zoom_scale%512
  gety=y*map_zoom_scale%512
  xx = math.floor(getx)
  yy = math.floor(gety)
  zz = math.floor(z)
  love.graphics.print("GPS // "..xx.."x /"..yy.."y /"..zz.."z",8,8)
end

function drawGameOver(win)
  love.graphics.draw(gif_bg_light,0,0)
  drawHeader("Game Over!")
  if win then
    drawCenter("You win :)")  
  else                     
    drawCenter("You lose...")
  end
end
