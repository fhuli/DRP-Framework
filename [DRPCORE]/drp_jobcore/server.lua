local playersJob = {}
---------------------------------------------------------------------------
-- Job Core Events (DO NOT TOUCH!)
---------------------------------------------------------------------------
RegisterServerEvent("DRP_JobCore:StartUp")
AddEventHandler("DRP_JobCore:StartUp", function()
    local src = source
    table.insert(playersJob, {source = src, job = "UNEMPLOYED", jobLabel = "Unemployed"})
end)

AddEventHandler("playerDropped", function()
    local src = source
    for a = 1, #playersJob do
        if playersJob[a].source == src then
            table.remove(playersJob, a)
            break
        end
    end
end)

RegisterCommand("job", function(source, args, raw)
    local src = source
    local myJob = GetPlayerJob(src)
    TriggerClientEvent("DRP_Core:Info", src, "Job Manager", tostring("Your job is "..myJob.jobLabel..""), 2500, false, "leftCenter")
end, false)

---------------------------------------------------------------------------
-- Main Server Event To Change And Add People To Jobs  ONLY FOR BUILTIN JOBS
---------------------------------------------------------------------------
RegisterServerEvent("DRP_Jobs:StartWork")
AddEventHandler("DRP_Jobs:StartWork", function(jobTitle)
    local src = source
    local characterInfo = exports["drp_id"]:GetCharacterData(src)
    local job = jobTitle
    local jobLabel = JobsCoreConfig.JobLabels[job] -- Gets The Job Label To Display In The Notifications
    local jobRequirement = JobsCoreConfig.Requirements[job] -- Gets If You Are Enabled To Do This Job
    local currentPlayerJob = GetPlayerJob(src)
    if currentPlayerJob.job == job then
        TriggerClientEvent("DRP_Core:Error", src, "Job Manager", tostring("You are already on duty"), 2500, false, "leftCenter")
    else
    if DoesJobExist(job) then
        if jobRequirement ~= false then
            SetPlayerJob(src, job, jobLabel)
            end
        end
    end
end)

---------------------------------------------------------------------------
-- Main Server Event To Change And REMOVE People FROM Jobs  ONLY FOR BUILTIN JOBS
---------------------------------------------------------------------------
RegisterServerEvent("DRP_Jobs:FinishWork")
AddEventHandler("DRP_Jobs:FinishWork", function()
    local src = source
    local player = exports["drp_core"]:GetPlayerData(src)
    local job = "CITIZEN"
    local jobLabel = JobsCoreConfig.StaticJobLabels[job]
    SetPlayerJob(src, job, jobLabel)
    TriggerClientEvent("DRP_Core:Info", src, "Job Manager", tostring("You are now "..GetPlayerJob(src).jobLabel), 2500, false, "leftCenter")
    -- TRIGGER TO GET THE PREVIOUS CLOTHES BACK! (FUTURE UPDATES)
end)

---------------------------------------------------------------------------
-- Main Functions
---------------------------------------------------------------------------
function GetPlayerJob(player)
    for a = 1, #playersJob do
        if playersJob[a].source == player then
            return playersJob[a]
        end
    end
    return false
end

function DoesJobExist(job)
    for a = 1, #JobsCoreConfig.Jobs do
        if JobsCoreConfig.Jobs[a] == job then
            return true
        end
    end
    return false
end

function SetPlayerJob(player, job, label)
    for a = 1, #playersJob do
        if playersJob[a].source == player then
            playersJob[a].job = job
            playersJob[a].jobLabel = label
            break
        end
    end
end