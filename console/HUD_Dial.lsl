string address;
integer dialchan = 123;
string subject;
string message;
string notecardName = "Stargates";
integer channel; 
integer listen_handle;
key user;
#include "main.h"
//ShowMenu(list menu_items,key id, integer page, integer sort)

init() {
    llListenRemove(listen_handle);
    user = llDetectedKey(0);
    channel = llFloor(llFrand(2000000));
    listen_handle = llListen(channel, "", user, "");
}

list MainMenu = ["Dial","Commands"];
list Commands = ["name","lower","raise","reset"];
list adresses = [];
list menu = [];// this is fo the dialog names loaded from note card > is the nicname diliminator

processCommand(string in,key i)
{
    if ("Dial" == in)
        ShowMenu(menu,i,1,FALSE);
    if("Commands" == in)
        ShowMenu(Commands,i,1,FALSE);
    if(llListFindList(Commands,(list)in) != -1)
        llSay(dialchan,"/stargate "+(string)in);
    if(llListFindList(menu,(list)in) != -1)
        llSay(dialchan,"/d " + (string)llList2String(adresses,llListFindList(menu,(list)in)));
}
// NoteCard Vars no need to change
//string  notecardName = "My Notecard";
integer lineCounter;
key     dataRequestID;

default
{
    state_entry()
    {
        if (INVENTORY_NOTECARD == llGetInventoryType(notecardName))
        {
            init();
            llOwnerSay("NC found reading lines for server list");
            state readNotecard;
        }else
        {
            llSay(0,(string)notecardName + " - Note Card not found server cannot function");
        }
    }
    changed(integer change)
    {
        init();
        llResetScript();
    }
}

state readNotecard
{
    state_entry()
    {
        lineCounter = 0;
        dataRequestID = llGetNotecardLine(notecardName, lineCounter);
    }
    dataserver(key query_id, string data) {
        if (query_id == dataRequestID) {
            if (data != EOF) {    // not at the end of the notecard
                if(llGetSubString((string)data,0,0) != "#" && llGetSubString((string)data,0,0) != ">")
                {                    
                    adresses = (adresses=[]) + adresses + [(string)data]; 
                    //llOwnerSay("Line #" + (string)lineCounter+": "+(string)data);    // output the line
                   ++lineCounter;                // increase line count
                    dataRequestID = llGetNotecardLine(notecardName, lineCounter);    // request next line
                }else if(llGetSubString((string)data,0,0) == ">") // if # found at begining of line check for > nick name of addy
                {
                    menu = (menu=[]) + menu + [(string)llGetSubString((string)data,1,llStringLength(data))];
                    ++lineCounter;
                    dataRequestID = llGetNotecardLine(notecardName, lineCounter);
                }else //if not > then must be # so its a comment
                {
                    ++lineCounter;
                    dataRequestID = llGetNotecardLine(notecardName, lineCounter);
                }
            }else if (data == EOF)
            {
                llOwnerSay("configuration loaded. switching to Run Level: 5 (" + (string)llGetFreeMemory() + " bytes free)");
                state running;
            }
        }
    }
}
state running
{
    state_entry()
    {
        init();
    }
    changed(integer change)
    {
        init();
        llResetScript();
    }
    touch_start(integer num)
    {
        init();
        integer len = llGetListLength(adresses);
        integer a = 0;
        //ShowMenu(list menu_items,key id, integer page, BOOLEAN sort)
        ShowMenu(MainMenu,llDetectedKey(0),1,FALSE);
        //for( a=0;a!=len;a++)
        //llSay(0,"/d "+ llList2String(adresses,a));
    }
    listen(integer chan, string name, key id, string mes)
    {
        processCommand(mes,id);
    }
}