# Push Updated Theme to Master Branch

## Commands to Push to Master Branch

### Step 1: Check Current Status
```bash
cd /Users/parasana/Downloads/CascadeProjects/windsurf-project
git status
```

### Step 2: Stage the Updated Files (Dark Orange Theme)
```bash
git add index.html
```

### Step 3: Commit the Changes
```bash
git commit -m "Update theme: Changed to dark orange theme"
```

### Step 4: Create and Switch to Master Branch
```bash
git checkout -b master
```
**What this does:** Creates a new branch called `master` and switches to it.

### Step 5: Push to Master Branch on GitHub
```bash
git push -u origin master
```
**What this does:** Pushes your master branch to GitHub and sets up tracking.

---

## Alternative: If You Want to Push from Current Branch

If you're already on main and want to push the changes there first:

```bash
# Stage changes
git add index.html

# Commit changes
git commit -m "Update theme: Changed to dark orange theme"

# Push to main
git push origin main

# Create master branch from current state
git checkout -b master

# Push master branch
git push -u origin master
```

---

## GitHub Setup Guide

### Option A: Set Master as Default Branch (Recommended for Testing CI)

1. **Go to your GitHub repository** in your browser
2. Click on **"Settings"** tab (top right of the repo page)
3. In the left sidebar, click **"Branches"**
4. Under "Default branch", click the **switch icon** or **pencil icon**
5. Select **"master"** from the dropdown
6. Click **"Update"** or **"I understand, update the default branch"**
7. Confirm the change

**Why do this?** The CI pipeline is configured to run on pushes to `main`, `master`, or `develop` branches.

---

### Option B: Keep Both Branches and Test CI on Both

You don't need to change the default branch. The CI will run on both:
- Pushes to `main` branch
- Pushes to `master` branch

Just push to master and the CI will trigger automatically!

---

## Verify CI Pipeline is Running

### After Pushing to Master:

1. Go to your GitHub repository
2. Click the **"Actions"** tab
3. You should see a new workflow run for the `master` branch
4. Click on the workflow to see details
5. Watch the jobs run:
   - **build-and-test** (on Node 18.x and 20.x)
   - **lint**

---

## View Different Branches on GitHub

1. On your repository page, click the **branch dropdown** (shows "main" or "master")
2. You'll see all branches: `main` and `master`
3. Click on any branch to view its code
4. Each branch will show its own CI status badge

---

## Compare Branches on GitHub

To see the difference between main and master:

1. Go to your repository
2. Click **"Compare"** (or go to: `https://github.com/YOUR_USERNAME/REPO_NAME/compare`)
3. Select: `main...master`
4. You'll see all the changes (the theme update)

---

## Useful Commands After Pushing

### Switch back to main branch:
```bash
git checkout main
```

### Switch to master branch:
```bash
git checkout master
```

### See all branches:
```bash
git branch -a
```

### See which branch you're on:
```bash
git branch
```

### Pull latest changes from master:
```bash
git checkout master
git pull origin master
```

### Delete master branch locally (if needed later):
```bash
git branch -d master
```

### Delete master branch on GitHub (if needed later):
```bash
git push origin --delete master
```

---

## Expected CI Pipeline Results

When you push to master, the CI will:

✅ **Build & Test Job:**
- Checkout code from master branch
- Test on Node.js 18.x
- Test on Node.js 20.x
- Verify server.js and index.html exist
- Check JavaScript syntax
- Start the server
- Test HTTP response (200 OK)
- Verify Calculator HTML is served

✅ **Lint Job:**
- Validate HTML5 structure
- Check for required elements (calculator, display, buttons)
- Validate package.json

---

## Troubleshooting

### If you get "branch already exists":
```bash
git checkout master
git merge main
git push origin master
```

### If push is rejected:
```bash
git pull origin master --rebase
git push origin master
```

### To see commit differences between branches:
```bash
git log main..master
```

### To see file differences between branches:
```bash
git diff main master
```

---

## Quick Reference: Full Workflow

```bash
# Make sure you're in the project directory
cd /Users/parasana/Downloads/CascadeProjects/windsurf-project

# Stage and commit changes
git add .
git commit -m "Update theme: Changed to dark orange theme"

# Create and switch to master branch
git checkout -b master

# Push to GitHub
git push -u origin master

# Go to GitHub Actions tab to see CI running!
```

That's it! Your CI pipeline will run automatically on the master branch. 🚀
