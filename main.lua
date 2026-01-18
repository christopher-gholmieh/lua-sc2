--< Written by: Christopher Gholmieh
--< Variables (Assignment):

--< Coordinator:
local Coordinator = require("source.runtime.coordinator")

--< Agent:
local Agent = require("source.agent")


--< Program:
Coordinator.run_game("C:/Program Files (x86)/StarCraft II/Maps/AcropolisAIE.SC2Map", Agent.new())