string BuildPlat = "PLAT";

integer Power = FALSE;
integer Laser = FALSE;
integer SideGrid = FALSE;
integer Half = FALSE;
integer chan;
integer menchan;

list menu;

integer SetID(key id)
{
	integer mainkey = 921;
	string tempkey = llGetSubString((string)id, 0, 7);
	integer hex2int = (integer)("0x" + tempkey);
	return (hex2int + mainkey);
}


RezPlat(float local)
{
	vector size = llGetAgentSize(llGetOwner());
	float realsize = size.z * 1.125;
	vector loc = llGetPos();
	loc.z = loc.z - realsize + local;
	llOwnerSay("function RezStep():");
	llRezObject(BuildPlat,loc,<0,0,0>,ZERO_ROTATION,0);
}

default
{
	state_entry()
	{
		chan = SetID(llGetOwner());
	}

	changed(integer change)
	{
		if(change & CHANGED_OWNER)
		{
			llResetScript();
		}
	}

	touch_start(integer total_number)
	{
		if(Power == FALSE)
		{
			state rezzed;
		}
	}
}

state rezzed
{
	state_entry()
	{
		Power = TRUE;
		integer i;
		for(i = 0; i < 9; i++)
		{
			RezPlat(i);
		}
	}
}