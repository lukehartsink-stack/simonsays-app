# 6. When things go wrong

## The build fails in Codemagic

1. Open the failed build in codemagic.io. Find the step that turned red.
2. Copy the red error text (a few lines around the word "error" is enough).
3. Paste it into Claude Code and say: "Fix this build error."
4. Claude fixes the Swift, ships it, and asks you to start a new build.

Two or three rounds of this are normal for a bigger change, because nothing compiles on
this computer before Codemagic sees it.

## The build succeeds but TestFlight shows nothing

- Wait ten minutes. Apple processes builds after Codemagic uploads them.
- Check which Apple ID TestFlight on your phone is signed in with. It must match the tester
  email (`nucleondh@gmail.com` or `training@simonsays.coach`).
- Check the build in App Store Connect under TestFlight. If it says "Missing Compliance",
  say to Claude Code "the build says Missing Compliance" and it will fix the setting.

## The app shows old content

Run the sync again (chapter 3, step 1), then ship and build. If the sync says "no change"
but the website has the new content, the website file may have changed shape. Say to Claude
Code: "The sync says no change but the FAQ on the website has a new question." It will look
at the website file and fix the sync script.

## The sync script fails

- "FAILED: ... HTTP 404": a file on the website moved. Tell Claude Code the new address if
  you know it, or say "the FAQ file moved" and it will find it.
- "Could not find window.FAQ_DATA" (or a similar name): the website file changed format.
  Say "fix the sync script" and paste the message.

## Claude Code cannot find the folder or says it is not a Git repository

You opened the terminal somewhere else. In VS Code, use **File, Open Folder** and pick the
`simonsays-app` folder, then open the terminal again.

## Claude Code says "conflict" when shipping

Someone else changed the same file at the same time. Say "explain the conflict in plain
words" and tell Claude which version to keep. Never say "force push".

## Something looks wrong on a screen

Take a screenshot on your phone, describe what is wrong, and tell Claude Code which screen.
For example: "In the Defect Diagnoser the answer buttons overlap in dark mode." It knows
which file each screen lives in (chapter 7).

## You want to undo a change

Say "undo the last change" before shipping and Claude restores the file. After shipping, say
"revert the last commit" and ship again.
