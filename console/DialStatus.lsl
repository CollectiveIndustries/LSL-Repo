string alert = "none";
string NAME = "DIAL STATUS";
float LRadius = 2.75;//light radius
//color variables for the alert lights
vector Red =    <1.0,0.0,0.0>;
vector Yellow = <1.0,1.0,0.0>;
vector Blue =   <0.0,0.0,1.0>;
vector Orange = <1.0,0.5,0.0>;//needs tweaking
vector Grey =   <0.5,0.5,0.5>;
vector none =   <1,1,1>; //defualt color for off


OFF(vector color)
{
    //PRIM 10
    llSetLinkColor(17,none, 5);
    llSetLinkPrimitiveParams(10,[PRIM_GLOW, 5, 0.0]);
    llSetLinkColor(17,none, 6);
    llSetLinkPrimitiveParams(17,[PRIM_GLOW, 6, 0.0]);
    llSetLinkPrimitiveParams(17,[PRIM_POINT_LIGHT, FALSE, color, 1.0, LRadius, 0.0]);
    
    //PRIM 11
    llSetLinkColor(18,none, 5);
    llSetLinkPrimitiveParams(11,[PRIM_GLOW, 5, 0.0]);
    llSetLinkColor(18,none, 6);
    llSetLinkPrimitiveParams(18,[PRIM_GLOW, 6, 0.0]);
    llSetLinkPrimitiveParams(18,[PRIM_POINT_LIGHT, FALSE, color, 1.0, LRadius, 0.0]);
    
}
ON(vector color)
{
    //PRIM 10
    llSetLinkColor(17,color, 5);
    llSetLinkPrimitiveParams(10,[PRIM_GLOW, 5, 1.0]);
    llSetLinkColor(17,color, 6);
    llSetLinkPrimitiveParams(17,[PRIM_GLOW, 6, 1.0]);
    llSetLinkPrimitiveParams(17,[PRIM_POINT_LIGHT, TRUE, color, LRadius, 5.0, 0.0]);
    
    //PRIM 11
    llSetLinkColor(18,color, 5);
    llSetLinkPrimitiveParams(11,[PRIM_GLOW, 5, 1.0]);
    llSetLinkColor(18,color, 6);
    llSetLinkPrimitiveParams(18,[PRIM_GLOW, 6, 1.0]);
    
    
    llSetLinkPrimitiveParams(18,[PRIM_POINT_LIGHT, TRUE, color, LRadius, 5.0, 0.0]);
}
Flash(string link_name, vector color, string audio, integer sounds)
{
    //ON
    ON(color);
    if (sounds == TRUE && G_SOUND == TRUE)//*turns the sounds off when you select mute from menu*/
    {
        llTriggerSound(audio,1.0);
    }
    llSleep(.1);//pause before OFF
    OFF(color);
}

string Red_Alert    = "465fecec-5d6e-9ff0-3e40-78e146b54faa";
string Yellow_Alert = "1459f0be-a13b-1a39-f893-7cf97f1a52eb";
string Blue_Alert   = "f05b807b-85bc-deea-21d0-93ef0cf316d6";
string Orange_Alert = "8479106b-8be7-209a-fcfb-7ec24b96ca29";
string Abandon_Ship = "f3027ebf-f8ac-4537-75fe-225e7c83a8e1";
string ALERT_TEXTURE = "4b5488bc-7607-1363-3659-7d9e1846b601";
string Grey_Alert   = "";//no sound for grey alert this is for power saving reasons
integer G_SOUND = FALSE;
default
{
    state_entry()
    {
        llSetLinkTexture(17,ALERT_TEXTURE,5);
        llSetLinkTexture(18,ALERT_TEXTURE,5);
        llSetLinkTexture(17,"4f1e958f-7e76-0386-b87a-20148bcd7554",6);
        llSetLinkTexture(18,"4f1e958f-7e76-0386-b87a-20148bcd7554",6);
        llListen(-805000,"", "","");
        llListen(-905000,"", "","");
        llPreloadSound(Red_Alert); // Preload Red Alert sound
        llPreloadSound(Yellow_Alert); // Preload Yellow Alert sound
        llPreloadSound(Blue_Alert); // Preload Blue Alert sound
        llPreloadSound(Abandon_Ship); // Abandon Ship sound
        OFF(<1,1,1>);
    }
    
    listen(integer channel, string name, key id, string message)
    {
        integer sound;
        if (message == "status|incoming" && (string)id == llGetObjectDesc())
            {
                alert = "red";
                sound = TRUE;
                llMessageLinked(LINK_THIS,0,"audio on",NULL_KEY);
                llSetTimerEvent(0.25);
                return;
            }
            else if (message == "status|dialing" && (string)id == llGetObjectDesc())
            {
                alert = "orange";
                sound = TRUE;
                llMessageLinked(LINK_THIS,0,"audio on",NULL_KEY);
                llSetTimerEvent(0.05);
                return;
            } 
            else if (message == "status|outgoing" && (string)id == llGetObjectDesc())
            {
                alert = "blue";
                sound = TRUE;
                llMessageLinked(LINK_THIS,0,"audio on",NULL_KEY);
                llSetTimerEvent(0.25);
                return;
            }
            else if (message == "dial failed|gate-busy" && (string)id == llGetObjectDesc())
            {
                alert = "yellow";
                llSetTimerEvent(0.25);
                llTriggerSound("1459f0be-a13b-1a39-f893-7cf97f1a52eb",1.0);
            }
            else if (message == "" && (string)id == llGetObjectDesc())
            {
                alert = "none";
                llSetTimerEvent(0.0);
                //llSetColor(<0.16471, 0.16471, 0.16471>,ALL_SIDES);
                //llSetLinkColor(LINK_THIS,<1,1,1>, ALL_SIDES);
                return;
            }
            else if (message == "stargate cut" && (string)id == llGetObjectDesc())
            {
                alert = "none";
                llSetTimerEvent(0.0);
                //llSetColor(<0.16471, 0.16471, 0.16471>,ALL_SIDES);
                //llSetLinkColor(LINK_THIS,<1,1,1>, ALL_SIDES);
                return;
            }
            else if (message == "stargate close" && (string)id == llGetObjectDesc())
            {
                alert = "none";
                llSetTimerEvent(0.0);
                //llSetColor(<0.16471, 0.16471, 0.16471>,ALL_SIDES);
                //llSetLinkColor(LINK_THIS,<1,1,1>, ALL_SIDES);
                return;
            }
            else//defualt
            {
                return;
            }
    }
    
    timer()
    {
        if (alert == "red")
        {
            Flash(NAME,Red,Red_Alert,TRUE);
        }
        
        if (alert == "orange")
        {
            Flash(NAME,Orange,Orange_Alert,TRUE);
        }
        
        if (alert == "yellow")
        {
            Flash(NAME,Yellow,Yellow_Alert,FALSE);
        }
        
        if (alert == "blue")
        {
            Flash(NAME,Blue,Blue_Alert,TRUE);
        }
        
         if (alert == "grey")
        {
            Flash(NAME,Grey,Grey_Alert,FALSE);//no sound for grey alert saves power
        }
        
        if (alert == "abandon")
        {
            Flash(NAME,Red,Abandon_Ship,TRUE);
        }
        
        else if (alert == "none")
        {
            Flash(NAME,none,"",FALSE);
        }
    }
    
   
}
