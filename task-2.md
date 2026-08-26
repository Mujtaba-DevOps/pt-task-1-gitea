# DevOps Internship Task 2 – Gitea Local Setup Automation

## Intern

Mujtaba Shaikh

## Date

26 August 2026

## Task

Automate Local Project Setup

## Objective

The objective of this task was to create a shell script that automates the process of building and running the Gitea project locally without manually executing each command.

The script checks the required tools, displays dependency versions, verifies the project directory, builds Gitea from source, verifies the Gitea binary, checks whether port 3000 is available, and starts the Gitea web server.

## Environment

- Operating System: Ubuntu Linux
- Git
- Go
- Node.js
- pnpm
- Make
- Gitea
- SQLite
- Bash Shell

## Script

The automation script is:

`setup-gitea.sh`

The script determines its own location using `BASH_SOURCE` and does not use a hard-coded user-specific project path.

## Requirements Implemented

### 1. Project Directory Verification

The script determines the directory where the script is located and verifies that it contains the Gitea `Makefile` and `go.mod`.

If these files are not found, the script displays an error and exits.

### 2. Required Tool Checks

The script checks whether the following tools are installed:

- Git
- Go
- Node.js
- pnpm
- Make

If any required tool is missing, the script displays an error and exits.

### 3. Dependency Version Checks

The script displays the installed versions of the required dependencies.

Example:

```text
Git:    git version 2.43.0
Go:     go version go1.27.0 linux/amd64
Node:   v24.19.0
pnpm:   11.22.0
Make:   GNU Make 4.3
