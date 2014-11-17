--------------------------------------------------------------------------------
--
-- LHPulleyJointNode.lua
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--!@docBegin
--!Returns the ratio of this joint node. A number value.
local function getRatio(selfNode)
--!@docEnd	
	return selfNode.lhJointRatio;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Returns the first ground anchor point. In scene coordinates. A point value, e.g {x=100, y=100}
local function getGroundAnchorA(selfNode)
--!@docEnd	
	return selfNode.lhJointGroundAnchorA;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Returns the second ground anchor point. In scene coordinates. A point value, e.g {x=100, y=100}
local function getGroundAnchorB(selfNode)
--!@docEnd	
	return selfNode.lhJointGroundAnchorB;
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local function lateLoading(selfNode)
	
	selfNode:findConnectedNodes();
	
    local nodeA = selfNode:getConnectedNodeA();
	local nodeB = selfNode:getConnectedNodeB();
    
    local anchorA = selfNode:getContentAnchorA();
    local anchorB = selfNode:getContentAnchorB();
    
    if(nodeA and nodeB)then
    
    	local physics = require("physics")
		if(nil == physics)then	return end
		physics.start();

		local groundAnchorA = selfNode:getGroundAnchorA();
		local groundAnchorB = selfNode:getGroundAnchorB();

		local ratio = selfNode:getRatio();
		
    	local coronaJoint = physics.newJoint(	"pulley", 
                                             	nodeA,
                                              	nodeB,
                        						groundAnchorA.x,
                        						groundAnchorA.y,
                        						groundAnchorB.x,
                        						groundAnchorB.y,
												anchorA.x,
                                                anchorA.y,
                                                anchorB.x,
                                                anchorB.y,
                                                ratio);
                                                
		-- local groundAnchorA = jointInfo:pointForKey("GroundAnchorRelativeA");
  --              local groundAnchorB = jointInfo:pointForKey("GroundAnchorRelativeB");
        
  --              self.coronaJoint = physics.newJoint( "pulley", objA, objB, 
  --                                                                                      objA.x + groundAnchorA.x, objA.y + groundAnchorA.y, 
  --                                                                                      objB.x + groundAnchorB.x, objB.y + groundAnchorB.y, 
  --                                                                                      objA.x + anchorA.x,objA.y + anchorA.y, 
  --                                                                                      objB.x + anchorB.x,objB.y + anchorB.y, 
  --                                                                              jointInfo["Ratio"] )
  --              self.lhJointType = "pulley";
                
		-- coronaJoint.frequency = selfNode:getFrequency();
        -- coronaJoint.dampingRatio = selfNode:getDampingRatio();
                                                
        selfNode.lhCoronaJoint = coronaJoint;
    end
end
--------------------------------------------------------------------------------
local function visit(selfNode, event)

	if(	selfNode:getConnectedNodeA() == nil or
		selfNode:getConnectedNodeB() == nil) then
	
		selfNode:lateLoading();	
	end
		
	
	selfNode:nodeProtocolEnterFrame(event);
end
--------------------------------------------------------------------------------
local function removeSelf(selfNode)

	if(selfNode.lhCoronaJoint ~= nil)then
		selfNode.lhCoronaJoint:removeSelf();
		selfNode.lhCoronaJoint = nil;
	end
	
	selfNode:_superRemoveSelf();
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local LHPulleyJointNode = {}
function LHPulleyJointNode:nodeWithDictionary(dict, prnt)

	if (nil == dict) then
		print("Invalid LHPulleyJointNode initialization!")
	end
				
	local LHUtils = require("LevelHelper2-API.Utilities.LHUtils");
    local LHNodeProtocol = require('LevelHelper2-API.Protocols.LHNodeProtocol');
    local LHJointsProtocol = require('LevelHelper2-API.Protocols.LHJointsProtocol');
    
    
    local object = display.newGroup();
    
    --add all LevelHelper 2 valid properties to the object
	object.nodeType = "LHPulleyJointNode"
	
    prnt:addChild(object);
	
	LHNodeProtocol.initNodeProtocolWithDictionary(dict, object);
	LHJointsProtocol.initJointsProtocolWithDictionary(dict, object, prnt:getScene());

    object.lhJointGroundAnchorA = LHUtils.pointFromString(dict["groundAnchorA"]);
    object.lhJointGroundAnchorB = LHUtils.pointFromString(dict["groundAnchorB"]);
    object.lhJointRatio = dict["ratio"];
    
	-- LHScene* scene      = (LHScene*)[prnt scene];
 --       CGSize designSize   = [scene designResolutionSize];
 --       CGPoint offset      = [scene designOffset];
        -- {
        --     _groundAnchorA = CGPointMake(_groundAnchorA.x, designSize.height - _groundAnchorA.y);
        --     _groundAnchorA.x += offset.x;
        --     _groundAnchorA.y += offset.y;
        -- }
        
        -- _groundAnchorB = [dict pointForKey:@"groundAnchorB"];
        -- {
        --     _groundAnchorB = CGPointMake(_groundAnchorB.x, designSize.height - _groundAnchorB.y);
        --     _groundAnchorB.x += offset.x;
        --     _groundAnchorB.y += offset.y;
        -- }
        
    --add LevelHelper methods
    object.lateLoading 		= lateLoading;
    
    --add LevelHelper joint info methods
    object.getRatio			= getRatio;
    object.getGroundAnchorA	= getGroundAnchorA;
    object.getGroundAnchorB = getGroundAnchorB;
    
    --method overloading
    object.nodeProtocolEnterFrame 	= object.enterFrame;
    object.enterFrame = visit;
    
    object._superRemoveSelf = object.removeSelf;
    object.removeSelf 		= removeSelf;
    
	return object
end
--------------------------------------------------------------------------------
return LHPulleyJointNode;

