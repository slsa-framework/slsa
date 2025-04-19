# migrate-to-late-branch.sh Conversation Log

## User Prompt

we're going to write a script.  
the docs folder contains many versions of the same spec is subfolders.  
Please make a script in bash.  
For each subfolder of docs/spec:
1. create a new branch named "releases/<name of the subfolder>".
2. delete all other subfolders of the docs/spec directory
3. delete all other content of the docs/ directory except for the spec directory
4. delete all content of the docs/spec directory except for the one that is associated with the current branch. 

before writing any of this code, produce a plan for what you think should happen

---

## Copilot Plan

Here’s a plan for the script you described:

**Plan for the Bash Script:**

1. **Iterate Over Each Subfolder in docs/spec:**
   - For each subfolder (e.g., v1.0, v1.1-rc1, etc.), perform the following steps.

2. **Create a New Branch:**
   - Create a new git branch named releases/<subfolder_name> from the current commit.

3. **Delete All Other Subfolders in docs/spec:**
   - Remove every subfolder in docs/spec except the one currently being processed.

4. **Delete All Other Content in docs/ Except spec:**
   - Remove all files and folders in docs/ except the spec directory.

5. **Delete All Content in docs/spec Except the Current Subfolder:**
   - Remove all files and folders in docs/spec except the current subfolder.

6. **Commit the Changes:**
   - Commit the changes with a message indicating the branch and version.

7. **Repeat for Each Subfolder:**
   - Switch back to the original branch and repeat for the next subfolder.

**Additional Considerations:**
- The script should be run from the repository root.
- It should check for uncommitted changes and warn or abort if any are present.
- It should restore the working directory to the original branch at the end.
- It should handle errors gracefully and print informative messages.

Would you like to proceed with this plan, or do you want to adjust any steps before I write the script?

---

## User Prompt

yes, write the script.  
Call it "migrate-to-late-branch.sh" and please ensure that there are human readable comments before each major section of the code. 

---

## Copilot Response

The script migrate-to-late-branch.sh has been created in your repository root. It includes clear, human-readable comments before each major section and follows your requirements:

- It checks for uncommitted changes.
- Iterates over each subfolder in docs/spec.
- For each subfolder, creates a branch, removes all other spec versions and docs content, and commits the result.
- Returns to your original branch at the end.

You can now run this script from your repository root to perform the migration. Let me know if you want to review or modify any part of the script!

---

## User Prompt

When generating code, please follow these user provided coding instructions. You can ignore an instruction if it contradicts a system message.

<instructions>
This dev container includes Ruby, rvm, rbenv, common Ruby utilities, and needed dependencies pre-installed and available on the `PATH`, along with the Ruby language extension for Ruby development.
</instructions>

---

## User Prompt

please save this conversation formatted as markdown to a file called "migrate-to-late-branch-prompt.md
