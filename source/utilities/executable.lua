--< Written by: Christopher Gholmieh
--< Variables (Assignment):

--< Logger:
local Logger = require("source.utilities.logger")

--< Executable:
local Executable = {
    --< Windows:
    WINDOWS_DEFAULT_INSTALLATION_PATH = "C:/Program Files (x86)/StarCraft II";

    --< Linux:
    LINUX_DEFAULT_INSTALLATION_PATH = os.getenv("SC2_INSTALLATION_PATH")
}

--< Functions:
function Executable.is_windows_operating_system()
    return package.config:sub(1, 1) == "\\"
end

function Executable.create_map_path(map_name)
    --< Windows:
    if Executable.is_windows_operating_system() then
        return Executable.WINDOWS_DEFAULT_INSTALLATION_PATH .. "/Maps/" .. map_name
    end

    --< Linux:
    if not Executable.LINUX_DEFAULT_INSTALLATION_PATH then
        Logger.log_error("[!] Unable to locate StarCraft II Map path!")
        Logger.log_error("[!] Environment variable 'SC2_INSTALLATION_PATH' was not set!")

        return nil
    else
        return Executable.LINUX_DEFAULT_INSTALLATION_PATH .. "/Maps/" .. map_name
    end
end

--< Executable:
return Executable