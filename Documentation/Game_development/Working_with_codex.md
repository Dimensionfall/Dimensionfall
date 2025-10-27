# Working with codex

This guide is derived from https://github.com/knavillus1/codex_bootstrap/tree/main. I updated some parts to better align with the Dimensionfall project.
You can use this guide if you have access to https://chatgpt.com/codex

## Features

- PRD and Task file creation within Codex
- Task orchestration and managment in Codex

## First time setup
1. In codex, go to https://chatgpt.com/codex/settings/general and remove any custom instructions you may have previously used.
2. Go to https://chatgpt.com/codex/settings/environments, select or create your github-connected fork of the Dimensionfall game.
3. Press Edit -> copy-paste this into the startup script textbox and Save:
```
# 1. Download the latest Godot 4.x Linux 64-bit binary
echo "⬇️  Fetching Godot 4.4.1 …"
wget --retry-connrefused --tries=5 -q --show-progress -O /tmp/godot.zip \
   https://github.com/godotengine/godot/releases/download/4.4.1-stable/Godot_v4.4.1-stable_linux.x86_64.zip

# 2. Unzip and install
unzip /tmp/godot.zip -d /usr/local/bin/
sudo mv /usr/local/bin/Godot_v4.4.1-stable_linux.x86_64 /usr/local/bin/godot
sudo chmod +x /usr/local/bin/godot

# 3. Cleanup
rm /tmp/godot.zip

# 4. Verify installation
godot --version

# 5. Check if project.godot exists
if [ -f "project.godot" ]; then
  echo "✅ project.godot found in current directory."
else
  echo "❌ project.godot NOT found in current directory."
fi

# 6. Install gdtoolkit we need to do formatting later
pip3 install "gdtoolkit==4.*"
```

## Preparation for your next feature
- Create a new branch in your fork of the Dimensionfall game
- Whenever we create the feature specification or prompt Codex, we use this branch

# Using the Taskmaster to let codex do work for you
Starting with any description of a feature, this guide supplies tooling to automate creation of PRD and Task List files, and then Codex agent will manage work from this list, updating it as needed. There are four phases:
- PRD file creation
- Task list file creation
- Completing the tasks
- Feature Close

Note: when scripts are **edited** by codex, it will also **format** it using `gdformat path/to/modified_script.gd`. This is needed to make sure only tabs are used for indentation instead of spaces. This may result in more changes then the feature/task intended. Formatting does not change behavior so it should be safe.

## PRD file creation
- Add feature specs and background to `.project-management/current-prd/prd-background/`:
    - `feature-specification.md` containing feature specs with as much or little detail as needed.  Mandatory for running PRD creation in Codex.
- Create the PRD:
    - Codex: Start task in *Code* mode with just the phrase **CreatePrd**
- There will be Q&A with the Agent, On Codex answer questions and resume in *Code* mode (Environment is spun up again)
- Result should be a PRD file in `.project-management/current-prd/`
- Merge PR to target branch

## Task list file creation
- Create Task List File:
    - Codex: Start task in *Code* mode with just the phrase **CreateTasks**
- Q&A, answer and click code
- Result should be a task list file at `.project-management/current-prd/`
- Merge PR to target branch

## TaskMaster

- Once `.project-management\current-prd\tasks.*.md` is created, the TaskMaster message can be used.  This will allow the agent to commit to one or more tasks in a session.  The task list file will be updated as part of the PR, with completed tasks checked off and relevant files updated as needed.
- Start Codex in Code mode using the phrase *TaskMaster*.  This will corece the agent to reference `process-tasks-cloud.md' which picks one or more tasks to complete in the session.

## Feature Close
- Perform final feature review
    - Codex: Start task in *Code* mode with just the phrase **ClosePrd**
- Review will either:
    - Result in flagged changes - review and resubmit the close out
    - Pass review and close the PRD - feature files are moved from `current-prd` to `closed-prd`

## Maintenance tasks
Aside from the primary PRD flow described above, it's also possible to have Codex find and perform maintenance work. 
- Create a branch in your fork (you can call it `maintenance` for example)
- Go to https://chatgpt.com/codex and in the prompt bar select your `maintenance` branch
- Enter the phrase `MaintenanceTasks` and press `code`. This will tell Codex to follow the instructions in `.project-management/maintenance-tasks.md`
- Once codex is done, `.project-management\current-prd\tasks.*.md` will be created. There will probably be more maintenance tasks then is suitable for one pr, so you will have to reduce the amount of tasks.
    - Create a pull request from codex for the tasks list.
    - Go to the pull requests in your fork and look at the changed files
    - Edit the created `.project-management\current-prd\tasks.*.md` in github so you can remove the maintenance tasks you don't need
    - Commit your changes and then you can merge the pull request into your `maintenance` branch in your fork.
- Now you can proceed as above by running `TaskMaster` in codex with your `maintenance` branch selected.
- Once TaskMaster is done, create a pull request from Codex, test it and merge it into your `maintenance` branch.
- Afterwards, entering `ClosePrd` into codex with your `maintenance` branch selected will clean up your files and finish the work.
- In the same way, create the pull request for closeprd in codex and merge it into your `maintenance` branch and test it
- Create a pull request for the dimensionfall main branch from the `maintenance` branch.
