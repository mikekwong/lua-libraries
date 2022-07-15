--[[
    Your love2d game start here
]]

Class = require 'class'
push = require 'libs/push'

require 'src/Util'
require 'src/Animation'

love.graphics.setDefaultFilter('nearest', 'nearest')

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 256
VIRTUAL_HEIGHT = 144

TILE_SIZE = 16

CHARACTER_WIDTH = 16
CHARACTER_HEIGHT = 20

SKY = 2
GROUND = 1

CHARACTER_MOVE_SPEED = 40

CAMERA_SCROLL_SPEED = 40

function love.load()
    math.randomseed(os.time())

    tiles = {}

    tilesheet = love.graphics.newImage('tiles.png')
    quads = GenerateQuads(tilesheet, TILE_SIZE, TILE_SIZE)

    playerSheet = love.graphics.newImage('character.png')
    playerQuads = GenerateQuads(playerSheet, CHARACTER_WIDTH, CHARACTER_HEIGHT)

    idleAnimation = Animation {
        frames = {1},
        interval = 1
    }
    movingAnimation = Animation {
        frames = {10, 11},
        interval = 0.2
    }

    currentAnimation = idleAnimation

    -- place character in middle of the screen, above the top ground tile
    characterX = VIRTUAL_WIDTH / 2 - (CHARACTER_WIDTH / 2)
    characterY = ((7 - 1) * TILE_SIZE) - CHARACTER_HEIGHT

    -- direction the character is facing
    direction = 'right'

    mapWidth = 20
    mapHeight = 20

    cameraScroll = 0

    backgroundR = math.random(255) / 255
    backgroundG = math.random(255) / 255
    backgroundB = math.random(255) / 255

    for y = 1, mapHeight do
        table.insert(tiles, {})

        for x = 1, mapWidth do
            -- sky and bricks; this ID directly maps to whatever quad we want to render
            table.insert(tiles[y], {
                id = y < 7 and SKY or GROUND
            })
        end
    end

    love.window.setTitle('tiles0')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    -- print(dumpOther(tiles))
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.update(dt)
    if love.keyboard.isDown('left') then
        characterX = characterX - CHARACTER_MOVE_SPEED * dt
    elseif love.keyboard.isDown('right') then
        characterX = characterX + CHARACTER_MOVE_SPEED * dt
    end

    -- set the camera's left edge to half the screen to
    cameraScroll = characterX - (VIRTUAL_WIDTH / 2) + (CHARACTER_WIDTH / 2)
end

function love.draw()
    push:start()

    love.graphics.translate(-math.floor(cameraScroll), 0)
    love.graphics.clear(backgroundR, backgroundG, backgroundB, 1)

    for y = 1, mapHeight do
        for x = 1, mapWidth do
            local tile = tiles[y][x]
            love.graphics.draw(tilesheet, quads[tile.id], (x - 1) * TILE_SIZE, (y - 1) * TILE_SIZE)
        end
    end

    -- draw character
    love.graphics.draw(playerSheet, playerQuads[1], math.floor(characterX), math.floor(characterY))
    push:finish()
end
