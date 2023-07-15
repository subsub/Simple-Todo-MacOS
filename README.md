# Simple TODO Bar

A Todo-List for Mac made simple. Creating and managing todo-list from menu bar. It also comes with Jira integration to easily track issues you are working on.

<video src="https://github.com/subsub/Simple-Todo-MacOS/blob/ebf9c7881d91caaee0d02deeaf1deb81c795db12/simple-todo-bar-demo.mov" controls="controls" style="max-width: 730px;">
</video>

## Version

0.0.1

## Features

- Create a new task
  - Set a reminder at specific time to show notification on your mac
  - Add Jira issue key (require Jira integration to be turned on) to easily manage your jira card
- See ongoing tasks
- See completed tasks
- See task detail
  - See Jira card detail (require Jira integration to be turned on) if issue key is provided
    - Set card transition/status
    - See card description
    - See comments
    - Post comments
  - Delete task
- Delete all tasks
- Delete all tasks done

## Installation

```
brew tap subsub/subsub https://github.com/subsub/simple-todo
brew install --cask simple-todo
```
