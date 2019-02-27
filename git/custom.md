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
  TARGET_BRANCH="${1-master}"
  #REVIEWERS="${2}"
  IFS=' ' 
  REVIEWERS=(${@:2})

  # Project abbr - hardcoded for now
  PROJECT_ABBR='BOB'

  # Get the project name (osx compatible)
  PROJECT_NAME=`git remote -v | head -n1 | awk '{print $2}' | sed -e 's,/, ,g'| awk '{print $NF}' | sed -e 's/\.git$//'`

  # Get a title for the commit message - we will use the first word of the commit message
  TITLE=`git show -s --format=%B | head -n1 | cut -d " " -f1`
  TITLE="${TITLE//\"/\'}"
  DESC=`git show -s --format=%B`
  DESC="${DESC//\"/\'}" # Remove any double quotes and put single quotes in their place
  DESC="${DESC/$TITLE/}" # remove the title from the description
  if [[ -z "${param// }" ]]; then DESC=$TITLE; fi # use the title if the description is blank

  # JSON parameters we will be sending
  MSG="{'title': \"$TITLE\", 'description': \"$DESC\", 'state': 'OPEN',
  'fromRef': { 'id': 'refs/heads/$GIT_BRANCH', 'repository': { 'slug': '$PROJECT_NAME', 'project': { 'key': '$PROJECT_ABBR' }}},  
  'toRef': { 'id': 'refs/heads/$TARGET_BRANCH', 'repository': { 'slug': '$PROJECT_NAME', 'project': { 'key': '$PROJECT_ABBR' }}}"

  if [[ $REVIEWERS  ]]; then
    MSG="$MSG,
  'reviewers': ["
    for item in "${REVIEWERS[@]}"; do 
      MSG="$MSG {'user': { 'name': '$item' }},";
    done;
    MSG="${MSG%?} ]" # delete the least char (,)
  fi

  MSG="$MSG }";

  # SSH Support for pull requests
  (echo $MSG | ssh git@bitbucket pull-request) && git checkout $TARGET_BRANCH
```

Now we create a pull request for the current branch over ssh from the terminal.
- The first characters is used as the pull request title
- The commit message is the pull request description
- The project will match the current git repository project

```bash
  git pull-request
```

Deleting all branches except for those in the whitelist.

```bash
  git branch -D `git branch | awk '{ if ($0 !~ "^\ +(uat|release|production)|\ +master$") printf "%s", $0 }'`
```

Undelete all deleted files

```bash
  git ls-files -d | xargs git checkout -- 
```
