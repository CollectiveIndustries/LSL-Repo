integer TOUR_PROGRESS_CHANNEL=-438562368;

// Configuration
integer DEBUG = FALSE; // Turns OFF @detach=n, may also spam you.
integer check_goals_interval = 2; // Tune for permformance vs. lag
integer interface_channel = -441134200; // Protocol channel for talking to hud.
integer dialog_channel = -12351515; // Dialog channel for safeword and stuff. Probably should be dynamic, but since you can listen by key and it's so low traffic it does not seem worth the effort.
integer supported_quest_version = 000301; // Quest specification supported.
string supported_client = "SlaveQuest"; // FUTURE USE: So unofficial/fork versions can have their own required version. Of course, they could also just change the interface channel...
string no_password = "none"; // Password used for unpasswored operations

// Config loading stuff
string config_file = "";
integer card_line; // used to read notcards
integer card_length; // calculate completion percentage
key req_key;
key length_key;

// Teleport stuff
key teleport_query_id;
string teleport_surl;

// State
string step_name;
string step_text;
integer step_number;
integer step_timer;
string step_timer_failure_name;
integer step_end_found;
integer step_started;

list goals;
string goal_name;
string goal_type;
string goal_args;

string quest_name;
string quest_text;
string quest_password;
key quest_source;
integer quest_version;
integer quest_accepted = FALSE;
integer quest_start_found;
integer quest_end_found = FALSE;
integer quest_failure_end_found = FALSE;
string quest_fail_text;
string quest_fail_name;

list slave_bounding_box;
key slave_sitting_on;
string slave_sitting_on_name;

integer found_failure = FALSE;

integer feedback_channel;

integer skipping;

setText(string text,vector color,float alpha)
{
    text=strip(text);

    string text2;
    integer len=llStringLength(text);

    if(len>250)
    {
        string line;
        list lines=llParseStringKeepNulls(text,["\n"],[]);

        text="";

        do
        {
            line=llList2String(lines,0)+"\n";
            if(llStringLength(line)+llStringLength(text)<(len/2))
            {
                text+=line;
                lines=llDeleteSubList(lines,0,0);
            }
            else
            {
                text2=llDumpList2String(lines,"\n");
                while(lines!=[])
                {
                    lines=llDeleteSubList(lines,0,0);
                    text+=" \n";
                }
            }
        }
        while(text2=="");
    }

    llSetLinkPrimitiveParamsFast(LINK_ROOT,
    [
        PRIM_TEXT,
            text,
            color,
            alpha,
        PRIM_LINK_TARGET,
            2,
        PRIM_TEXT,
            text2,
            color,
            alpha
    ]);
}

// Util Stuffs
string strReplace(string str, string search, string replace) {
    return llDumpList2String(llParseStringKeepNulls((str = "") + str, [search], []), replace);
}

integer isKey(key in)
{
    if (in) return TRUE;
    return (in == NULL_KEY);
}

list explode(string str)
{
    return llParseString2List(str, [" "], []);
}

string strip(string s)
{
    return llStringTrim(s, STRING_TRIM);
}

list split(string data, string sep)
{
    string name;
    string value;
    integer i;
    
    i = llSubStringIndex(data, sep);
    if (i > 0)
    {
        name = llGetSubString(data, 0, i - 1);
        name = strip(name);

        if (i != llStringLength(data) - 1)
        {
            value = llGetSubString(data, i + 1, -1);
            value = strip(value);
        } else {
            value = "";
        }
        
        return [ name, value ];
    }
    else
    {
        return [ data, "" ];
    }
}

string prep_string(string s)
{
    s = strReplace(s, "_slave_", llKey2Name(llGetOwner()));
    
    return s;
}

integer is_surl(string s)
{
    return (llGetSubString(s, 0, 27) == "http://slurl.com/secondlife/");
}

list surl_to_data(string s)
{    
    s = strReplace(s, "%20", " ");

    return llList2List(llParseString2List(s, [ "/" ], []), 3, 6);
}

save_goal()
{
    list l;
    list u;
    
    if (goal_name == "")
        return;
        
    if (goal_type == "")
        llOwnerSay("Goal " + goal_name + " on line " + (string)card_line + " has no type");
        
    if (goal_type == "waypoint")
    {
        //goal_args = strReplace(goal_args, "%20", " ");
        if (is_surl(goal_args))
        {
            l = llParseString2List(goal_args, [ ";" ], []);
            // u = llParseString2List(llList2String(l, 0), [ "/" ], []);
            u = surl_to_data(llList2String(l, 0));
            goal_args = 
                llList2String(u, 0) + ";<" +
                llList2String(u, 1) + "," +
                llList2String(u, 2) + "," +
                llList2String(u, 3) + ">;" +
                llDumpList2String(llList2List(l, 1, -1), ";");
        }
        
        // if (DEBUG) llOwnerSay("Waypoint Data: '" + goal_args + "'");
    }
    else if (goal_type == "timer")
    {
        integer i;
        
        l = llParseString2List(goal_args, [ ";", " " ], []);
        i = (integer)llList2String(l, 0);
        if (llList2String(l, 1) == "minutes" || llList2String(l, 1) == "minute")
        {
            i *= 60;
        }
        else if (llList2String(l, 1) == "hours" || llList2String(l, 1) == "hour")
        {
            i *= (60 * 60);
        }
        
        goal_args = (string)i;
    }
    
    goals += [ goal_name, goal_type, goal_args, 0 ];
    
    goal_name = "";
    goal_type = "";
    goal_args = "";
}


list get_goal(integer g)
{
    return llList2List(goals, g*4, (g*4)+3);
}

integer get_number_of_goals()
{
    return llGetListLength(goals) / 4;
}

integer check_waypoint(list args)
{
    vector v;
    
    if (llGetRegionName() != llList2String(args, 0))
        return FALSE;
    v = (vector)llList2String(args, 1);
    if (llVecDist(v, llGetPos()) > llList2Float(args, 2))
    {
        //if (DEBUG) llOwnerSay((string)llVecDist(v, llGetPos()) + 
        //    "( " + (string)v + ", " + (string)llGetPos() + ")" +
        //    " > " + (string)llList2Float(args, 2));
        return FALSE;
    }
        
    return TRUE;
}

update_goal_hovertext()
{
    integer num = get_number_of_goals();
    integer i;
    string o;
    list gdat;
    
    o = quest_name + "\n[ " + step_name + " ]\n \n";
    
    for (i = 0; i < num; i++)
    {
        gdat = get_goal(i);
        
        if (llList2Integer(gdat, 3))
            o += "[X] ";
        else
            o += "[ ] ";
        
        o += llList2String(gdat, 0) + "\n";
    }
    if (step_timer > 0)
    {
        integer left = step_timer - (llGetUnixTime() - step_started);
        integer i;
        
        o += "\nTime Left ";
        if (llAbs(i = left / (60*60)) > 0)
            o += (string)i + " hour(s).";
        else if (llAbs(i = left / (60)) > 0)
            o += (string)i + " minute(s).";
        else
            o += (string)left + " second(s).";
    }
    
    setText(o, <1,1,1>, 1);
}

integer check_timer(list args)
{
    return (llGetUnixTime() - step_started ) > (integer)llList2String(args, 0);
}

integer check_sit_target(list args)
{
    
    return ( (slave_sitting_on == (key)llList2String(args, 0) ) 
        ||   (slave_sitting_on_name == llList2String(args, 0) ) );
}

set_goal_finished(string name)
{
    integer i;
    
    i = llListFindList(goals, [ name ]);
    if (i == -1)
        return;
        
    goals = llListReplaceList(goals, [ TRUE ], i + 3, i + 3);
    
    llOwnerSay(name + " completed!");
    
    update_goal_hovertext();
}

integer check_goals()
{
    integer all_good = TRUE;
    integer i;
    integer result;
    integer num = get_number_of_goals();
    list gdat;
    list args;
    string type;
    
    for (i = 0; i < num; i++)
    {
        gdat = get_goal(i);
        result = FALSE;
        
        if (llList2Integer(gdat, 3) == TRUE)
        {
            result = TRUE;
        }
        else
        {
            type = llList2String(gdat, 1);
            args = llParseString2List(llList2String(gdat, 2), [ ";" ], []);
            
            if (type == "waypoint")
            {
                result = check_waypoint(args);
            }
            else if (type == "sit_target")
            {
                result = check_sit_target(args);
            }
            else if (type == "timer")
            {
                result = check_timer(args);
            }

            if(skipping)
            {
                result=TRUE;
            }
            
            if (result)
            {
                set_goal_finished(llList2String(gdat, 0));
            }
        }
        
        if (!result)
            all_good = FALSE;
    }
    
    return all_good;
}

list get_imcomplete_goals(key object)
{
    integer all_good = TRUE;
    integer i;
    integer num = get_number_of_goals();
    list gdat;
    list ig = [];
    
    for (i = 0; i < num; i++)
    {
        gdat = get_goal(i);
        
        if (llList2Integer(gdat, 3) == FALSE)
        {
            ig += [ llList2String(gdat, 0) ];
        }
    }
    
    return ig;
}

// Notecard stuff
notecard_next_line()
{
    card_line++;
    req_key = llGetNotecardLine(config_file, card_line);
    if(card_length!=0)
    {
        llRegionSay(TOUR_PROGRESS_CHANNEL,"progress|"+(string) (card_line*100/card_length));
    }
}

notecard_line(string line, integer fail_mode)
{
    integer i;
    list l;
    string name;
    string value;
    string value2;
    string s;
    integer id;
    integer x;
    integer y;
                    
    // Strip remarks...
    i = llSubStringIndex(line, "#");
    if (i > 0)
    {
        line = llGetSubString(line, 0, i - 1);
    }
    else if (i == 0)
    {
        // Entire line is a remark...
        return;
    }
            
    // Seperate name from value
    l = split(line, "=");
    name = strip(llToLower(llList2String(l, 0)));
    value = strip(llList2String(l, 1));
            
    if (name == "")
    {
        // Blank line or something?
        return;
    }
    
    // Searching for a failure?
    if (fail_mode)
    {
        if (name == "failure" && value == quest_fail_name)
        {
            found_failure = TRUE;
        }
        
        return;
    }
    
    // Quest Stuff
    if (name == "quest")
    {
        quest_name = value;
        
        return;
    }
    
    // 
    if (name == "quest password")
    {
        quest_password = value;
        
        return;
    }
    
    // 
    if (name == "failure option")
    {
        quest_fail_name = value;
        
        return;
    }
    
    // 
    if (name == "failure text")
    {
        if (quest_fail_text != "")
            quest_fail_text += "\n";
            
        quest_fail_text += value;
        
        return;
    }
    
    // Required version of quest engine
    if (name == "quest required version")
    {
        quest_version = (integer)value;
        
        return;
    }
    
    // 
    if (name == "quest text")
    {
        if (quest_text != "")
            quest_text += "\n";
            
        quest_text += value;
        
        return;
    }
    
    // End of quest data 
    if (name == "quest start")
    {
        quest_start_found = TRUE;
        return;
    }
    
    // No RLV commands until the user accepts the quests, sorry. :P
    if (!quest_accepted) return;
    
    // End of quest
    if (name == "quest end")
    {
        quest_end_found = TRUE;
        return;
    }

    // End of failure
    if (name == "failure end")
    {
        quest_failure_end_found = TRUE;
        return;
    }
    
    // Step Data
    if (name == "step")
    {
        step_name = value;
        
        return;
    }
    
    if (name == "step timer failure name")
    {
        step_timer_failure_name = value;
        
        return;
    }
    
    if (name == "step timer")
    {
        step_timer = (integer)value;
        
        return;
    }

    if (name == "step text")
    {
        if (step_text != "")
            step_text += "\n";
            
        step_text += value;
        
        return;
    }
    
    if (name == "step end")
    {
        save_goal();
        step_end_found = TRUE;
        return;
    }
    
    
    
    // Goal stuff
    // goal, goal type, goal args
    if (name == "goal")
    {
        save_goal();
        
        goal_name = value;
        
        return;
    }
    
    if (name == "goal type")
    {
        goal_type = value;
        
        return;
    }
    
    if (name == "goal args" || name == "goal arg")
    {
        if (goal_args != "")
            goal_args += ";";
            
        goal_args += value;
        
        return;
    }
    
    
    // Action stuff
    if (name == "action rlv clear")
    {
        llOwnerSay("@clear");
        // Lock the hud.
        if (!DEBUG) llOwnerSay("@detach=n");
        return;
    }
    
    if (name == "action rlv set")
    {
        llOwnerSay("@" + value);
        return;
    }
    
    if (name == "action rlv force")
    {
        llOwnerSay("@" + value);
        return;
    }
    
    if (name == "action rlv replace")
    {
        llOwnerSay("@clear");
        llOwnerSay("@" + value);
        return;
    }
    
    if (name == "action say")
    {
        llSay(0, prep_string(value));
        return;
    }
    
    if (name == "action whisper")
    {
        llWhisper(0, prep_string(value));
        return;
    }
    
    if (name == "action shout")
    {
        llShout(0, prep_string(value));
        return;
    }
    
    if (name == "action slave say")
    {
        llOwnerSay(prep_string(value));
        return;
    }
    
    if (name == "action teleport" || name == "action rlv teleport")
    {
        if (!is_surl(value))
        {
            llOwnerSay(value + " is not a SURL on line " + (string)card_line + ".");
            return;
        }
        
        teleport_surl = value;
        
        l = surl_to_data(value);
        
        teleport_query_id = llRequestSimulatorData(llList2String(l, 0), DATA_SIM_POS);
        
        return;
    }
    
    llOwnerSay("Unknown quest name " + name + " on line " + (string)card_line + ".");
}

send_response(string cmd, list args, string password, key k)
{
    list out;
    string hash;
    integer salt = (integer)llFrand(2000000000);
    
    hash = llMD5String(cmd + llDumpList2String(args, "!") + (string)llGetOwner() + password, salt);
    
    out = [ cmd ] + args + [ k, salt, hash ];
    
    llSay(interface_channel, llDumpList2String(out, "\n"));
}

quest_commands(string cmd, list args, integer salt, string hash, key source)
{
    integer i;

    if (hash != llMD5String(
        cmd + llDumpList2String(args, "!") + (string)source + quest_password,
        salt))
        return;
   
    if (cmd == "QUEST STATUS")
    {
        send_response("QUEST STATUS", [ quest_name, step_name ] +
            get_imcomplete_goals(source), quest_password, source);
    } 
    else if (cmd == "QUEST GOAL FINISHED")
    {
        set_goal_finished(llList2String(args, 0));
    }
    else if (cmd == "QUEST FAILED")
    {
    }
}

sys_commands(string cmd, list args, integer salt, string hash, key source)
{
    //This is pointless if this is open sourced.
    //This is replaced by having the quest HUD request permission from the submissive to start the quest.

    /*
    if (hash != llMD5String(
        cmd + llDumpList2String(args, "!") + (string)source + system_password,
        salt))
        return;
    */
    
    if (cmd == "SYS GIVE QUEST")
    {
        // If we already have a quest...
        if (quest_name != "")
        {
            llOwnerSay(llKey2Name(source) + 
                " tried to offer you quest a quest, but you are already on one.");
                
            send_response("NACK SYS GIVE QUEST", 
                [ "BUSY", llKey2Name(llGetOwner()) + " is already on a quest." ],
                no_password, source);
            
            return;
        }
        
        llOwnerSay(llKey2Name(source) + " owned by " +
            llKey2Name(llGetOwnerKey(source)) + " is giving you a quest.");
            
        config_file = llList2String(args, 0);
        quest_source = source;
        quest_version = -1;
        quest_accepted = FALSE;
        quest_text = "";
        quest_password = "";
        quest_fail_text = "";
        quest_fail_name = "";
    }
    else
    {
        send_response("NACK " + cmd, 
            [ "UNSUPPORTED", "This operation is not supported by this device." ],
            no_password, source);
    }
}

listen_handler(integer channel, string name, key id, string message)
{
    string cmd;
    list args;
    integer salt;
    string hash;
    key slave;
    
    if (channel == interface_channel)
    {
        args = llParseStringKeepNulls(message, [ "\n" ], []);
        cmd = llList2String(args, 0);
        hash = llList2String(args, -1);
        salt = (integer)llList2String(args, -2);
        slave = (key)llList2String(args, -3);
        args = llList2List(args, 1, -4);
        
        if (slave != llGetOwner())
            return;
        
        if ("QUEST " == llGetSubString(cmd, 0, 5))
            quest_commands(cmd, args, salt, hash, id);
        else if ("SYS " == llGetSubString(cmd, 0, 3))
            sys_commands(cmd, args, salt, hash, id);
    }
}

start_quest_dialog()
{
    llDialog(llGetOwner(),
        quest_name + "\n\n" + quest_text + "\n\n"
        ,
        [ "Accept", "Reject" ],
        dialog_channel);
}

// STATES
default
{
    state_entry()
    {
        llOwnerSay("@clear");
        llListen(999999, "", llGetOwner(), "");
        llOwnerSay("@versionnum=999999");
        setText("Checking for RLV", <1,1,0>, 1);
        llRegionSay(TOUR_PROGRESS_CHANNEL,"abort");
    }
    
    listen(integer channel, string name, key id, string message)
    {   
        if ((integer)message > 0)
            state ready;
    }
}

state ready
{
    on_rez(integer x)
    {
        llResetScript();
    }

    state_entry()
    {
        config_file = "";
        llListen(interface_channel, "", "", "");
        setText("Touch me to start the Tour!", <0,1,0>, 1);
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if(message=="ping")
        {
            llRegionSayTo(id,channel,"pong");
            return;
        }

        listen_handler(channel, name, id, message);
        if (config_file != "")
            state get_quest;
    }

    touch_start(integer x)
    {
        llRegionSay(interface_channel,"pong");
    }
}

state get_quest
{
    state_entry()
    {
        setText("Recieving Quest...", <1,0,0>, 1);
        //llOwnerSay("Starting Quest...");
        quest_name = "";
        quest_text = "";
        card_line = 0;
        step_number = 0;
        state load_quest_step;
    }
}

state quest_start_prompt
{
    state_entry()
    {
        if (quest_version == -1)
        {
            llOwnerSay("Quest version not set in quest, please contact " + 
                llKey2Name(llGetOwnerKey(quest_source)) + "\n");
            llResetScript();
        }
        else if (quest_version > supported_quest_version)
        {
            llOwnerSay("This quest requires a later version of the HUD. Please check the SlaveQuest HQ for updates!");
            llResetScript();
        }
        
        setText("Accept Quest?", <1,1,0>, 1);
        //llOwnerSay("Starting Quest...");
        
        llListen(dialog_channel, "", llGetOwner(), "");
        
        llOwnerSay("\nQuest: " + quest_name + "\n\n" + quest_text);
        
        start_quest_dialog();
    }
    
    touch_start(integer num_detected)
    {
        start_quest_dialog();
    }
    
    listen(integer channel, string name, key id, string message)
    {
        // we don't handle other listen events in this state because we are lame.
        if (channel != dialog_channel || id != llGetOwner()) return;
        
        if (message == "Accept")
        {
            quest_accepted = TRUE;
            llRegionSay(TOUR_PROGRESS_CHANNEL,"start");
            llResetTime();
            
            llOwnerSay("Accepted quest " + quest_name + ", loaidng...");
            
            // Lock the hud.
            if (!DEBUG) llOwnerSay("@detach=n");
            
            setText("Loading Quest...", <1,0,0>, 1);
            state load_quest_step;
        }
        else
        {
            llOwnerSay("Quest Rejected.");

            llResetScript();
        }
    }
}

state quest_step
{
    state_entry()
    {
        step_number++;
        
        llDialog(llGetOwner(),
            quest_name + ": " + step_name + "\n\n" + step_text,
            [],
            -542349834);

        llOwnerSay("\nQuest Step: " + step_name + "\n\n" + step_text);
        
        step_started = llGetUnixTime();
        slave_bounding_box = llGetBoundingBox(llGetOwner());
        feedback_channel = (1000000) + (integer)llFrand(1000000000);
        llListen(feedback_channel, "", llGetOwner(), "");
        llListen(interface_channel, "", "", "");
        slave_sitting_on = NULL_KEY;
        slave_sitting_on_name = "";
        
        llSetTimerEvent(check_goals_interval);
        
        update_goal_hovertext();
        
        llListen(dialog_channel, "", llGetOwner(), "");
    }
    
    timer()
    {
        // Sat or got up...
        if (llListFindList(slave_bounding_box, llGetBoundingBox(llGetOwner())) == -1)
        {
            llOwnerSay("@getsitid=" + (string)feedback_channel); 
        }
        
        if (step_timer > 0)
        {
            integer left = step_timer - (llGetUnixTime() - step_started);
            if (left <= 0)
            {
                llOwnerSay("You have run out of time!");
                quest_fail_name = step_timer_failure_name;
                state skip_to_failure;
            }
            
            update_goal_hovertext();
        }

        if (check_goals())
        {
            skipping=FALSE;
            llSetTimerEvent(0);
            llOwnerSay("You have completed " + step_name);
            
            setText("Loading Step...", <1,0,0>, 1);
            state load_quest_step;
        }
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if (channel == dialog_channel)
        {
            if (message == "Fail")
            {
                llDialog(llGetOwner(),
                    quest_fail_text + "\n\nAccept Failure?"
                    ,
                    [ "Yes", "No" ],
                    dialog_channel);
            }
            else if (message == "Safeword")
            {
                llOwnerSay("@clear");
                llSay(0, llKey2Name(llGetOwner()) + 
                    " has SAFEWORDED! Please check if they need assistance.");
                llResetScript();
            }
            else if (message == "Skip" )
            {
                skipping=TRUE;
            }
            else if (message == "Yes") // FAILURE!
            {
                state skip_to_failure;
            }
            
            return;
        }
        
        if (channel == feedback_channel && isKey((key)message))
        {
            slave_sitting_on = (key)message;
            slave_sitting_on_name = llKey2Name(slave_sitting_on);
            return;
        }

        listen_handler(channel, name, id, message);
    }
    
    touch_start(integer num_detected)
    {
        list buttons = [ "Safeword" ];

        if(llKey2Name(llGetOwner())=="Toy Wylie")
            buttons += [ "Skip" ];

        if (quest_fail_name != "")
            buttons += [ "Fail" ];
        
        llDialog(llGetOwner(),
            "You are on the quest:\n" + quest_name + "\n\n" +
            "Safeword - Abort the quest!\n" + 
            "Fail - Accept the failure, if avalible."
            ,
            buttons,
            dialog_channel);
    }
    
    attach(key id)
    {
        if (id == NULL_KEY)
        {
            llOwnerSay("@clear");
            llResetScript();
        }
    }
}

state end_quest
{
    state_entry()
    {
        setText("", <1,0,0>, 1);
        llOwnerSay("Quest Complete...");
        llRegionSay(TOUR_PROGRESS_CHANNEL,"complete|"+(string) ((integer) llGetTime()));
        llResetScript();
    }
}

state end_failure
{
    state_entry()
    {
        llOwnerSay("Quest Failed...");
        llResetScript();
    }
}

state load_quest_step
{
    state_entry()
    {
        teleport_query_id = NULL_KEY;
        
        step_name = "";
        step_text = "";
        step_timer = 0; // No timer
        step_timer_failure_name = "";
        step_end_found = FALSE;
        quest_start_found = FALSE;
        quest_end_found = FALSE;
        quest_failure_end_found = FALSE;

        goals = [];
        
        goal_name = "";
        goal_type = "";
        goal_args = "";

        req_key = llGetNotecardLine(config_file, card_line);

        if(card_length==0)
        {
            length_key=llGetNumberOfNotecardLines(config_file);
        }

        llSetTimerEvent(5);
    }
    
    dataserver(key query_id, string data)
    {
        integer i;
        
        if (req_key == query_id)
        {
            llSetTimerEvent(0);
            
            if (data != EOF)
            {
                notecard_line(data, FALSE);
                if (teleport_query_id == NULL_KEY)
                    notecard_next_line();
                if (quest_start_found)
                    state quest_start_prompt;
                if (step_end_found)
                    state quest_step;
                if (quest_end_found)
                    state end_quest;
                if (quest_failure_end_found)
                    state end_failure;
            } else {
                if (!quest_accepted)
                {
                    llOwnerSay("'quest start' not found. Maybe this is a pre-Beta 3 quest?");
                    llResetScript();
                }
                else
                {
                    llOwnerSay("Quest didn't have an 'quest end' or 'failure end': Please report to " + llKey2Name(llGetOwnerKey(quest_source)));
                }
                                
                state end_quest;
            }
        }
        else if (teleport_query_id == query_id)
        {
            setText("Teleporting...", <1,0,0>, 1);
            llOwnerSay("Teleporting you to: " + teleport_surl);
            
              // Parse the dataserver response (it is a vector cast to a string)
              list tokens = llParseString2List (data, ["<", ",", ">"], []);
              string pos_str = "";
              vector global_pos;
              vector vLocalPos;
              list l;
              
              // Setup the local pos...
              l = surl_to_data(teleport_surl);
              vLocalPos.x = (float)llList2String(l, 1);
              vLocalPos.y = (float)llList2String(l, 2);
              vLocalPos.z = (float)llList2String(l, 3);
         
              // The coordinates given by the dataserver are the ones of the
              // South-West corner of this sim
              // => offset with the specified local coordinates
              global_pos.x = llList2Float (tokens, 0);
              global_pos.y = llList2Float (tokens, 1);
              global_pos.z = llList2Float (tokens, 2);
              global_pos += vLocalPos;
         
              // Build the command
              pos_str =      (string)((integer)global_pos.x)
                        +"/"+(string)((integer)global_pos.y)
                        +"/"+(string)((integer)global_pos.z);
              // llOwnerSay ("Global position : "+(string)pos_str); // Debug purposes
         
              // Fire !
              llOwnerSay ("@tpto:"+pos_str+"=force");
            
            // Resume card...
            if (llList2String(l, 0) == llGetRegionName())
            {
                setText("Loading...", <1,0,0>, 1);
                teleport_query_id = NULL_KEY;
                notecard_next_line();
            }
        }
        else if(length_key==query_id)
        {
            card_length=(integer) data;
        }
    }
    
    changed(integer change)
    {
        if (change & CHANGED_REGION && teleport_query_id != NULL_KEY)
        {
            setText("Loading...", <1,0,0>, 1);
            teleport_query_id = NULL_KEY;
            notecard_next_line();
        }
    }
    
    timer()
    {
        llOwnerSay("Error opening quest \"" + config_file + "\" notecard.");
        llResetScript();
    }
    
    state_exit()
    {
        llSetTimerEvent(0);
    }
}

state skip_to_failure
{
    state_entry()
    {
        setText("Skipping to Failure...", <1,0,0>, 1);
        
        found_failure = FALSE;
        
        req_key = llGetNotecardLine(config_file, card_line);
        llSetTimerEvent(5);
    }
    
    dataserver(key query_id, string data)
    {
        integer i;
        
        if (req_key == query_id)
        {
            llSetTimerEvent(0);
            
            if (data != EOF)
            {
                notecard_line(data, TRUE);
                notecard_next_line();
                
                if (found_failure)
                {
                    setText("Loading...", <1,0,0>, 1);
                    state load_quest_step;
                }
            }
            else
            {
                llOwnerSay("Quest didn't have an 'failure = " + quest_fail_name + 
                    "': Please report to " + llKey2Name(llGetOwnerKey(quest_source)));
                                
                state end_quest;
            }
        }
    }
        
    timer()
    {
        llOwnerSay("Error opening quest \"" + config_file + "\" notecard.");
        llResetScript();
    }
    
    state_exit()
    {
        llSetTimerEvent(0);
    }
}

