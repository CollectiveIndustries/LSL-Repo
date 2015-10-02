integer OUTPUT_CHAN = 0;
integer lineCounter;
integer menuchan = -9921;
integer MilkyWay_API_CHAN = -904000;
integer Pegasus_API_CHAN = -804000;
integer HANDLE = 0;

key dataRequestID;
key ID;

string notecardName = "!_Address";

list gates;

Debug(string msg, string var)
{
    integer DEBUG = FALSE;
    if(DEBUG == TRUE)
    {
        llSay(OUTPUT_CHAN, llKey2Name(llGetOwner()) + " : " + msg + " : " + var);
    }
}

default
{
    state_entry()
    {
        Debug(llGetScriptName(), "ON");
        gates = [];
        llSay(OUTPUT_CHAN, "Loading Address Database");
        lineCounter = 0;
        dataRequestID = llGetNotecardLine(notecardName, lineCounter);
        //llSay(OUTPUT_CHAN,"/!\\ NOTICE /!\\ DATABASE UNAVALIBLE");
        //llMessageLinked(LINK_ALL_OTHERS, 99, "addylib", "DONE");
    }

        dataserver(key query_id, string data)
    {
        if (query_id == dataRequestID)
        {
            if (data != EOF)
            {
                if(llGetSubString((string)data,0,0) != "#" && llGetSubString((string)data,0,0) != "")
                {
                    gates = gates + data;
                    ++lineCounter;
                    dataRequestID = llGetNotecardLine(notecardName, lineCounter);
                    //llSay(0, (string)gates);
                }
                else //its # or "" so we just go to next line
                {
                    ++lineCounter;
                    dataRequestID = llGetNotecardLine(notecardName, lineCounter);
                }
            }
            else if (data == EOF)
            {
                llSay(0,"Database ready");
                Debug("NC", "EOF");
                //llOwnerSay("configuration loaded. switching to Run Level: 5 (" + (string)llGetFreeMemory() + " bytes free)");
            }
        }
    }

    link_message(integer send_num, integer num, string str, key id)
    {
        if(str == "PERSON")
        {
            ID = id;
        }
        else if(str == "ADDYLIB")
        {
            llDialog(ID, "Where do you want to go?", gates, menuchan);
            HANDLE = llListen(menuchan, "",ID, "");
        }
        else if(str == "ADDYRESET")
        {
            llResetScript();
        }
    }
    
    listen(integer chan, string name, key id, string msg)
    {
        Debug(msg, "");
        llSay(OUTPUT_CHAN, "Attempting to dial " + msg);
        
        llSay(MilkyWay_API_CHAN, "directdial|*|" + msg + "|1");
        llSay(Pegasus_API_CHAN,  "directdial|*|" + msg + "|1");
        
        llListenRemove(HANDLE);
    }
}
