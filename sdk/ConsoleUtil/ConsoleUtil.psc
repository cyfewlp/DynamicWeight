;/ Decompiled by Champollion V1.0.1
Source   : ConsoleUtil.psc
Modified : 2019-04-08 03:22:05
Compiled : 2019-04-08 03:25:51
User     : ryan_
Computer : DESKTOP-O1MSN1T
/;
scriptName ConsoleUtil

;-- Properties --------------------------------------

;-- Variables ---------------------------------------

;-- Functions ---------------------------------------

Int function GetVersion() global native

String function ReadMessage() global native

function PrintMessage(String a_message) global native

function ExecuteCommand(String a_command) global native

ObjectReference function GetSelectedReference() global native

function SetSelectedReference(ObjectReference a_reference) global native

function onBeginState()
{Event received when this state is switched to}

	; Empty function
endFunction

; Skipped compiler generated GotoState

; Skipped compiler generated GetState

function onEndState()
{Event received when this state is switched away from}

	; Empty function
endFunction
