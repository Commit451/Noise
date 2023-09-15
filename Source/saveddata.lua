SavedData = {}
SavedData.__index = SavedData

function SavedData:new()

    local DEFAULT_FILTER_FREQUENCY = 200

    local FILE_NAME_SETTINGS <const> = "settings"

    -- Make sure these match what you save them as when you call datastore.write
    local KEY_FILTER_FREQUENCY <const> = "filterFrequency"

    local filterFrequency = DEFAULT_FILTER_FREQUENCY

    local settingsData = playdate.datastore.read(FILE_NAME_SETTINGS)

    if settingsData ~= nil then
        filterFrequency = settingsData[KEY_FILTER_FREQUENCY]
        if filterFrequency == nil then 
            print("filterFrequency is nil, setting to default")
            filterFrequency = DEFAULT_FILTER_FREQUENCY 
        else 
            print("filterFrequency from datastore: " .. tostring(filterFrequency))
        end
    end

    -- Call this after any setting changes
    local function updateSettingsWithLocal()
        print("Saving filterFrequency value as " .. tostring(filterFrequency))
        playdate.datastore.write({filterFrequency = filterFrequency}, FILE_NAME_SETTINGS)
    end

    function self:getFilterFrequency()
        return filterFrequency
    end

    function self:updateFilterFrequency(frequency)
        filterFrequency = frequency
        updateSettingsWithLocal()
    end

    return self
end
