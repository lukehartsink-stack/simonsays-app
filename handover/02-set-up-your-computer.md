# 2. Set up your computer (one time, Windows)

Do these in order. Tick each one off. Every step tells you what you should see on the
screen, so you know it worked. It takes about an hour, mostly waiting for downloads.

You need: your Windows laptop, your phone, and your Claude login.

---

## Step 1. Install Git

Git is the thing that keeps the app files the same on your computer and on the internet.

1. Open your web browser.
2. Go to: **https://git-scm.com/download/win**
3. Click the link that says **Click here to download**. A file downloads.
4. Open the downloaded file.
5. A window with lots of pages opens. On every page just click **Next**. Do not change
   anything. At the end click **Install**, then **Finish**.

**You should see:** the installer window closes. Nothing else opens. That is fine.

---

## Step 2. Make a GitHub account and tell Luke your username

GitHub is the website where the app files are stored.

1. Go to: **https://github.com**
2. Click **Sign up**. Use your email, pick a password, pick a username.
   Write the username down.
3. Confirm your email when GitHub asks.
4. **Send Luke a message with your GitHub username.** Luke needs it to give you access.
   Wait for Luke to say "done" before Step 4.

**You should see:** GitHub shows you a page with your username in the top right corner.

---

## Step 3. Install GitHub Desktop

GitHub Desktop is a small program that copies the app folder to your computer and remembers
your GitHub login so you never type it again.

1. Go to: **https://desktop.github.com**
2. Click **Download for Windows**. Open the downloaded file. It installs itself.
3. GitHub Desktop opens. Click **Sign in to GitHub.com**.
4. Your browser opens. Sign in with the account from Step 2. Click **Authorize** if it asks.
5. Back in GitHub Desktop, click **Finish**.

**You should see:** GitHub Desktop with a mostly empty window and your name in it.

---

## Step 4. Copy the app folder to your computer

Wait for Luke to confirm he has added you (Step 2) before doing this.

1. Check your email. There is an invitation from GitHub to "simonsays-app". Click
   **View invitation**, then **Accept invitation**.
2. Open GitHub Desktop.
3. Click **File** (top left), then **Clone repository**.
4. Click the tab **GitHub.com**. In the list, click **lukehartsink-stack/simonsays-app**.
5. Under **Local path** it says where the folder will go. Leave it as it is. Write the path
   down. It is usually something like `C:\Users\Simon\Documents\GitHub\simonsays-app`.
6. Click **Clone**.

**You should see:** a progress bar, then GitHub Desktop says "simonsays-app" at the top.
A folder called `simonsays-app` now exists in the place from point 5.

---

## Step 5. Install Node

Node runs the little script that copies website content into the app.

1. Go to: **https://nodejs.org**
2. Click the big green button that says **LTS** (it also shows a version number).
3. Open the downloaded file. Click **Next** on every page, tick the licence box when it
   asks, click **Install**, then **Finish**.

**You should see:** the installer closes. Nothing else opens.

---

## Step 6. Install Visual Studio Code

VS Code is the window you will work in. Think of it as a notepad with a chat built in.

1. Go to: **https://code.visualstudio.com**
2. Click **Download for Windows**. Open the downloaded file.
3. Click **Next** on every page. On the page with tick boxes, tick **Add to PATH** and
   **Create a desktop icon** if they are not ticked. Click **Install**, then **Finish**.
4. VS Code opens. Close the welcome tab if it shows one.

**You should see:** a dark window with a menu bar at the top saying File, Edit, Selection...

---

## Step 7. Open the app folder in VS Code

1. In VS Code, click **File** (top left), then **Open Folder...**
2. Find the `simonsays-app` folder from Step 4. Click it once, then click **Select Folder**.
3. If VS Code asks "Do you trust the authors of the files in this folder?", click
   **Yes, I trust the authors**.

**You should see:** on the left side, a list of files and folders. Among them:
`CLAUDE.md`, `handover`, `SimonSays`, `tools`. If you see those, you are in the right place.

VS Code remembers this folder. Next time you open VS Code it opens here by itself.

---

## Step 8. Install Claude Code

This is Claude, but living inside the folder so it can read and change the files.

1. In VS Code, click **View** (top menu), then **Terminal**. A black box appears at the
   bottom of the window. That is the terminal. You type commands in it.
2. Click inside the black box. Copy this line exactly and paste it in, then press **Enter**:

   ```
   irm https://claude.ai/install.ps1 | iex
   ```

3. Text scrolls by for a minute. Wait until it stops and says something like
   "Claude Code installed" or "Installation complete".
4. Close VS Code completely (click the X top right). Open it again from the desktop icon.
   It opens on the app folder again.

**You should see:** after reopening, the folder list on the left is still there.

---

## Step 9. Start Claude and log in

1. In VS Code, click **View**, then **Terminal** (the black box comes back).
2. Type this and press **Enter**:

   ```
   claude
   ```

3. The first time it asks you to choose a theme. Press **Enter**.
4. It asks how you want to log in. Choose **Claude account with subscription**. Your
   browser opens. Log in with your normal Claude login. Click **Authorize**.
5. Go back to VS Code. Claude is waiting for you with a `>` prompt.
6. Type this and press **Enter**:

   > Explain what this app is and how I update it.

**You should see:** Claude answers in plain words and mentions three steps: sync, change,
ship. That means Claude has read the instructions in the folder and knows the app.

To stop Claude, type `/exit` and press **Enter**. To come back, type `claude` again.

---

## Step 10. Check that the sync works

1. In the terminal (if Claude is running, type `/exit` first), type this and press
   **Enter**:

   ```
   node tools/sync-content.js
   ```

**You should see:** eight lines, one per file, each ending with "no change" or "updated".
Then a line saying "Everything already up to date" or "N file(s) updated".

If it says "updated" for any file, do not worry. It means the website has newer content than
the app. Chapter 3 tells you what to do with that.

---

## Step 11. Codemagic (the robot that builds the app)

You already made a Codemagic account. Now connect it to the app folder on GitHub.

1. Go to: **https://codemagic.io** and log in.
2. Click **Add application** (a blue button).
3. Choose **GitHub**. If it asks to connect your GitHub account, click **Connect** and
   authorize it in the browser. This is the same GitHub account from Step 2.
4. In the list of repositories, pick **simonsays-app**. If it is not in the list, click the
   link to install the Codemagic GitHub app and tick **simonsays-app**, then come back.
5. When it asks the project type, choose **iOS App** (or "Other", either works).
6. Click **Finish**.

**You should see:** an app called **simonsays-app** on your Codemagic dashboard. Codemagic
finds the build recipe (`codemagic.yaml`) in the folder by itself.

**Then the Apple key.** Codemagic needs a key from Apple to sign the app. Luke will send you
this key privately (a small file ending in `.p8`, plus two codes called Issuer ID and Key ID).
Do not put the key in the app folder, and do not email it around. When you have it:

1. In Codemagic, click **Teams** (left menu), then your team name.
2. Click **Integrations**, then next to **Developer Portal** click **Manage keys** (or
   **Connect**).
3. Click **Add key**. Fill in:
   - **App Store Connect API key name:** `AutoBook ASC Admin` (exactly this, it must
     match the recipe)
   - **Issuer ID:** paste the code Luke sent
   - **Key ID:** paste the code Luke sent
   - **API key:** click Upload and pick the `.p8` file Luke sent
4. Click **Save**.

**You should see:** "AutoBook ASC Admin" in the list of keys.

**Then a test build.** On the Codemagic dashboard click **simonsays-app**, then
**Start new build**. Pick branch **main** and workflow **iOS → TestFlight**. Click **Start
new build**. It takes five to ten minutes. If every step turns green, you are done. If
something turns red, copy the red text and send it to Luke this first time.

From now on, every time you "ship" a change (chapter 3), Codemagic starts a build by
itself. You only open Codemagic to watch it or if something fails.

---

## Step 12. Tell Luke which Apple ID your phone uses

TestFlight only shows the app to the Apple ID that was invited. Two emails were invited:
`nucleondh@gmail.com` and `training@simonsays.coach`. Luke needs to know which one your
phone is signed in with.

1. On your iPhone open **Settings**.
2. Tap your name at the very top.
3. Under your name is an email address. That is your Apple ID.
4. **Send that email address to Luke.** If it is neither of the two above, tell Luke and he
   will invite the right one.

**You should see:** after Luke confirms, the TestFlight app on your phone shows
"simonsays.coach" with an Install or Update button.

---

## Done

You now have everything. From here on, the only things you ever do are in chapter 3:
open VS Code, type `claude`, and talk to it.
