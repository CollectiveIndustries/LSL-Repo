integer MilkyWay_API_CHAN = -904000;
integer Pegasus_API_CHAN = -804000;
integer SoundChan = -26;

default
{
    state_entry()
    {
        integer count = 0;
        integer seconds = 29;
        while(count < 1800)
        {
            seconds = 29;
            llSetText("EMP: "+(string)seconds+" Sec\nEMP TIME: "+(string)(1800-count),<1,1,1>,1.0);
            llSay(Pegasus_API_CHAN,"stargate emp");
            llRegionSay(SoundChan, "sound:2978a1df-04aa-0315-e890-5776e4a30f59");
            while(seconds > 0)
            {
                llSleep(1.0);
                seconds = seconds - 1;
                llSetText("EMP: "+(string)seconds+" Sec\nEMP TIME: "+(string)(1800-count),<1,1,1>,1.0);
            }
            count = count + 29;
        }
    }
}