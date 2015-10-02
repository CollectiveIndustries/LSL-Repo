vector localpos;
vector global_pos;
key simq;
default
{
    state_entry()
    {
        llListen(-900000, "_Event Horizon", NULL_KEY, "");
    }
    listen(integer channel, string name, key id, string message)
    {
        list target = llParseString2List(message, ["|"] ,[]);
        if(llList2String(target, 0) == "map")
        {
            key k = (key) llList2String(target, 1);
            if(k == llGetOwner())
            {
                simq = llRequestSimulatorData (llList2String (target, 2), DATA_SIM_POS);
                localpos = (vector)llList2String(target, 3);
            }
        }
    }
    dataserver(key queryid, string data)
    {
        if (queryid == simq)
        {
            global_pos = (vector)data + localpos;
            string pos_str =(string)((integer)global_pos.x)+"/"+(string)((integer)global_pos.y)+"/"+(string)((integer)global_pos.z);
            llOwnerSay ("@tpto:"+pos_str+"=force");
        }
    }
}