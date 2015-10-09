//start_unprocessed_text

//API CHANNELS
integer MilkyWay_API_CHAN = -904000;
integer Pegasus_API_CHAN = -804000;
integer BORGDASH_API_CHAN = -2468;//out put channel for chatter can be used with BorgDash
integer SOUND_API = -26;

string buffer = "";//travlar buffer

integer _CHAT_LISTEN;

//BOOLIANS
integer SHEILD = FALSE;
integer POWER = FALSE;
integer EMP = FALSE;


//NOTE CARD LOADED VARUALBES//
// these are system defualts
integer AUTO_SHEILD = FALSE;
integer _LISTEN_CHAN = 0;
integer _BORG_COMM = FALSE;
integer OUTPUT_CHAN = 0;
integer _SOUND_INTERNAL = FALSE;
integer AUTO_COMM = FALSE;

//dual gate destruction code only avalible IF bolth notecard keys are identicaly set
key NANITES = NULL_KEY;
integer NANITE_BREACH;

//all values are overridden from the notecard


//

StatusOutput(string info)
{
    //dial lookup|successful|13,1,16,14,33,12|1|Glockler|<84.306831,64.009476,67.186531>|pegasus|What-If|NULL
    string Status = llList2String(llParseString2List(info,["|"],[]),1);
    string region = llList2String(llParseString2List(info,["|"],[]),4);
    string gateType = llList2String(llParseString2List(info,["|"],[]),6);
    string name = llList2String(llParseString2List(info,["|"],[]),7);
    if (Status == "successful")
    {
        llSay(0,"StarGate Probe\nGate Type: "+gateType+"\nRegion: "+region+"\nGate Name:"+name);
    }
}

_CISoundServ(integer chan, string UUID, integer internal)
{
    //llSay(0,"DEBUG SOUND API: "+(string)chan+" UUID: "+(string)UUID+" INTERNAL "+(string)internal);
    if (internal == TRUE)
    {
        llPlaySound(UUID,1.0);
    }
    else if(internal == FALSE)
    {
        llRegionSay(chan,"sound:"+UUID);
    }
}

playRandomSound(list UUIDS)
{
    integer listlen = llGetListLength(UUIDS);

    integer index = (integer)llFrand(listlen);
    _CISoundServ(SOUND_API, llList2String(UUIDS,index) ,_SOUND_INTERNAL);
    //llSound(llList2String(UUIDS,index), 1.0,TRUE,FALSE);
    llSleep(0.1);
}

_Timer(integer seconds, string msg)
{
    while(seconds > 0)
    {
        llSetText(msg + "\n"+(string)seconds + " Sec",<1,1,1>,1.0);
        llSleep(1.0);
        seconds = seconds -1;
    }
}


SelfDestruct()
{
    _CISoundServ(SOUND_API, "fdef740a-2ba8-11ee-0a50-dd25c2322be0" ,_SOUND_INTERNAL);
    llSetPrimitiveParams([PRIM_TEXTURE, 3, "7b9070c8-dc65-7358-01ae-8082f976d1b4",<1.0,1.0,0.0>, ZERO_VECTOR, 0.0]);
    //llSay(MilkyWay_API_CHAN,"delete stargate");
    //llSay(Pegasus_API_CHAN,"delete stargate");
    _Timer(20,"SELF DESTRUCT ((feature disabled))");
    _CISoundServ(SOUND_API, "73aae545-3925-6df1-9536-4eda6e3b9899" ,_SOUND_INTERNAL);
    llSleep(3.0);
    //llRezObject("_Explosion",llGetPos(),ZERO_VECTOR,ZERO_ROTATION,1);
    //llDie();
    //llSay(0,"DIE");
}

////////////////////////BORG DASH API CODE////////////////////////
// pass phrase used for the security hash.
string passPhrase = "BorgComV1.1";
string messageWithHash(string message,key id)
{
    return(message + "\n" + llSHA1String(message+passPhrase+(string)id));
}

////////////////////END BORG DASH API CODE////////////////////////

integer DIAL_HANDLE = FALSE;
_CITouchLoc(vector touched, key KEY)
{
    //llSay(OUTPUT_CHAN,"TOUCHED AT: "+(string)touched);

    playRandomSound(["08ca2c4b-75eb-6056-276e-7cfde6d3a9b3","4429e529-63b4-ffc6-cbff-220722065c8c","05f95eed-e222-d17e-22c6-f4c901de120d","4460c043-ae2f-709e-1bb1-b743a149225c","f48e3570-98d7-d634-baa2-e479943755f6","1a3f0d6e-e688-cef5-935d-846f8f386a8f","09deeff1-5c8e-a627-01ac-1efcf8c41acc","88bcad6c-4cb5-e8e6-a48d-97724e6de614"]);


    if(touched.x > 0.34676 && touched.x < 0.45357 && touched.y < 0.83725 && touched.y > 0.80778)
    {
        llSay(0,llKey2Name(KEY)+": Now Accepting Input on local Channel");
        DIAL_HANDLE = llListen(0,"",KEY,"");
    }
    //<0.34718, 0.78788, 0.00000>
    //<0.45343, 0.75890, 0.00000>
    if (touched.x > 0.34718 && touched .x < .45343 && touched.y < 0.78788 && touched.y > 0.75890)
    {
        llSay(API_CHAN,"cut wormhole");
    }

    if (touched.x > 0.94066 && touched .x < 0.96859 && touched.y < 0.93972 && touched.y > 0.88371)
    {
        SelfDestruct();
    }

    if(touched.x < 0.824469 && touched.x > 0.64869 && touched.y > 0.03622 && touched.y < 0.09238)
    {
        if (POWER == TRUE && llGetOwner() == KEY)//ONLY owner can turn us offline
        {
            POWER = FALSE;
            llSay(API_CHAN,"cut wormhole");
            llSleep(1);
            llSay(API_CHAN,"offline stargate");
            llSay(OUTPUT_CHAN, "Power disengaged");
            //128e4db6-99ae-4111-f149-f080eec1c1c1
            _CISoundServ(SOUND_API, "128e4db6-99ae-4111-f149-f080eec1c1c1" ,_SOUND_INTERNAL);
            llSetPrimitiveParams([PRIM_TEXTURE, 3, "7b9070c8-dc65-7358-01ae-8082f976d1b4",<1.0,1.0,0.0>, ZERO_VECTOR, 0.0]);
            state offline;
        }
    }


    if(touched.x < 0.45346 && touched.x > 0.34767 && touched.y > 0.71211 && touched.y < 0.74168)
    {
        llSay(123,"/stargate reset");
        _CIReset();
    }
    if(touched.x < 0.64674 && touched.x > 0.53897 && touched.y > 0.80310 && touched.y < 0.83323)
    {
        llSay(OUTPUT_CHAN,"Channel Open for 60 seconds listening to "+(string)llKey2Name(KEY) + "." );
        _CISoundServ(SOUND_API, "c85bf264-a79b-1092-0ea0-6e0467114b0f" ,_SOUND_INTERNAL);
        //llPlaySound("c14ea723-dea8-7906-dbc4-45b39409d98f",1.0);
        _CHAT_LISTEN = llListen(_LISTEN_CHAN,"",KEY,"");
        SENDER_KEY = KEY;
        llSetTimerEvent(60.0);
    }
    //<0.53831, 0.74086, 0.00000>
    //<0.64507, 0.70801, 0.00000>

    if(touched.x < 0.45421 && touched.x > 0.34732 && touched.y > 0.42807 && touched.y < 0.45689)
    {
        _CISoundServ(SOUND_API, "29c9a726-2877-2cdd-603d-eac1cb6cf619" ,_SOUND_INTERNAL);
        if (SHEILD == FALSE)
        {
            SHEILD = TRUE;
            llSay(API_CHAN,"raise shield");
        }
        else if(SHEILD == TRUE)
        {
            SHEILD = FALSE;
            llSay(API_CHAN,"lower shield");
        }
    }

    if(touched.x < 0.45366 && touched.x > 0.34668 && touched.y > 0.38326 && touched.y < 0.41102)
    {
        //llSay(123,"");
        if (AUTO_SHEILD == FALSE && llGetOwner() == KEY)//Owner ONLY can turn turn the Auto IDC system online
        {
            //          IDC CODE HERE          ///

            llOwnerSay("AUTO SHIELD is now activated: sheilds will now lower after ACCEPTED IDC");
            //llSay(API_CHAN,"raise shield"); //on activation we DONT want sheilds up
            //SHEILD = TRUE;            
            _CISoundServ(SOUND_API, "798f0e9f-7f17-e1fe-7075-bad8d506cde3" ,_SOUND_INTERNAL);

            AUTO_SHEILD = TRUE;
            llSetScriptState("_IDC",AUTO_SHEILD);
            //          IDC CODE END           ///
        } else if (AUTO_SHEILD == TRUE && llGetOwner() == KEY)//Again ONLY owner can shut the IDC off
    {
        llSay(OUTPUT_CHAN,"AUTO SHIELD is now De-activated:IDC OFFLINE");
        llSay(API_CHAN,"lower shield");//when we turn the IDC off lets make sure that sheilds are down
        _CISoundServ(SOUND_API, "ddbc6ccb-4944-01c2-1e4e-18c17154be9f" ,_SOUND_INTERNAL);
        //llPlaySound("f49a4c7a-5a40-6d6f-3be6-693501fd2b72", 1.0);
        SHEILD = FALSE;
        AUTO_SHEILD = FALSE;
        llSetScriptState("_IDC",AUTO_SHEILD);//turn IDC script OFFLINE
    }
    }
    if(touched.x > 0.53862 && touched.x < 0.64369 && touched.y < 0.69234 && touched.y >0.66446 )
    {
        //          DATA BASE CODE HERE          ///
        llSay(0, "AddyLib Pressed");
        llSetScriptState("_Addy_Lib", TRUE);
        llSleep(2.0);
        llMessageLinked(LINK_ROOT, 20, "PERSON", llDetectedKey(0));
        llMessageLinked(LINK_ROOT, 20, "ADDYLIB", "");
    }

    if(touched.x > 0.34663 && touched.x < 0.45320 && touched.y < 0.65058 && touched.y >0.61470 )
    {
        if(EMP == FALSE)
        {
            llSay(OUTPUT_CHAN, "EMP Deployed.");
            EMP = TRUE;
            llSetScriptState("_EMP",TRUE);
        }
        else if (EMP == TRUE)
        {
            llSay(OUTPUT_CHAN,"EMP deactivated");
            EMP = FALSE;
            llSetScriptState("_EMP",FALSE);
            llSetText("",<0,0,0>,0.0);
        }
        //llPlaySound("2978a1df-04aa-0315-e890-5776e4a30f59", 1.0);
    }

    if(touched.x > 0.10012 && touched.x < 0.12894 && touched.y < 0.08622 && touched.y >0.03581 )
    {

        llSay(OUTPUT_CHAN, "Staregate Diagnostics initialized");
        llSleep(1.0);
        llSay(OUTPUT_CHAN, "initializing Chevron Check.");
        llSay(API_CHAN,"test stargate");
        _Timer(10,"CHEVRON DIAGNOSTIC");
        llSay(OUTPUT_CHAN, "Chevron Check Complete");
        llSleep(1.5);
        llSay(OUTPUT_CHAN, "Initializing Incoming Wormhole Diagnostics");
        llSleep(1.0);
        llSay(API_CHAN,"test stargate incoming");

        _Timer(60,"INCOMING DIAGNOSTIC");
        //llSay(MilkyWay_API_CHAN,"shutdown wormhole");
        //llSay(Pegasus_API_CHAN,"shutdown wormhole");
        llSleep(1.0);
        llSay(OUTPUT_CHAN, "Wormhole Diagnostic Complete, Initializing Outgoing Wormhole Diagnostics.");
        llSleep(1.5);
        llSay(API_CHAN,"test stargate outgoing");

        _Timer(60,"OUTOGOING DIAGNOSTIC");
        //llSay(MilkyWay_API_CHAN,"shutdown wormhole");
        //llSay(Pegasus_API_CHAN,"shutdown wormhole");
        llSay(OUTPUT_CHAN, "Wormhole Diagnostic Complete, Stargate Fully operational.");
        llSetText("",<0,0,0>,0.0);

    }
}
integer G_OPEN = 1;//keep gate open
key SENDER_KEY;


//Note Card Reader
key dataRequestID;
integer lineCounter;
string notecardName = "_config";
_CISetVariables(string info)
{
    string V_NAME = llList2String(llParseString2List(info,["="],[]),0);
    string V_VALUE = llList2String(llParseString2List(info,["="],[]),1);
    //these are defualt
    //_LISTEN_CHAN = 0;
    //_BORG_COMM = FALSE;
    //OUTPUT_CHAN = 0;
    //_SOUND_INTERNAL = FALSE;
    //key NANITES;
    //integer NANITE_BREACH;
    //end defualt
    if(V_NAME == "_LISTEN_CHAN")
    {
        _LISTEN_CHAN = (integer)V_VALUE;
    }
    else if(V_NAME == "_BORG_COMM")
    {
        _BORG_COMM = (integer)V_VALUE;
    }
    else if(V_NAME == "OUTPUT_CHAN")
    {
        OUTPUT_CHAN = (integer)V_VALUE;
    }
    else if(V_NAME == "_SOUND_INTERNAL")
    {
        _SOUND_INTERNAL = (integer)V_VALUE;
    }
    else if(V_NAME == "AUTO_COMM")
    {
        AUTO_COMM = (integer)V_VALUE;
    }
    else if (V_NAME == "AUTO_SHEILD")
    {
        AUTO_SHEILD = (integer)V_VALUE;
        llSetScriptState("_IDC",(integer)V_VALUE);
        llOwnerSay("_IDC_ now activated");
    }
    else if (V_NAME == "ALERT_SOUNDS")
    {
        //llMessageLinked(
        //
    }
    else if(V_NAME == "NANITES")
    {
        //NANITE = (key)V_VALUE;
        //llSetScriptState("Nanite_Breach",TRUE);
    }
    else if(V_NAME == "ALERTS")
    {
        llSetScriptState("Dial Status",(integer)V_VALUE);
        if(V_VALUE)
        {
            llOwnerSay("Alert indicators OFFLINE");
        }
        else
            llOwnerSay("ALERTS ONLINE");
    }
    else
        llOwnerSay("line ignored check value --> "+V_NAME+"="+V_VALUE);
}
_CIReset()
{
    llSay(API_CHAN,"lower shield");
    llMessageLinked(LINK_ROOT, 20, "ADDYRESET", "");
    llSetText("",<0,0,0>,0.0);
    llSetScriptState("_EMP",FALSE);
    llSetScriptState("_IDC",AUTO_SHEILD);
    //llSetScriptState("Nanite_Breach",FALSE);
    llResetOtherScript("Dial Status");
    llResetOtherScript("Chevron Relay");
    llSleep(3.0);
    //llResetScript();
}
_CISetControls(integer switch)
{
    //public listen|<1/0>
    //public output|<1/0>
    llSay(0,"/!\\ NOTICE /!\\ StarGate Controls are now rerouted");
    llSay(API_CHAN,"public listen|"+(string)switch);
    
    llSay(API_CHAN,"public output|"+(string)switch);
}


_INIT_()//initilize the GateSystem
{
    POWER = FALSE;
    lineCounter = 0;
    dataRequestID = llGetNotecardLine(notecardName, lineCounter);
}


//DISTANCE between PA and PB this uses the pythagorean theorem
float LineDist(vector Pa,vector Pb)
{
    
    float fa = Pa.x - Pb.x;
    float fb = Pa.y - Pb.y;
    float fc = Pa.z - Pb.z;
    
    fa = (fa * fa);
    fb = (fb * fb);
    fc = (fc * fc);
    
    float sum = fa + fb + fc;
    return llSqrt(sum);
}

///////////////////////////////////////////////// DYNAMICLY STATIC API VARIABLES
integer API_CHAN = -804000;
key GATE_UUID;
integer L1;
integer L2;
default
{
    on_rez(integer start)
    {
        _CISoundServ(SOUND_API, "a1bd3c4a-bbd6-1365-562a-58589c94816a" ,TRUE);
        llSetPrimitiveParams([PRIM_TEXTURE, 3, "7b9070c8-dc65-7358-01ae-8082f976d1b4",<1.0,1.0,0.0>, ZERO_VECTOR, 0.0]);
        _CIReset();
    }
    state_entry()
    {
        _CIReset();
        _CISoundServ(SOUND_API, "a1bd3c4a-bbd6-1365-562a-58589c94816a" ,TRUE);
        llSetPrimitiveParams([PRIM_TEXTURE, 3, "7b9070c8-dc65-7358-01ae-8082f976d1b4",<1.0,1.0,0.0>, ZERO_VECTOR, 0.0]);
        //we need to find the neareset gate so we dont interfere with other systems in the area
        llSay(0,"Attempting to locate StarGate within 20 meters");
        llSay(-804000,"lower shield");
        llSay(-904000,"lower shield");
        L1 = llListen(-805000,"",NULL_KEY,"");
        L2 = llListen(-905000,"",NULL_KEY,"");
        //we need to listen to bolth APIs untill we recive a ping from the gate once we have this we can lock the console into only 1 API channel and reduce the chat clutter on all the unessisary chanels
    }
    listen(integer chan, string name, key id, string msg)
    {
        //GateDistance
        float dist = LineDist(llGetLocalPos(),llList2Vector(llGetObjectDetails(id, [OBJECT_POS]),0) );
        //llSay(0,"DIST = "+(string)dist);
        if(msg == "ping" && dist < 20.0)
        {
            llSay(0,"Stargate found: "+(string) name +"Located: "+(string)dist+"M away");
            API_CHAN = chan+1000;
            GATE_UUID = id;
            llListenRemove(L1);
            llListenRemove(L2);
            llSetObjectDesc((string)id);//this will set the GATE UUID as the Description of the object we will use thisas a key refrance for the gate in other scripts
            _INIT_();//this will activate the NoteCard Reader and set up all the new variables for it
        }
        else if(msg == "shield|0" && dist < 20.0)
        {
            llSay(0,"Stargate found: "+(string) name +"Located: "+(string)dist+"M away");
            API_CHAN = chan+1000;
            GATE_UUID = id;
            llListenRemove(L1);
            llListenRemove(L2);
            llSetObjectDesc((string)id);//this will set the GATE UUID as the Description of the object we will use thisas a key refrance for the gate in other scripts
            _INIT_();//this will activate the NoteCard Reader and set up all the new variables for it
        }
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
            llOwnerSay("configuration loaded. switching to Run Level: 5 (" + (string)llGetFreeMemory() + " bytes free)");
            POWER = TRUE;
            state running;
        }
        }
    }
}

state running
{
    on_rez(integer start)
    {
        _CIReset();
    }
    changed(integer change)
    {
        if(change & CHANGED_INVENTORY)
        {
            _CIReset();
            llResetScript();
        }
    }
    timer()
    {
        _CISoundServ(SOUND_API, "671c7c20-8200-2c40-b0f7-61cf0a8dd82a" ,_SOUND_INTERNAL);
        llSay(OUTPUT_CHAN,"Link Timed Out");
        if(AUTO_COMM == 0)
            llListenRemove(_CHAT_LISTEN);
        llSetTimerEvent(0.0);
    }
    touch_start(integer num_detected)
    {
        integer i;
        vector touchedLoc;
        for (i = 0; i < num_detected; i++)
        {
            touchedLoc = llDetectedTouchST(i);
            if(POWER == TRUE)
            {
                _CITouchLoc(touchedLoc,llDetectedKey(0));
            }
            else if(POWER == FALSE && llGetOwner() == llDetectedKey(0))
            {
                llSay(API_CHAN,"online stargate");
                POWER = TRUE;
                llSetPrimitiveParams([PRIM_TEXTURE, 3, "a84c75de-1284-7b71-59bf-5e30cf6b5d23",<1.0,1.0,0.0>, ZERO_VECTOR, 0.0]);
                _CISoundServ(SOUND_API, "538ad4bc-64ab-e405-dbab-fd526213b772" ,_SOUND_INTERNAL);
            }

        }
    }

    state_entry()
    {

        llSay(API_CHAN,"lower shield");
        SHEILD = FALSE;
        _CISetControls(0);
        llListen(API_CHAN-1000,"",NULL_KEY,"");

        _CISoundServ(SOUND_API, "0ac34ae9-041f-866a-0d35-913264aba36f" ,_SOUND_INTERNAL);
        llSetPrimitiveParams([PRIM_TEXTURE, 3, "a84c75de-1284-7b71-59bf-5e30cf6b5d23",<1.0,1.0,0.0>, ZERO_VECTOR, 0.0]);


    }
    listen(integer chan,string name,key id,string msg)
    {
        integer _INCOMING_;
        string FORMATED_CHATTER = "send chatter|"+(string)llKey2Name(id)+"|"+msg+"|"+(string)G_OPEN;
        string C_STRING = llList2String(llParseString2List(msg,["|"],[]),0);
        string CHATTER_NAME = llList2String(llParseString2List(msg,["|"],[]),1);
        string CHATTER_MSG = llList2String(llParseString2List(msg,["|"],[]),2);
        string OUTPUT_STRING = CHATTER_NAME+" >> "+CHATTER_MSG;
        OUTPUT_STRING = llGetSubString(OUTPUT_STRING,0,(llStringLength(OUTPUT_STRING)-1) );
        if(chan == _LISTEN_CHAN && id == SENDER_KEY)
        {
            //send chatter|<name>|<msg>|<1/0>
            llSay(API_CHAN,FORMATED_CHATTER);

            llListenRemove(_CHAT_LISTEN);
            llSetTimerEvent(0.0);
            llSay(OUTPUT_CHAN,"Chatter Saved for Target Gate. /!\\EMP SENT /!\\");
            _CISoundServ(SOUND_API, "a85aa333-07f8-2f5b-6539-86b975189b34" ,_SOUND_INTERNAL);

            llSay(API_CHAN,"stargate emp");
        }
        else if(chan == 0 && DIAL_HANDLE != FALSE)
        {
            llSay(API_CHAN, "directdial|*|" + msg + "|1");
            llSay(OUTPUT_CHAN, "Attempting to dial " + msg);
            llListenRemove(DIAL_HANDLE);
            DIAL_HANDLE = FALSE;
        }
        else if(chan == _LISTEN_CHAN && AUTO_COMM == TRUE)
        {
            llSay(API_CHAN,FORMATED_CHATTER);
        }
        if( msg == "stargate close")
        {
            EMP = FALSE;
            llSetText("",<0,0,0>,0.0);
            llSetScriptState("_EMP",FALSE);
        }
        if(msg == "target shield lowered")
        {
            _CISoundServ(SOUND_API, "32070596-2fee-2201-c845-3dd77047005e" ,_SOUND_INTERNAL);
            
        }
        if(msg == "target shield raised")
        {
            llSay(OUTPUT_CHAN,"/!\\ WARNING /!\\ Target Sheilds Raised");
            _CISoundServ(SOUND_API, "391e2101-55bd-b1c0-a6cc-332bd5993ae9" ,_SOUND_INTERNAL);
        }
        //chatter|<name>|<msg>
        if(C_STRING == "chatter" && llSubStringIndex(CHATTER_NAME, "_") != 0 && llSubStringIndex(CHATTER_NAME, "TRAVELER") != 0 && llSubStringIndex(CHATTER_MSG, "IDC") != 0 && llSubStringIndex(CHATTER_MSG, "TRAV") != 0)
        {
            if(_BORG_COMM == FALSE)
            {
                //if the BORG COMM is false then output on channel OUTPUT_CHAN
                llSay(OUTPUT_CHAN,OUTPUT_STRING);
            }
            else
            {
                // this line will send the message on the BorgDash comm system
                llRegionSay(BORGDASH_API_CHAN,messageWithHash(OUTPUT_STRING,llGetKey()));
            }
        }
        else
        {
            //          IDC OUTPUT HERE          //
        }
        if(AUTO_SHEILD == TRUE && msg == "status|incoming")
        {
            buffer = "IN-BOUND TRAVALER:\n";//clear the buffer every NEW gate
            llSay(API_CHAN,"raise shield");
            SHEILD = TRUE;
            //llResetOtherScript("_IDC");
            //          IDC CODE HERE          //
        }
        if(C_STRING == "target wormhole collision" && CHATTER_NAME == "agent")
        {
            llSay(OUTPUT_CHAN,"/!\\ INBOUND TRAVALAR /!\\");
            buffer += (buffer = "") + buffer + /*(string)*/llKey2Name(CHATTER_MSG) +"\n";
            llSetText(buffer,<1,1,1>,1.0);
        }
        if(C_STRING == "dial lookup") //well Command String for Dial Lookups are working still
            //llOwnerSay("DIAL LOOKUP:" + msg);
            StatusOutput(msg);
    }
}

state offline
{
    state_entry()
    {
        llSay(0,"Power OFFLINE. Standing By.");
    }
    touch_start(integer num_detected)
    {
        integer link = llDetectedLinkNumber(0);
        integer face = llDetectedTouchFace(0);
        
        if(link == 1 && face == 3) //Link 1 for ROOT PRIM face 3 for Console face
        {
            llSay(0,"Transfering Power.");
            llSay(API_CHAN,"online stargate");
            POWER = TRUE;
            state default;
        }
    }
}
//end_unprocessed_text
//nfo_preprocessor_version 0
//program_version Phoenix Viewer 1.6.1.1691 - AdmiralMorketh Sorex
//mono