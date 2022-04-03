local size = 160
local min_x, min_y = margin_x, margin_y
local max_x, max_y = min_x+size, min_y+size
local heightmap = love.graphics.newImage('gfx/map_h.gif')
local colormap = love.graphics.newImage('gfx/map_c.gif')
local gif_cocpit = love.graphics.newImage('gfx/cocpit.gif')
local gif_steer = love.graphics.newImage('gfx/steer.gif')
local gif_skybox = love.graphics.newImage('gfx/skybox.gif')
local q_steers = {
  love.graphics.newQuad(300, 0,100,64),
  love.graphics.newQuad(200, 0,100,64),
  love.graphics.newQuad(100, 0,100,64),
  love.graphics.newQuad(  0, 0,100,64),
  love.graphics.newQuad(100,64,100,64),
  love.graphics.newQuad(200,64,100,64),
  love.graphics.newQuad(300,64,100,64)
}
local q_sky = love.graphics.newQuad(320,0,320,200)
local sky_angle = 0
local map_size = 512
local map_zoom_scale = 1.0
local map_z_scale = 48

local x = 234
local y = 300
local z = 90 
local horizon = 20
local phi = 2*3.14
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
local max_planes = 192
local first_step = 10
local min_step = 2
local vstep = 2
local fps = 15

local t = 0


function prepareGame()
  love.graphics.setBackgroundColor(255,255,255) 
end

function drawGame()
  drawHorizon()
  drawVertexSpace()
  drawCocpit()
end

function tickGame(dt)
  sinphi = math.sin(phi)
  cosphi = math.cos(phi)
  
  t=t+dt
  if game_mode == game_demo then
    phi = -math.sin(0.1*t)*2
    horizon = 20 +math.sin(0.5*t)*20
    z = 150 + (50+math.sin(0.5*t)*50)
    x = x - sinphi * move_speed * dt
    y = y - cosphi * move_speed * dt
    return
  end
  
  if love.keyboard.isDown("a") then
    phi = phi + rotate_speed*dt
    sky_angle = sky_angle + 80*rotate_speed*dt
  end
  if love.keyboard.isDown("d") then
    phi = phi - rotate_speed*dt
    sky_angle = sky_angle - 80*rotate_speed*dt
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

function drawCocpit()
  local s = math.sin(t)*4
  local ss = math.sin(t*0.2)*8
  local ns = s*-1

  -- COCPIT
  love.graphics.draw(gif_cocpit,0,h-80)

  -- ARTIFICIAL HORIZONT
  love.graphics.setColor(172,215,211)
  love.graphics.rectangle("fill",78,h-46,48,18+ns)
  love.graphics.setColor(85,76,64)
  love.graphics.rectangle("fill",78,h-28+ns,48,18-ns)
  
  -- MAP
  if math.floor(t)%2==0 then
    love.graphics.setColor(0,0,0)
  else
    love.graphics.setColor(192,146,144)
  end
  love.graphics.rectangle("fill",184,h-38,4,4)

  -- STEERING
  local i = 1+math.abs(math.floor(math.sin(t*0.25)*6))
  love.graphics.draw(gif_steer,q_steers[i], half_w-110, h-40+s)
  love.graphics.draw(gif_steer,q_steers[i], half_w+25, h-40+s)
end

function drawHorizon()  
  if sky_angle > 640 then sky_angle = sky_angle-640 end
  if sky_angle < -640 then sky_angle = sky_angle+640 end
  love.graphics.draw(gif_skybox,-320+sky_angle,-64)
  love.graphics.draw(gif_skybox,320+sky_angle,-64)
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
      getx=pleft_x*map_zoom_scale%map_size
      gety=pleft_y*map_zoom_scale%map_size
      hmap = heightmap:getPixel(getx, gety)
      r, g, b = colormap:getPixel(getx, gety)
      screen_y = (z - hmap) / p * map_z_scale + horizon
      love.graphics.setColor(r, g, b)
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
  getx=x*map_zoom_scale%map_size
  gety=y*map_zoom_scale%map_size
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
