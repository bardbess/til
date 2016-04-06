# Custom Git Commands

Adding a custom git command is very simple, all you need is an executable script in you path.

We will use /usr/local/bin, alternatively you could create a hidden .bin directory in your user home.

The git script must start with a `git-` the rest subcommand that will be used. And of course should be executable.

```bash
  touch /usr/local/bin/git-pull-request
  chmod +x /usr/local/bin/git-pull-request
  vi /usr/local/bin/git-pull-request
```

Now you can put whatever you need in the new pull request file, this example takes advantage of 
the [SSH Support for Pull Request](https://marketplace.atlassian.com/plugins/de.aeffle.stash.plugins.create-pull-request-via-ssh/server/overview) bitbucket plugin.

```bash
  #!/bin/bash
  # Get the current branch
  GIT_BRANCH=`git rev-parse --abbrev-ref HEAD`
  # Project abbr - hardcoded for now
  PROJECT_ABBR='BOB'
  # Get the project name (osx compatible)
  PROJECT_NAME=`git remote -v | head -n1 | awk '{print $2}' | sed -e 's,/, ,g'| awk '{print $NF}' | sed -e 's/\.git$//'`
  # Get a title for the commit message - we will use the first word of the commit message
  TITLE=`git show -s --format=%B | head -n1 | cut -d " " -f1`
  # JSON parameters we will be sending
  MSG="{'title': '$TITLE', 'description': '`git show -s --format=%B`', 'state': 'OPEN',
  'fromRef': { 'id': 'refs/heads/$GIT_BRANCH', 'repository': { 'slug': '$PROJECT_NAME', 'project': { 'key': '$PROJECT_ABBR' }}},  
  'toRef': { 'id': 'refs/heads/master', 'repository': { 'slug': '$PROJECT_NAME', 'project': { 'key': '$PROJECT_ABBR' }}} }"

  # SSH Support for pull requests
  command echo $MSG | ssh git@mybitbucket.com -p7999 pull-request
```

Now we create a pull request for the current branch over ssh from the terminal.
- The first characters is used as the pull request title
- The commit message is the pull request description
- The project will match the current git repository project

```bash
  git pull-request
```
