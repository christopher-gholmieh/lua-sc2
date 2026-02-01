--< Written by: Christopher Gholmieh
--< Variables (Assignment):

--< Coordinator:
local Coordinator = require("source.runtime.coordinator")

--< Agent:
local Agent = require("source.agent")


--< Program:
Coordinator.run_game("AcropolisAIE", Agent.new())