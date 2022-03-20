----------------------------------------------
-- Vertex Space implemented in LoveDOS (LUA)
--
-- Krzysztof Krystian Jankowski
-- 2.2022 P1X // http://bits.p1x.in
----------------------------------------------
local VER = 9

-- HISTORY
-- 9 - code refactor
--   - state names
--   - tunnel intro
-- 8 - fly mode
--   - tuned mouse steering
--   - naming refactor
--   - random movement for close vertexes
-- 7 - ground detection - bounce off
--   - shows camera coordinates
-- 6 - mouse look
--   - original map
-- 5 - LOD
-- . - main algorithm
----------------------------------------------


-- VARIABLES
----------------------------------------------
local t = 0
local w = love.graphics.getWidth()
local h = love.graphics.getHeight()
local half_h = h*0.5
local half_w = w*0.5
local quater_h = h*0.25
local quater_w = w*0.25

local heightmap = love.graphics.newImage('map_h.gif')
local colormap = love.graphics.newImage('map_c.gif')
local map_zoom_scale = 1.0
local map_z_scale = 32

local x = 256
local y = 256
local z = 150 
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
local min_step = 3
local vstep = 4
local fps = 15

local mx=0
local my=0
local last_mx = 0
local last_my = 0
local dmx = 0
local dmy = 0

-- GAME STATE
local state_intro = 0
local state_menu = 1
local state_tunnel = 2
local state_flydemo = 3
local state_fly = 4
local state_end = 5
local state = state_intro

local is_flying = false


function love.load()
  drawHeader("LOADING...")
end


function drawHeader(title)
  love.graphics.setColor()
  love.graphics.print(title, 32,30)
  love.graphics.line(16,40,w-16,40)
end

function drawIntro()
  drawHeader("INTRO")
end

function drawOutro()
  drawHeader("OUTRO")
end

function drawMenu()
  love.graphics.setColor()
  love.graphics.print("P1X MSDOS DEMO Version/" .. VER, 32,30)
  love.graphics.line(16,40,w-16,40)
  love.graphics.print("Krzysztof Krystian Jankowski", 32,50)
  love.graphics.print("[O] [P] - Level of detail (LOD)", 32,h/2+10)
  love.graphics.print("[K] [L] - Vertical resolution skip", 32,h/2+20)
  love.graphics.print("[SPACE] - Demo mode", 32,h/2+30)
  love.graphics.print("[F] - Fly or Look mode", 32,h/2+40)
  love.graphics.print("[ESC] - Back to this screen", 32,h/2+50)
  love.graphics.setColor(255,255,255)
  love.graphics.rectangle("fill", 0,h-28,w,h)
  love.graphics.setColor(0,0,0)
  love.graphics.print("Press [SPACE] to start demo or [ESC] to quit", 8,h-18) 
end

function drawHorizon()
  love.graphics.setColor(65,191,221)
  love.graphics.rectangle("fill",0,0,w,horizon*0.75)
  love.graphics.setColor(147,191,221)
  love.graphics.rectangle("fill",0,horizon*0.75,w,horizon*2)
  love.graphics.setColor(201,191,221)
  love.graphics.rectangle("fill",0,horizon*2,w,half_h)
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
    
    step_x = 1+math.ceil(vstep*(p*0.005))
    if step_x < min_step then step_x = min_step end

    for screen_x=0,w,step_x do
      getx=pleft_x*map_zoom_scale%512
      gety=pleft_y*map_zoom_scale%512
      hmap = heightmap:getPixel(getx, gety)
      r, g, b = colormap:getPixel(getx, gety)
      
      screen_y = (z - hmap) / p * map_z_scale + horizon
     
      love.graphics.setColor(r, g, b)
      love.graphics.rectangle("fill",screen_x,screen_y,step_x,quater_h+max_planes-p)
      pleft_x = pleft_x+dx*step_x
      pleft_y = pleft_y+dy*step_x
    end
    p = p - step
    if (step < min_step) then step = min_step else step = step - lod end
  end
end

function drawDemoGUI()
  love.graphics.setColor(255,255,255)
  love.graphics.print("DEMO // "..fps, 8,h-18) 
end

function drawGPS()
  getx=x*map_zoom_scale%512
  gety=y*map_zoom_scale%512
  xx = math.floor(getx)
  yy = math.floor(gety)
  zz = math.floor(z)
  love.graphics.print("GPS // "..xx.."x /"..yy.."y /"..zz.."z",8,8)
end

function drawFlyGUI()
  love.graphics.setColor(255,255,255)
  if is_flying then
    love.graphics.print("FLY // "..fps, 8,h-18)             
  else
    love.graphics.print("LOOK // "..fps, 8,h-18)
  end
  love.graphics.print("LOD / "..lod,w-200,h-18)
  love.graphics.print("VSTEP / "..vstep,w-100,h-18)

  drawGPS()

  -- CROSSHAIR
  love.graphics.setColor(0,0,0)
  love.graphics.circle("line",mx,my,8)
  love.graphics.setColor(255,192,192)
  love.graphics.circle("fill",mx,my,2)
end

function love.draw()  
  if state==state_intro then
    drawIntro()
  end

  if state==state_menu then
    drawMenu()
  end

  if state==state_flydemo or state==state_fly then
    drawHorizon()
    drawVertexSpace()
  end

  if state==state_flydemo then
    drawDemoGUI()
  end

  if state==state_fly then
    drawFlyGUI()
  end

  if state==state_end then
    drawOutro()
  end
end



function getGroundHeight(x, y)
  getx=x*map_zoom_scale%512
  gety=y*map_zoom_scale%512
  hmap = heightmap:getPixel(getx, gety)
  return hmap
end

function canFly(x, y, z)
  floor_check = getGroundHeight(x,y) < z-camera_height
  ceil_check = z < 512
  return floor_check and ceil_check
end

function love.update(dt)
  -- TIMER AND FPS
  t=t+dt

  -- FPS
  if state>state_menu then
    fps_now = 1/dt
    if fps_now>fps then fps = fps + 0.25 end  
    if fps_now<fps then fps = fps - 0.25 end
    
    sinphi = math.sin(phi)
    cosphi = math.cos(phi)
  end
  
-- DEMO
  if state==state_flydemo then
    phi = -math.sin(0.1*t)*2
    horizon = 20 +math.sin(0.5*t)*20
    z = 150 + (50+math.sin(0.5*t)*50)
    x = x - sinphi * move_speed * dt
    y = y - cosphi * move_speed * dt
  end

  -- FLY 
  if state==state_fly then

    if dmx > 0 or dmx < 0 then
      phi = phi - mx_speed*dmx*dt
    end
    if dmy > 0 or dmy < 0 then
      horizon = horizon - my_speed*dmy*dt
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
      if canFly(new_x, new_y, z) then
        x = new_x
        y = new_y
      end
    end

    if love.keyboard.isDown("w") or love.mouse.isDown(1) or is_flying then 
      new_x = x - sinphi * move_speed * dt
      new_y =  y - cosphi * move_speed * dt
      if canFly(new_x, new_y, z) then
        x = new_x
        y = new_y
      else
        z = z + camera_height
      end

    end

    if love.keyboard.isDown("q") or (horizon < 20 and is_flying) then
      new_z = z - move_speed*dt
      if canFly(x, y, new_z) then
        z = new_z
      else
        z = z + camera_height
        horizon = horizon * 1.25
      end
    end

    if love.keyboard.isDown("e") or (horizon > 60 and is_flying) then
      new_z = z + move_speed*dt
      if canFly(x, y, new_z) then
        z = new_z        
      end
    end
  end

  -- MOUSE
      
      mx,my = love.mouse.getPosition()
      if math.abs(half_w-mx)>deadzone then
         dmx = -(half_w - mx) / 24
      else
         dmx = 0
      end
      if math.abs(half_h-my)>deadzone then
         dmy = -(half_h - my) / 12
      else
         dmy = 0
      end
      

    -- SETTINGS
    if love.keyboard.isDown("p") then
      if lod < max_lod then
         lod = lod + 0.01
      end
    end
    if love.keyboard.isDown("o") then
      if lod > min_lod then
         lod = lod - 0.01
      end
    end

end

function love.keypressed(key)
  if key == "escape" then
    if state > state_menu then
      state = state_menu
    else
      love.event.quit()
    end
  end
  if key == "space" then
    state = state + 1
    if state > state_end then state = state_intro end
  end
  if key == "k" then
    if vstep>1 then
      vstep = vstep - 1 
    end
  end
  if key == "l" then
    if vstep < 16 then
      vstep = vstep + 1
    end
  end

  if key == "f" then
    if is_flying == true then 
      is_flying = false
    else 
      is_flying = true 
    end
  end
end
