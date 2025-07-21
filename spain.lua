    --[[
        Developer: uzn_2b
    ]]--

local isRotating = false
local rotationSpeed = 100

-- 메뉴 생성
local function createRotationMenu()
    local menu = {
        {
            text = isRotating and "회전 정지" or "회전 시작",
            callback = function()
                isRotating = not isRotating
                if isRotating then
                    print("회전이 시작되었습니다!")
                else
                    print("회전이 정지되었습니다!")
                end
            end
        },
        {
            text = "닫기",
            callback = function()
                -- 메뉴 닫기
            end
        }
    }
    
    return menu
end

-- 회전 함수
local function rotatePlayer()
    if not isRotating then return end
    
    local player = PLAYER.PLAYER_PED_ID()
    
    -- 플레이어가 차량에 타고 있는지 확인
    if PED.IS_PED_IN_ANY_VEHICLE(player, false) then
        -- 차량에 타고 있으면 차량을 회전
        local vehicle = PED.GET_VEHICLE_PED_IS_IN(player, false)
        if vehicle ~= 0 then
            local heading = ENTITY.GET_ENTITY_HEADING(vehicle)
            ENTITY.SET_ENTITY_HEADING(vehicle, heading + rotationSpeed * SYSTEM.TIMESTEP())
        end
    else
        -- 도보 상태면 플레이어를 회전
        local heading = ENTITY.GET_ENTITY_HEADING(player)
        ENTITY.SET_ENTITY_HEADING(player, heading + rotationSpeed * SYSTEM.TIMESTEP())
    end
end

-- 메인 루프
util.create_tick_handler(function()
    rotatePlayer()
    return true
end)

-- 메뉴 키 바인딩 (F7 키)
menu.action(menu.my_root(), "회전 메뉴", {}, "회전 시작/정지 메뉴를 엽니다", function()
    local rotationMenu = createRotationMenu()
    
    -- 메뉴 표시
    local menuRoot = menu.list(menu.my_root(), isRotating and "회전 정지" or "회전 시작", {}, "")
    
    menu.action(menuRoot, isRotating and "회전 정지" or "회전 시작", {}, "", function()
        isRotating = not isRotating
        if isRotating then
            util.toast("회전이 시작되었습니다!")
        else
            util.toast("회전이 정지되었습니다!")
        end
        menu.delete(menuRoot)
    end)
    
    menu.action(menuRoot, "회전 속도 설정", {}, "현재 속도: " .. rotationSpeed, function()
        menu.show_command_box("회전 속도를 입력하세요 (1-500): ")
    end)
    
    menu.action(menuRoot, "닫기", {}, "", function()
        menu.delete(menuRoot)
    end)
end)

-- 명령어로도 회전 토글 가능
menu.action(menu.my_root(), "회전 토글", {"spin"}, "회전을 시작하거나 정지합니다", function()
    isRotating = not isRotating
    if isRotating then
        util.toast("회전 시작!")
    else
        util.toast("회전 정지!")
    end
end)

-- 회전 속도 설정 명령어
menu.slider(menu.my_root(), "회전 속도", {"spinspeed"}, "회전 속도를 설정합니다", 1, 500, rotationSpeed, 10, function(value)
    rotationSpeed = value
    util.toast("회전 속도가 " .. value .. "로 설정되었습니다")
end)

print("회전 스크립트가 로드되었습니다!")
print("메뉴에서 '회전 메뉴'를 선택하거나 'spin' 명령어를 사용하세요.")