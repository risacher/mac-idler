# mac-idler

Simple replacement for the macos screen saver function for situations
where an application prevents the builtin from working (such as OBS)

Usage: mac-idler <seconds-to-consider-idle> [-start <hour-to-start>] [-end <hour-to-stop>]

Example: mac-idler 900 -start 21 -end 07

Suspends diplays if no keyboard or mouse input for last 15 minutes between 9PM and 7AM.

Main Problem: I leave OBS running on my Mac with the virtual camera
turned on.  Since OBS considers this "streaming", it disables the Mac
screen saver.  The computer is in my bedroom, it means that sometimes
I crawl into bed and the screen is still on, and its bright enough to
distrupt my sleep.  What I want is for the displays to be suspended if
there is no user input for some time, *even if OBS is running the
virtual camera*.

Secondary problem: I use OBS during the day on this computer for video
conferencing, and sometimes that means I'm using the computer, but I'm
not touching the keyboard or mouse for extended periods.  What I want,
then is for the displays to be suspended on idle, *only after
"bedtime"*.


