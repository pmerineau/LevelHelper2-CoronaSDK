-----------------------------------------------------------------------------------------
--
-- cameraFollow.lua
--
-----------------------------------------------------------------------------------------
local widget = require( "widget" )
local composer = require( "composer" )
local scene = composer.newScene();

local physics = require("physics")
-- physics.setDrawMode( "hybrid" )
physics.start();
	
--------------------------------------------
local LHScene =  require("LevelHelper2-API.LHScene");
local lhScene = nil;--forward declaration of lhScene in order to access it everywhere in this file
--------------------------------------------
--------------------------------------------
local myText = display.newText(display.fps, display.contentWidth - 30, display.contentHeight - 30, native.systemFont, 16)

function scene:create( event )
	local sceneGroup = scene.view
end

local function enterFrame()
	myText.txt = display.fps;
	
end
 



function scene:show( event )
	
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		
		lhScene = LHScene:initWithContentOfFile("publishFolder/cameraFollow.json");
	
		sceneGroup:insert(lhScene);
	
		local myString = "CAMERA FOLLOW";
							
		local myText = display.newText( myString, 240, 340, display.contentWidth - 20, display.contentHeight, native.systemFont, 12 )
		myText:setFillColor( 0, 0, 0 )
	
		local uiNode = lhScene:getUINode();
		uiNode:insert( myText );
		
		
		self.demoButtons = require("demo.demoButtons");
		self.demoButtons:createButtonsWithComposerScene(self, "cameraFollow");
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
		physics.start()
		
		Runtime:addEventListener("enterFrame", enterFrame)


		-- local dJoint = lhScene:getChildNodeWithUniqueName("UntitledDistanceJoint");
		-- print("found d joint " .. tostring(dJoint) .. " type " .. dJoint.nodeType);
		
		-- print("joint " .. tostring(dJoint) .. " scene " .. tostring(lhScene));
		local sceneGroup = scene.view
		
		-- dJoint:removeSelf();
		-- dJoint = nil;
		-- print("after joint remove self");
	end
end

function scene:hide( event )
	
	local sceneGroup = self.view
	
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		self.demoButtons = nil;
		
		lhScene:removeSelf();
		lhScene = nil;
		--
		physics.stop();
		
		Runtime:removeEventListener("enterFrame", enterFrame)
		
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
	
end

function scene:destroy( event )

	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view
	
	package.loaded[physics] = nil
	physics = nil
end

--------------------------------------------------------------------------------
-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
--------------------------------------------------------------------------------
return scene