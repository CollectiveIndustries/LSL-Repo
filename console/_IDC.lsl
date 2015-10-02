//API CHANNELS
integer MilkyWay_API_CHAN = -904000;
integer Pegasus_API_CHAN = -804000;
integer BORGDASH_API_CHAN = -2468;//out put channel for chatter can be used with BorgDash
integer SOUND_API = -26;

//IDC FORMATED STRING
string _IDC_ = "";
list _keys = [];// list of IDC hashs from the NoteCard

integer G_OPEN = 1;
//Note Card Reader
key dataRequestID;
integer lineCounter;
string notecardName = "!_IDC_";



_CISetVariables(string info)
{
    string V_NAME = llList2String(llParseString2List(info,["="],[]),0);
    string V_VALUE = llList2String(llParseString2List(info,["="],[]),1);
    if(V_NAME == "IDC") //pre hash and store ALL relivant keys
        _keys = (_keys = []) + _keys + (llSHA1String( (string)llGetCreator()+(string)V_VALUE ) );
}
_CICompare(list stuff,string line)
{
}
    
// this script will controle the IDC part of the gate
default
{
    on_rez(integer start)
    {
        llSetScriptState(llGetScriptName(),FALSE);
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
                }else //its # or "" so we just go to next line
                {
                    ++lineCounter;
                    dataRequestID = llGetNotecardLine(notecardName, lineCounter);
                }
            }else if (data == EOF)
            {
                llOwnerSay("IDC loaded. switching to Run Level: 6 (" + (string)llGetFreeMemory() + " bytes free)");
                state running;
            }
        }
    }
}

state running
{
    state_entry()
    {
        llListen(MilkyWay_API_CHAN-1000,"",NULL_KEY,"");
        llListen(Pegasus_API_CHAN-1000,"",NULL_KEY,"");
        
        _IDC_ = "IDC:"+llSHA1String((string)llGetCreator() );
        //the last key will be the travaler ID_KEY
        //llSay(0,"/!\\ IDC DEBUG MODE /!\\");
        //llSay(0,"DEBUG IDC "+(string)_keys);
        //llSetScriptState(llGetScriptName(),FALSE);
    }
    listen(integer chan, string name,key id,string msg)
    {
        string FORMATED_IDC = "send chatter|"+(string)llKey2Name(id)+"|"+_IDC_+"|"+(string)G_OPEN;
        string FORMATED_chat = "send chatter|"+(string)llKey2Name(id)+"|";
        string C_STRING = llList2String(llParseString2List(msg,["|"],[]),0);
        string CHATTER_NAME = llList2String(llParseString2List(msg,["|"],[]),1);
        string CHATTER_MSG = llList2String(llParseString2List(msg,["|"],[]),2);
        integer idc_index = llSubStringIndex(CHATTER_MSG,"TRAV:");
        string _tmp_ = "";
        //llSay(0,msg);
        //TRAV:
        if(idc_index == 0)
        {
            _tmp_ = llList2String(llParseString2List(msg,[":"],[]),1);
            //llListFindList(_keys, [_tmp_]) // Returns -1 if hash isnt found in local storage
            if(llListFindList(_keys, [_tmp_]) != -1)
            {
                llSay(MilkyWay_API_CHAN,"lower shield");
                llSay(Pegasus_API_CHAN,"lower shield");
                //after dropping sheilds send All Clear to Travelar
                llSay(MilkyWay_API_CHAN,FORMATED_chat+"TRAV:IDC:CLEAR"+"|1");
                llSay(Pegasus_API_CHAN,FORMATED_chat+"TRAV:IDC:CLEAR" +"|1");
            }
            else
            {
                //llSay(0,"DEBUG IDC: "+(string)_tmp_);
            }
        }
        if (msg == "status|incoming" && (string)id == llGetObjectDesc())
        {
            llSay(MilkyWay_API_CHAN,FORMATED_IDC);
            llSay(Pegasus_API_CHAN,FORMATED_IDC);
        }
            
    }
}