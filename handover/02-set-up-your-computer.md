# 2. Set up your computer (one time, Windows)

Do the steps in order. Each step ends with what you should see, so you know it worked.
About one hour, mostly waiting for downloads. You need your laptop, your phone, your Claude
login, and the Apple key Luke sent you on WhatsApp (a small file ending in `.p8` plus two
codes). Save those three things somewhere safe on your laptop before you start.

---

## Step 1. Install Git

1. Go to **https://git-scm.com/download/win**
2. Click **Click here to download**. Open the downloaded file.
3. Click **Next** on every page. Then **Install**, then **Finish**.

You should see: the installer closes. Nothing else opens.

---

## Step 2. Make a GitHub account

1. Go to **https://github.com** and click **Sign up**.
2. Use your email, choose a password and a username. Confirm the email GitHub sends you.

You should see: your username in the top right corner of the GitHub page.

---

## Step 3. Take your own copy of the app (called a "fork")

1. Go to **https://github.com/lukehartsink-stack/simonsays-app**
2. Click the **Fork** button near the top right.
3. Click the green **Create fork** button.

You should see: a page called **your-username/simonsays-app**. This copy is yours. Nobody
else can change it. Everything from now on uses your copy.

---

## Step 4. Install GitHub Desktop and get the folder onto your laptop

1. Go to **https://desktop.github.com** and click **Download for Windows**. Open the file.
2. GitHub Desktop opens. Click **Sign in to GitHub.com**. Your browser opens. Sign in,
   click **Authorize**. Back in GitHub Desktop, click **Finish**.
3. Click **File**, then **Clone repository**.
4. Click the **GitHub.com** tab. Click **your-username/simonsays-app** (your copy from
   Step 3, not the lukehartsink one).
5. Look at **Local path**. That is where the folder will go. Remember it. It is usually
   `C:\Users\<you>\Documents\GitHub\simonsays-app`.
6. Click **Clone**.
7. If it asks "How are you planning to use this fork?", choose **For my own purposes**.

You should see: GitHub Desktop says **simonsays-app** at the top. The folder exists on your
laptop.

---

## Step 5. Install Node

1. Go to **https://nodejs.org** and click the big green **LTS** button. Open the file.
2. Click **Next** on every page, tick the licence box, click **Install**, then **Finish**.

You should see: the installer closes.

---

## Step 6. Install Visual Studio Code

1. Go to **https://code.visualstudio.com** and click **Download for Windows**. Open the file.
2. Click **Next** on every page. Tick **Create a desktop icon**. Click **Install**, then
   **Finish**.

You should see: a dark window with File, Edit, Selection in the top menu.

---

## Step 7. Open the app folder in VS Code

1. Click **File**, then **Open Folder...**
2. Find the `simonsays-app` folder from Step 4. Click it once. Click **Select Folder**.
3. If it asks "Do you trust the authors?", click **Yes, I trust the authors**.

You should see: a list on the left with `CLAUDE.md`, `handover`, `SimonSays`, `tools`.
VS Code remembers this folder and opens it next time by itself.

---

## Step 8. Install Claude Code

1. Click **View**, then **Terminal**. A black box appears at the bottom. You type in there.
2. Click in the black box. Paste this line and press **Enter**:

   ```
   irm https://claude.ai/install.ps1 | iex
   ```

3. Wait until the text stops and says it is installed.
4. Close VS Code completely. Open it again from the desktop icon.

You should see: the same folder list on the left.

---

## Step 9. Start Claude and log in

1. Click **View**, then **Terminal**.
2. Type `claude` and press **Enter**.
3. First time only: press **Enter** to accept the theme. Choose **Claude account with
   subscription**. Your browser opens. Log in with your normal Claude login. Click
   **Authorize**. Go back to VS Code.
4. Type this and press **Enter**:

   > Explain what this app is and how I update it.

You should see: Claude answers in plain words and mentions sync, change, ship. It has read
the instructions in the folder.

To stop Claude: type `/exit` and press **Enter**. To start again: type `claude`.

---

## Step 10. Check the sync

1. If Claude is running, type `/exit`. Then type this and press **Enter**:

   ```
   node tools/sync-content.js
   ```

You should see: eight lines ending in "no change" or "updated", then "Everything already up
to date" or "N file(s) updated". Either is fine.

---

## Step 11. Connect Codemagic (the robot that builds the app)

**Add the app**

1. Go to **https://codemagic.io** and log in.
2. Click **Add application**. Choose **GitHub**. If it asks to connect GitHub, click
   **Connect** and authorize. Use the account from Step 2.
3. Pick **simonsays-app** (your copy). If it is not listed, click the link to install the
   Codemagic GitHub app, tick **simonsays-app**, and come back.
4. Project type: **iOS App**. Click **Finish**.

You should see: **simonsays-app** on your Codemagic dashboard.

**Add the Apple key** (the `.p8` file and two codes from Luke)

1. Click **Teams** in the left menu, then your team.
2. Click **Integrations**. Next to **Developer Portal** click **Manage keys** (or
   **Connect**).
3. Click **Add key** and fill in:
   - Name: `AutoBook ASC Admin` (type it exactly like this)
   - Issuer ID: the first code
   - Key ID: the second code
   - API key: click **Upload** and pick the `.p8` file
4. Click **Save**.

You should see: "AutoBook ASC Admin" in the list.

**Run one test build**

1. On the dashboard click **simonsays-app**, then **Start new build**.
2. Branch: **main**. Workflow: **iOS → TestFlight**. Click **Start new build**.
3. Wait five to ten minutes.

You should see: every step green, and "Publishing" says the build went to App Store Connect.
If a step is red, click it, copy the red text, and paste it into Claude in VS Code with the
words "fix this build error". Then start a new build. That is the normal way to fix builds.

From now on, every time you ship a change (chapter 3), Codemagic starts a build by itself.

---

## Step 12. Get the app on your phone

Two of your emails are invited as testers: `nucleondh@gmail.com` (already accepted) and
`training@simonsays.coach` (invite sent, waiting for you to accept).

1. On your iPhone open **Settings** and tap your name at the top. The email under your name
   is your Apple ID.
2. If it is `nucleondh@gmail.com`: open the **TestFlight** app. The app is there.
3. If it is `training@simonsays.coach`: find the email from TestFlight in that inbox and tap
   **View in TestFlight**. Then open the TestFlight app.
4. If it is a different email: sign out of the App Store (Settings, your name, Media &
   Purchases, Sign Out) and sign in with `nucleondh@gmail.com`, then open TestFlight.

You should see: **simonsays.coach** in TestFlight with an **Install** or **Update** button.

---

## Done

From now on the only things you do are in chapter 3: open VS Code, type `claude`, and say
what you want.
