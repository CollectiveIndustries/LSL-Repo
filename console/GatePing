integer MilkyWay_API_CHAN = -904000;
integer Pegasus_API_CHAN = -804000;
list params = [];

default
{
    state_entry()
    {
        llListen(MilkyWay_API_CHAN-1000,"",NULL_KEY,"");
        llListen(Pegasus_API_CHAN-1000,"",NULL_KEY,"");
    }
    listen(integer chan,string name,key id,string msg)
    {
        
        //llSay(0,msg);
        if (msg == "ping")
        {
            //llSay(123,"/d majel");
            params = llGetObjectDetails(id, [OBJECT_POS]);
            llOwnerSay("GATE POS = "+(string)params);
            //llSetColor(<1,0,0>,ALL_SIDES); //red
        }
    }
}