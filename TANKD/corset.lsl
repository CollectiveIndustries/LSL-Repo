//#!/usr/lsl

// Script Specific variables
string namePrefix = "";

// Owner UUID list from notcard
list _Unames = [];// list of owner's User names from the NoteCard

//Note Card Reader
key dataRequestID;
integer lineCounter;
string notecardName = "!_Config_";

_CISetVariables(string info)
{
    string V_NAME = llList2String(llParseString2List(info,["="],[]),0);
    string V_VALUE = llList2String(llParseString2List(info,["="],[]),1);
    if(llToLower(V_NAME) == "owner") //pre hash and store ALL relivant UserNames
        _Unames = (_Unames = []) + _Unames + (string)V_VALUE;
    if(llToLower(V_NAME) == "detach")
        llOwnerSay("@detach="+V_VALUE);
    if(llToLower(V_NAME) == "name_prefix")
        namePrefix = V_VALUE;
}

integer _CICompare(string s1, string s2)
{
    if (s1 == s2)
        return FALSE;
    if (s1 == llList2String(llListSort([s1, s2], 1, TRUE), 0))
        return -1;
    return TRUE;
}

// String snippets from SL Wiki for use with common strings
integer contains(string haystack, string needle) // http://wiki.secondlife.com/wiki/llSubStringIndex
{
    return 0 <= llSubStringIndex(haystack, needle);
}

integer endswith(string haystack, string needle) // http://wiki.secondlife.com/wiki/llSubStringIndex
{
    return llDeleteSubString(haystack, 0x8000000F, ~llStringLength(needle)) == needle;
}

integer startswith(string haystack, string needle) // http://wiki.secondlife.com/wiki/llSubStringIndex
{
    return llDeleteSubString(haystack, llStringLength(needle), 0x7FFFFFF0) == needle;
}

string strReplace(string source, string pattern, string replace) {
    while (llSubStringIndex(source, pattern) > -1) {
        integer len = llStringLength(pattern);
        integer pos = llSubStringIndex(source, pattern);
        if (llStringLength(source) == len) { source = replace; }
        else if (pos == 0) { source = replace+llGetSubString(source, pos+len, -1); }
        else if (pos == llStringLength(source)-len) { source = llGetSubString(source, 0, pos-1)+replace; }
        else { source = llGetSubString(source, 0, pos-1)+replace+llGetSubString(source, pos+len, -1); }
    }
    return source;
}
//


// Set up a UUID based channel with the Owners Key
integer _CIuuid2chan(key id)
{
    integer mainkey = 921;
    string tempkey = llGetSubString((string)id, 0, 7);
    integer hex2int = (integer)("0x" + tempkey);
    return hex2int + mainkey;
}

//Section grabs values from the notecard and then sets them all up in script memmory
default
{
    changed(integer change)
    {
        if(CHANGED_INVENTORY  & change)
            llResetScript();
    }

    on_rez(integer start)
    {
        
    }
    
    state_entry()
    {
        lineCounter = 0;
        dataRequestID = llGetNotecardLine(notecardName, lineCounter);
    }
    
    dataserver(key query_id, string data) 
    {
        if (query_id == dataRequestID) 
        {
            if (data != EOF) 
            {    
                if(llGetSubString((string)data,0,0) != "#" && llGetSubString((string)data,0,0) != "")
                {
                    _CISetVariables(data);
                    ++lineCounter;                
                    dataRequestID = llGetNotecardLine(notecardName, lineCounter);    
                }
                else //its # or "" so we just go to the next line
                {
                    ++lineCounter;
                    dataRequestID = llGetNotecardLine(notecardName, lineCounter);
                }
            }
            else if (data == EOF)
            {
                llOwnerSay("Configuration loaded. Switching to Run Level: 5 (" + (string)llGetFreeMemory() + " bytes free)");
                state running;
            }
        }
    }
}

state running
{
    changed(integer change)
    {
        if(CHANGED_INVENTORY & change)
            llResetScript();
    }

    state_entry()
    {
        llSay(PUBLIC_CHANNEL, llDumpList2String(_Unames, "\n"));
        llListen(PUBLIC_CHANNEL, "", NULL_KEY, "");
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if(message == (namePrefix+"corset"))
        {
            //check and see if the AV name is in the list of owners
            if(llListFindList(_Unames, [llToLower(strReplace(name, " ", "."))]) != -1) //name from listen is found in the _Unames list AFTER " " has been replaced with "."
            {
                // A menu should go here to interact with the "Owner"
                llSay(PUBLIC_CHANNEL, "Hello "+name);
                
            }
            else
            {
                // A PM can be sent from here in order to tell a user off or we can just leave this empty 
                // as a third option NC Configurable inorder to set message and IM true/false
                llSay(PUBLIC_CHANNEL, name+" you are not an Owner");
                //Avatar is NOT in the OwnersList
            }
        }
    }
}
