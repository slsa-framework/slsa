#!/usr/bin/env python3

"""
migrate-to-late-branch.py

Purpose: Migrate SLSA repository to a late-branch model.

Before: All versions are in subfolders in docs/spec/<version>
After:  Each version lives in its own branch under releases/<version>
        with content directly under /spec/

For each version subfolder:
1. Create and checkout a new branch named releases/<version>
2. Move the version content from docs/spec/<version> to spec/
3. Remove the docs/ directory
4. Commit and push the branch
"""

import argparse
import os
import subprocess
import sys
import re
from datetime import datetime
from typing import List, Optional


# --- Configuration constants ---
SPECDIR = "docs/spec"
REF_SPEC = "releases"


# --- Helper functions ---
def log(message: str) -> None:
    """Print a timestamped log message."""
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    print(f"[{timestamp}] {message}")


def error(message: str) -> None:
    """Print an error message and exit."""
    log(f"ERROR: {message}")
    sys.exit(1)


def confirm(message: str) -> bool:
    """Prompt the user for confirmation."""
    response = input(f"{message} [y/N] ").strip().lower()
    return response in ["y", "yes"]


def run_command(command: List[str], dry_run: bool = False, check: bool = True) -> Optional[str]:
    """
    Run a shell command.
    
    Args:
        command: The command to run as a list of strings
        dry_run: If True, print the command but don't execute it
        check: If True, raise an exception if the command fails
        
    Returns:
        The command output as a string, or None if dry_run is True
    """
    cmd_str = " ".join(command)
    if dry_run:
        log(f"[DRY RUN] Would execute: {cmd_str}")
        return None
    
    log(f"Executing: {cmd_str}")
    try:
        result = subprocess.run(
            command,
            check=check,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True
        )
        return result.stdout.strip()
    except subprocess.CalledProcessError as e:
        error(f"Command failed: {cmd_str}\n{e.stderr}")
        return None


def get_repo_root() -> str:
    """Get the absolute path to the Git repository root."""
    result = run_command(["git", "rev-parse", "--show-toplevel"], check=True)
    if not result:
        error("Could not determine repository root.")
    return str(result)


def get_current_branch() -> str:
    """Get the name of the current Git branch."""
    result = run_command(["git", "rev-parse", "--abbrev-ref", "HEAD"], check=True)
    if not result:
        error("Could not determine current branch.")
    return str(result)


def has_uncommitted_changes() -> bool:
    """Check if there are uncommitted changes in the repository."""
    result = run_command(["git", "status", "--porcelain"])
    return bool(result)


def branch_exists(branch_name: str) -> bool:
    """Check if a branch exists locally or remotely."""
    # Check if branch exists locally
    local_result = subprocess.run(
        ["git", "show-ref", "--verify", "--quiet", f"refs/heads/{branch_name}"],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE
    )
    
    # Check if branch exists remotely
    remote_result = subprocess.run(
        ["git", "show-ref", "--verify", "--quiet", f"refs/remotes/origin/{branch_name}"],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE
    )
    
    return local_result.returncode == 0 or remote_result.returncode == 0


def get_version_dirs() -> List[str]:
    """Get all release version directories from the spec directory."""
    if not os.path.isdir(SPECDIR):
        error(f"{SPECDIR} does not exist.")
        
    # List all items in the directory
    items = os.listdir(SPECDIR)
    
    # Filter out README files, hidden files, and draft directories
    versions = [item for item in items if os.path.isdir(os.path.join(SPECDIR, item)) 
                and not re.match(r'^(\.|README|draft$)', item)]
    
    return versions


def migrate_version(version: str, dry_run: bool = False) -> None:
    """
    Migrate a specific version to its own branch.
    
    Args:
        version: The version to migrate
        dry_run: If True, print commands but don't execute them
    """
    branch = f"{REF_SPEC}/{version}"
    log(f"Processing version: {version} -> branch: {branch}")
    
    # Create a new branch for this version
    run_command(["git", "checkout", "-b", branch], dry_run=dry_run)
    
    # Move the version folder to the root of the spec directory
    log(f"Moving {SPECDIR}/{version} to spec/")
    run_command(["git", "mv", f"{SPECDIR}/{version}", "spec"], dry_run=dry_run)
    
    # Remove docs folder
    log("Removing docs/ directory")
    run_command(["git", "rm", "-rf", "docs"], dry_run=dry_run)
    
    # Commit the changes
    log("Committing changes")
    run_command([
        "git", "commit", "-m", f"Migrate {version} to its own branch ({branch})"], 
        dry_run=dry_run
        )
    
    # Push the branch
    log("Pushing branch to origin")
    run_command(["git", "push", "-u", "origin", branch], dry_run=dry_run)


def main(dry_run=False, force=False) -> None:
    """
    Main function to execute the migration script.
    
    Args:
        dry_run: If True, print commands but don't execute them
        force: If True, skip confirmation prompts
    """
    # Check for uncommitted changes
    if has_uncommitted_changes():
        error("You have uncommitted changes. Please commit or stash them first.")
    
    # Ensure script is run from the repo root
    repo_root = get_repo_root()
    os.chdir(repo_root)
    
    # Save the current branch to return to later
    orig_branch = get_current_branch()
    log(f"Current branch: {orig_branch}")
    
    # Find all subfolders in docs/spec
    log("Finding version directories...")
    versions = get_version_dirs()
    log(f"Found versions: {', '.join(versions)}")
    
    # Check if any of the version refs already exist
    log("Checking for existing version refs...")
    existing_branches = []
    for version in versions:
        branch = f"{REF_SPEC}/{version}"
        if branch_exists(branch):
            existing_branches.append(branch)
    
    if existing_branches:
        error(f"Branches already exist: {', '.join(existing_branches)}. Please delete them first.")
    
    log("No existing version refs found. Proceeding with migration...")
    
    # Confirm the operation
    if not dry_run and not force:
        if not confirm(f"This script will create {len(versions)} new branches. Continue?"):
            log("Operation cancelled by user.")
            sys.exit(0)
    
    # Process each version
    try:
        for version in versions:
            migrate_version(version, dry_run=dry_run)
            
            # Return to the original branch after processing each version
            if not dry_run:
                run_command(["git", "checkout", orig_branch])
                
        # Summary of updated branches
        log("Operation complete!")
        if dry_run:
            log("[DRY RUN] Would have created these branches:")
        else:
            log("All branches created:")
            
        for version in versions:
            log(f"  - {REF_SPEC}/{version}")
            
    except Exception as e:
        error(f"An error occurred: {str(e)}")
        # Try to return to the original branch
        if not dry_run:
            try:
                run_command(["git", "checkout", orig_branch], check=False)
            except:
                pass
        sys.exit(1)


if __name__ == "__main__":
    # Parse command line arguments
    parser = argparse.ArgumentParser(
        description="Migrate SLSA repository to a late-branch model"
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Show what would be done without making changes"
    )
    parser.add_argument(
        "--force",
        action="store_true",
        help="Skip confirmation prompts"
    )
    args = parser.parse_args()
    
    # Call main function with parsed arguments
    main(dry_run=args.dry_run, force=args.force)
