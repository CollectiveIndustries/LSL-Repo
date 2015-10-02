//Home Address
string _HOME_ = "";
string _REMOTE_ = "";



//Face of the display prim
integer face = 3;

//CHEVRON PRIMS
list CHEVRONS = ["9","10,","11","12","13","14","15"];
list REMOTE_CHEVRONS = ["8","7,","6","5","4","3","2"];
integer pos = 0;

string clear = "9ee184af-2f60-2f96-e7dd-27f1facea67d";

//lists of uuid textures for Pegasus
list P_UUID = ["66ea90a6-cc12-105e-79e6-cc3f87781610","16bce894-e909-265d-0461-2c6f3178b672","75a08309-63e8-019f-8d10-2b063a4f1d98","097de694-a51a-3d25-652b-87cf0a008a1b","cf3e4a2a-4800-f695-a20f-877b3e32c377","92639a19-e534-c68b-9cbb-392fb5361741","c17db2a2-4124-9366-6498-1e412d6c7f16","3aad01c7-bd8e-fbf7-fb9d-627c58cf1dbc","5da63f60-989a-7552-23ed-74ff3aa80716","5b646de8-d928-dc8d-81ea-62ad0df58d67","5c697d5c-5f77-88f5-c79a-a5958a8a2653","cc33027a-1ebf-8a84-311a-fee645e66a2b","d211b86c-7059-1f92-f1fa-07f4404123df","9a181f1c-7082-21b6-34bd-bc59a4ee0740","d2fa0c66-efd7-35c5-f7d4-bdd77b46dcda","e37d7ad6-ee7b-c844-70a8-50d88765703b","cab61352-cd25-73a6-242e-2b33a6f8aad8","14c6e9af-a9a1-a016-ccff-5a62e742fc9f","87c78816-3e5b-7339-4e8c-e32fa508467a","0c7ac378-1264-273d-aa1e-0c9be8a4c650","36ff3452-65d4-bb4a-0c07-c4b101d0813c","6f128a6e-1309-2d3b-54e7-c5285bd378a1","64aaa99d-3dbf-df7d-99de-ba7e1024bf2f","4c3654ae-63ad-4f99-8a24-3dc47f9ed6ef","9d44962f-8c6f-e20d-1512-bc0d677e2db2","0f65f8b2-a907-c734-c751-e651d9bcdb32","b4ec8362-b5d5-f541-5a29-e9b0bff3d64f","74543c47-1981-74fb-4ae6-934c33cf7e6d","86247d4a-512c-9378-51c1-535863adf2a3","afaeea25-9c1a-d471-9fbd-062f5841d988","6ea36591-8af4-21c5-8ff2-0d654be06373","28d4a2c6-10f9-920a-2234-a55d8fa1b84b","c5e3b9b1-7ddc-6a66-26ec-e1af129f4bdd","8837e5b7-4682-72eb-333b-dda474f5ea83","e7d2c0b5-242f-127a-ed36-595fb1792dc1","9ee184af-2f60-2f96-e7dd-27f1facea67d","9ee184af-2f60-2f96-e7dd-27f1facea67d","9ee184af-2f60-2f96-e7dd-27f1facea67d"];

//List of MilkyWaytextures
list M_UUID = ["ec4b73ca-af9c-1ff9-e4d4-2f67c1ef8f9b","20df09ea-e6a4-9720-2689-8536fbab7b2c","0ac9f904-7457-6624-5f88-f086bff9a81a","c09b61cd-af17-ad7c-8d79-883f4025036c","dde61838-09e2-5bd8-2985-2cf16bbfe98c","f512e717-7cb2-941a-c5bb-393060f5ef48","44620506-87f7-8888-b2d6-96f3ad8cce4a","7f65ca48-510e-d279-80a5-f80a25bc3825","361eecfc-55da-0e69-e8d1-98a07952f95b","8a40f47a-28c4-9720-dd68-ba70d6634fb0","53aaecce-26ab-48c5-d56f-6ef89c522f47","9bcf25c2-e45e-b79c-1cea-e6c8eab328b5","761c4145-4715-45fb-4ef6-e0ee75ea1b05","fe56c6c1-91bf-11ca-4249-0f0c4109ec3b","6c6f1822-8d8b-f492-00f5-9a38f88938e9","091e0637-0152-0d3b-c487-e15cc9936c08","b3b32221-1b67-ad44-c894-86f1c0dcaa74","ebc8748d-cb10-3738-5379-c29fb848541c","5d2d8723-0723-b577-ed9e-6bf8f4717cf2","689e9464-dc92-24a6-d765-3da54f6d2ab0","73160ca3-c8ae-14e7-5933-7114a6a715ed","303948b9-3aec-f5c6-dccb-8b8ae07594eb","9275c36a-9951-c6ba-1ce2-1247d09e352a","581214c0-c01d-27fa-a76e-dff012421053","b9ea6922-a6f6-1d0f-abc4-f48b0fe9d627","7e6fad09-0b3d-3d7e-34ef-d5bb97f08b7c","6c1a7484-5780-7967-c49a-0249c32a00de","496898f6-958d-fd0c-e127-e371d68c97ed","a8b168b4-c778-0fde-a4af-201bf3e81e58","911147ad-cfe0-a591-e6ef-116b6ef81493","9da3dff9-7de6-18bd-9f04-794580f4a095","1274d0dc-8d9d-5e5a-df7d-37e49a2aef4b","96aa0f5d-7709-cad7-d311-859fff51b128","c17ea6da-f366-e48f-fca0-aa3a71d494ea","0f83854d-5ceb-d892-9a7b-12c33399c6f9","eb4a1843-36fe-3a8a-fca9-1c6d29bb87aa","5fd3ff15-9cbb-8655-cb70-bd0da63cab8d","ba6e84b6-9b7c-dfa2-2baf-5aa57d045f5f"];


//INCOMING incoming wormhole|<region>|<pos>|<owner name>|<name>|<alias>|<address>|<sgc id>

//OUTGOING dial lookup|<succ/fail>|<addr>|<spin>|<region >|<pos>|<nw>|<name>|<alias>|<owner>|<sgc id>

//API CHANNELS
integer MilkyWay_API_CHAN = -905000;
integer Pegasus_API_CHAN = -805000;


DEBUG_API(string var,string val)
{
    //llSay(0,"DEBUG: "+(string)llKey2Name(llGetOwner() )+": "+(string)llGetScriptName()+": VARIABLE >> "+var+" >> VALUE >> "+val);
}
_SetChevrons(integer mode,integer direction,string address,string remote)
{
    list tmp = llParseString2List(address,[","],[]);
    list tmp_r = llParseString2List(remote,[","],[]);
    integer index = 0;
    integer chevy = 0;
    string T_MAP;
    vector color;
    if(direction == 1)
    {
        color = <1,0,0>;
    }
    else if(direction == 2)
    {
        color = <0,1,0>;
    }
    else
        color = <1,1,1>;
        
    if(mode == MilkyWay_API_CHAN)
    {
        //17,4,32,5,34,8
        for(index;index < llGetListLength(CHEVRONS);index++)
        {
            //the -1 on the index compansates for the 0 based listing order or LSL
            T_MAP = llList2String(M_UUID,(llList2Integer(tmp,index)-1) );
            chevy = llList2Integer(CHEVRONS,index);
            
            if(index == 6)
            {
                color = <0,1,1>;
            }
            llSetLinkColor(chevy,color,face);
            llSetLinkTexture(chevy,T_MAP,face);
            //set remote chevrons
            T_MAP = llList2String(P_UUID,( llList2Integer(tmp_r,index)-1) );
            chevy = llList2Integer(REMOTE_CHEVRONS,index);
            //llSay(0,"LOADING REMOTE CHEVRON: "+(string)chevy);
            llSetLinkColor(chevy,<1,1,1>,face);
            llSetLinkTexture(chevy,T_MAP,face);
        }

    }
    else if (mode == Pegasus_API_CHAN)
    {
        for(index;index < llGetListLength(CHEVRONS);index++)
        {
            T_MAP = llList2String(P_UUID,( llList2Integer(tmp,index)-1) );
            chevy = llList2Integer(CHEVRONS,index);
            if(index == 6)
            {
                color = <0,1,1>;
            }
            llSetLinkColor(chevy,color,face);
            llSetLinkTexture(chevy,T_MAP,face);
            //Remote Chevrons
            T_MAP = llList2String(M_UUID,( llList2Integer(tmp_r,index)-1) );
            chevy = llList2Integer(REMOTE_CHEVRONS,index);
            llSetLinkColor(chevy,<1,1,1>,face);
            llSetLinkTexture(chevy,T_MAP,face);
        }
    }
}
default
{
    
    state_entry()
    {
        integer index = 0;
        for(index;index < llGetListLength(CHEVRONS);index++)
        {
            llSetLinkColor(llList2Integer(CHEVRONS,index),<1,1,1>,face);
            llSetLinkTexture(llList2Integer(CHEVRONS,index),clear,ALL_SIDES);
            llSetLinkTexture(llList2Integer(REMOTE_CHEVRONS,index),clear,ALL_SIDES);
        }
        llSay(MilkyWay_API_CHAN+1000,"stargate address");
        llSay(Pegasus_API_CHAN+1000,"stargate address");
        llListen(MilkyWay_API_CHAN,"",NULL_KEY,"");
        llListen(Pegasus_API_CHAN,"",NULL_KEY,"");

    }
    listen(integer chan,string name,key id,string msg)
    {
        DEBUG_API("LISTEN MSG",msg);
        string C_STRING = llList2String(llParseString2List(msg,["|"],[]),0);
        string glyph = llList2String(llParseString2List(msg,["|"],[]),1);
        string T_MAP = "";
        if(msg == "stargate reset" && (string)id == llGetObjectDesc())//we want to make sure its the RIGHT gate we are listening to
        {
            _SetChevrons(chan,0,_HOME_,_REMOTE_);
            pos = 0;
        }
        else if(msg == "dial lookup|failed" && (string)id == llGetObjectDesc())
        {
            llSay(0,"address not found");
            _SetChevrons(chan,0,_HOME_,_REMOTE_);
        }
        else if(msg == "status|idle" && (string)id == llGetObjectDesc())
        {
            _SetChevrons(chan,0,_HOME_,_REMOTE_);
        }
        else if(C_STRING == "dialing glyph" && (string)id == llGetObjectDesc())
        {
            T_MAP = llList2String(P_UUID, ((integer)glyph-1) );
            llSetLinkTexture(llList2Integer(CHEVRONS,pos),T_MAP,face);
            pos++;
        }
        else if(C_STRING == "incoming wormhole" && (string)id == llGetObjectDesc())
        {
            _SetChevrons(chan,1,llList2String(llParseString2List(msg,["|"],[]),6),_REMOTE_);
        }
        else if(C_STRING == "dial lookup" && (string)id == llGetObjectDesc())
        {
            _SetChevrons(chan,2,llList2String(llParseString2List(msg,["|"],[]),2),_REMOTE_);
        }
        else if(C_STRING == "stargate address" && (string)id == llGetObjectDesc())
        {
            _HOME_ = llList2String(llParseString2List(msg,["|"],[]),1);
            _REMOTE_ = llList2String(llParseString2List(msg,["|"],[]),2);
            _SetChevrons(chan,0,_HOME_,_REMOTE_);
        }
        else if(msg == "status|offline" && (string)id == llGetObjectDesc())
        {
            integer index = 0;
            for(index;index < llGetListLength(CHEVRONS);index++)
            {
                llSetLinkColor(llList2Integer(CHEVRONS,index),<1,1,1>,face);
                llSetLinkTexture(llList2Integer(CHEVRONS,index),clear,ALL_SIDES);
                llSetLinkTexture(llList2Integer(REMOTE_CHEVRONS,index),clear,ALL_SIDES);
            } 
        }
    }
}
