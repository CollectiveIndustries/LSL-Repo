//_IDC_
string AUTH_CODE;

//API CHANNELS
integer MilkyWay_API_CHAN = -904000;
integer Pegasus_API_CHAN = -804000;
default
{
    state_entry()
    {
        llListen(MilkyWay_API_CHAN-1000,"",NULL_KEY,"");
        llListen(Pegasus_API_CHAN-1000,"",NULL_KEY,"");
        AUTH_CODE = llSHA1String( (string)llGetCreator()+(string)llGetOwner() );
    }
    listen(integer chan,string name,key id,string msg)
    {
        string C_STRING = llList2String(llParseString2List(msg,["|"],[]),0);
        string CHATTER_NAME = llList2String(llParseString2List(msg,["|"],[]),1);
        string CHATTER_MSG = llList2String(llParseString2List(msg,["|"],[]),2); 
        integer idc = llSubStringIndex(CHATTER_MSG,"IDC:");
        string FORMATED_CHATTER = "send chatter|"+(string)llKey2Name(id)+"|"+"TRAV:" + (string)AUTH_CODE+"|1";
        //llSay(0,"INDEX = "+(string)idc);
        if(idc == 0)
        {
            llOwnerSay("IDC requested: transmitting data");
            llSay(MilkyWay_API_CHAN,FORMATED_CHATTER);
            llSay(Pegasus_API_CHAN,FORMATED_CHATTER);
        }
        else if (CHATTER_MSG == "TRAV:IDC:CLEAR")
        {
            llOwnerSay("You may now enter the StarGate");
        }
    }
}