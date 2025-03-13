Scriptname PlayerLevelUpScript extends ReferenceAlias  

import PO3_Events_Alias

int Property linear_levelLimit = 80 Auto
float Property exponential_ParamB = 0.1 Auto

Event OnInit()
    Debug.Trace("==================== Init ====================")
    bool success = InitConfig()
    if !success
        Debug.MessageBox("DynamicWeight config invalid or not exists!")
        gotoState("Invalid")
    else
        Debug.Notification("DynamicWeight load success. Initialize player weight.")
        ChangeActorWeight(Game.GetPlayer())
    endIf
    RegisterForLevelIncrease(self)
EndEvent

bool Function InitConfig()
    Debug.Trace("==================== Init DynamicWeight Config ====================")
    string configFileName = "../DynamicWeight/DynamicWeight.json"
    bool result = JsonUtil.JsonExists(configFileName) && JsonUtil.IsGood(configFileName)
   
    if result
        string _funcType = JsonUtil.GetPathStringValue(configFileName, "function-type")
        
        if _funcType == "linear"
            linear_levelLimit = JsonUtil.GetPathIntValue(configFileName, "functions.linear.level-limit", -1)
            if linear_levelLimit == -1
                Debug.Trace("=== missing key functions.linear.level-limit")
                return result
            endif
            Debug.Trace("==================== state Linear ====================" + linear_levelLimit)
            gotoState("Linear")
        elseIf _funcType == "exponential"
            exponential_ParamB = JsonUtil.GetPathFloatValue(configFileName, "functions.exponential.b", -1000000)
            if exponential_ParamB <= -999999
                Debug.Trace("=== missing key functions.exponential.b")
                return false
            endif
            Debug.Trace("==================== state Exponential ====================")
            gotoState("Exponential")
        else
            Debug.Trace("==================== state Invalid ====================")
            result = false
            gotoState("Invalid")
        endIf
    endIf

    return result
EndFunction

Event OnLevelIncrease(int aiLevel)
    ChangePlayerWeight()
    RegisterForSingleUpdate(1)
EndEvent

Event OnUpdate()
    Debug.Trace("==================== Send obody_manualchange ====================")
    Actor actor_ = Game.GetPlayer()
	string actorPresetKey = "obody_" + actor_.GetFormID() + "_preset"
	string currentOBodyPreset =  StorageUtil.GetStringValue(none, actorPresetKey, "not-exist-preset")
    if currentOBodyPreset != "not-exist-preset"
	    MiscUtil.PrintConsole("DynamicWeight: body preset found " + currentOBodyPreset)
        OBodyNative.ApplyPresetByName(actor_, currentOBodyPreset)
    
        int me = ModEvent.Create("obody_manualchange")
        ModEvent.PushForm(me, actor_)
        ModEvent.Send(me)
    endif
EndEvent

Function ChangePlayerWeight()
    Debug.Trace("=== Empty state ChangePlayerWeight ===")
EndFunction

Function ChangeActorWeight(Actor actor_)
    Debug.Trace("=== Empty state ChangeActorWeight ===")
EndFunction

auto STATE Linear
    Event OnBeginState()
        Debug.Trace("==================== begin state Linear ====================")
    EndEvent
    Event OnEndState()
        Debug.Trace("==================== end state Linear ====================")
    EndEvent

    Function ChangePlayerWeight()
        Debug.Trace("==== DynamicWeight In State Linear ==== ")
        Actor actor_ = Game.GetPlayer()
        ChangeActorWeight(actor_)
    EndFunction

    Function ChangeActorWeight(Actor actor_)
        int currentLevel = actor_.GetLevel()
        Debug.Trace("Player " + actor_.GetDisplayName() + " level is " + currentLevel)
        ActorBase actorBase_ = actor_.GetActorBase()
        float currentWeight = actorBase_.GetWeight()
        Debug.Trace("Actor " + actor_.GetDisplayName() + " current weight " + currentWeight)
    
        float b = 100.0 / linear_levelLimit
        float newWeight = b * currentLevel
        ConsoleUtil.ExecuteCommand("player.setnpcweight " + newWeight)
        Debug.Trace("Player weight changed QueueNiNodeUpdate: " + b  + ", " + currentWeight +" to " +newWeight)

        Debug.Notification("DynamicWeight: Level up to " + currentLevel + ". Now weight is " + newWeight)
    EndFunction
EndState

State Exponential
    Event OnBeginState()
        Debug.Trace("==================== begin state Exponential ====================")
    EndEvent
    Event OnEndState()
        Debug.Trace("==================== end state Exponential ====================")
    EndEvent

    Function ChangePlayerWeight()
        Debug.Trace("==== DynamicWeight In State Note ==== ")
        Actor actor_ = Game.GetPlayer()
        ChangeActorWeight(actor_)
    EndFunction

    Function ChangeActorWeight(Actor actor_)
        int currentLevel = actor_.GetLevel()
        Debug.Trace("Actor " + actor_.GetDisplayName() + " level is " + currentLevel)
        ActorBase actorBase_ = actor_.GetActorBase()
        float currentWeight = actorBase_.GetWeight()
        Debug.Trace("Actor " + actor_.GetDisplayName() + " current weight " + currentWeight)
    
        float newWeight = 100 * (1 - Math.pow(2, exponential_ParamB * currentLevel))
        ConsoleUtil.ExecuteCommand("player.setnpcweight " + newWeight)
        Debug.Trace("Actor weight change QueueNiNodeUpdate: " + currentWeight +" to " +newWeight)
        
        Debug.Notification("DynamicWeight: Level up to " + currentLevel + ". Now weight is " + newWeight)
    EndFunction
EndState

State Invalid
    Event OnBeginState()
        Debug.Trace("==================== begin state Invalid ====================")
    EndEvent
    Event OnEndState()
        Debug.Trace("==================== end state Invalid ====================")
    EndEvent

    Function ChangePlayerWeight()
        ; Do nothing
    EndFunction

    Function ChangeActorWeight(Actor actor_)
        ; Do nothing
    EndFunction
EndState