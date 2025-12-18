local VEHICLE_SPACING_DISTANCE = 30.0

StartingVehicles = {
    s_StartingVehicleList = {}
}

function StartingVehicles.Save()
    return StartingVehicles
end

function StartingVehicles.Load(StartingVehicleData)
    StartingVehicles = StartingVehicleData
end

function StartingVehicles.Start()
    for i = 1, MAX_STARTING_VEHICLES - 1 do
        local pContents = GetNetworkListItem(NETLIST_StratStarting, i)

        if (pContents == nil or pContents == "") then
            break
        end

        StartingVehicles.s_StartingVehicleList[#StartingVehicles.s_StartingVehicleList + 1] = pContents
    end
end

function StartingVehicles.CreateVehicles(Team, TeamRace, Bitmask, Where)
    local RandomizedPosition = nil
    local VehicleH = 0

    for i = 1, #StartingVehicles.s_StartingVehicleList do
        if (bit32.band(Bitmask, bit32.lshift(1, i - 1)) > 0) then
            -- Need to build this.
            RandomizedPosition = GetPositionNear(Where, VEHICLE_SPACING_DISTANCE, 4 * VEHICLE_SPACING_DISTANCE)

            local NewODF = TeamRace .. StartingVehicles.s_StartingVehicleList[i]:sub(2)

            VehicleH = BuildObject(NewODF, Team, RandomizedPosition)
            SetRandomHeadingAngle(VehicleH)
            SetBestGroup(VehicleH)
        end -- bit is on-- need to build.
    end     -- loop over all entries.
end

return StartingVehicles
