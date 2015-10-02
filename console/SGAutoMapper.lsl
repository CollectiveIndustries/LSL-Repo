//  automap.lsl: OpenGate automap code
//  Copyright (C) 2007 Adam Wozniak
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//
//  Adam Wozniak
//  1352 Fourteenth St, Los Osos, CA 93402
//  adam-opengate@cuddlepuddle.org

// This script was loosely based on the original works of
// Peter Lameth and Kegan Loon.

// Thanks to Zachary Carter for his interest in making sure
// the Open Gate Network would interoperate with other networks.

// This is probably a good place for me to give a cautionary tale.  This one
// small piece of code has given me more trouble than any other, not because
// it was hard to write, but because I violated my own "clean room" policy
// and accepted a script given to me by another player.

// The script I accepted was short and simple, but had a few problems.
// It did not have any copyright notices, and was given to me with full
// mod permissions by someone who was very familiar with the Open Gate
// project, and fully understood my intentions. Once I realized my mistake
// of accepting code, I trashed what I had and rewrote it, correcting the
// problems I had found, and adding functionality.  The original script I
// saw had a bug in its llListen call(), was missing the double
// llMapDestination() workaround, and used ZERO_VECTOR for the lookat
// parameter to llMapDestination().

// Unfortunately, my rewrites and improvements notwithstanding, the
// basic idea encapsulated in this piece of code is so simple that there
// really just aren't that many ways to do it.  When word of this code's
// existance got back to the authors of the original code, they saw my
// code and were understandably upset.

// For my part I did not know that the person who gave me that script
// was not the original author, and I used it in good faith as I might
// use any other piece of example code.

// I of course apolgize profusely for the hard feelings that ensued.
// Thankfully everyone involved was able to keep a cool head and carry
// on a rational discussion, and we eventually reached an agreement that
// would allow me to put an open source license on this piece of code.

// So the moral of the story, I think, is to keep yourself clear of any
// misunderstandings about the origin of the code.  Whenever possible,
// maintain a "clean room" policy with regard to projects you intend to
// release open source.

// Now that I've written 30 lines of comment, I now present 30 lines
// of code...

key owner = NULL_KEY;
integer listen_channel = -900000;
string listen_name = "_Event Horizon";

default {
   state_entry() {
      owner = llGetOwner();
      llListen(listen_channel, listen_name, NULL_KEY, "");
   }
   changed(integer change)
   {
       llResetScript();
   }

   on_rez(integer start_param) {
      llResetScript();
   }

   listen(integer channel, string name, key id, string message) {
      list parse = llParseString2List(message, ["|"] ,[]);
      if(llList2String(parse, 0) == "map") {
         key k = (key) llList2String(parse, 1);
         if(k == owner) {
            string region = llList2String(parse, 2);
            vector pos = (vector)llList2String(parse, 3);
            vector lookat = pos;
            if (llGetListLength(parse) > 4) {
               lookat = pos + llRot2Fwd((rotation) llList2String(parse,4));
            }
            llMapDestination(region, pos, lookat);
            llMapDestination(region, pos, lookat); // workaround SL bug
         }
      }
   }
}