#!/bin/bash
set -euo pipefail

read -r -p "GitHub or GitLab? (gh/gl)" provider;

case $provider in
  gh)
    ;;
  gl)
    ;;
  *) echo "Invalid provider selected"
    exit 1;;
esac

echo "Enter your username"
read -r username
if [[ "$provider" == "gh" ]]; then
  echo "Enter your GitHub Access Token (read:org scope required)"
else
  echo "Enter your GitLab Access Token (api scope required)"
fi
read -r token

if [[ "$provider" == "gl" ]]; then
  read -r -p "Are you fetching users from a Project or Group? (p/g)" group_type;

  case $group_type in
    p)
      ;;
    g)
      ;;
    *)
      echo "Invalid group type selected"
      exit 1;;
  esac
fi

if [[ -n "$group_type" ]]; then
  if [[ "$group_type" == "p" ]]; then
    echo "Enter the Project ID (as it appears in URLs)"
  else
    echo "Enter the Group ID (as it appears in URLs)"
  fi
else
  group_type="o" # organisation, i.e. GitHub
  echo "Enter the GitHub organisation slug (as it appears in URLs)"
fi
read -r org


# github_request () {
#   curl -su "$username:$token" "https://api.github.com/$1"
# }

gitlab_request () {
  curl -s --header "PRIVATE-TOKEN: $token" "https://gitlab.com/api/v4/$1"
}

if [[ $group_type == "g" ]]; then
  members=$(gitlab_request "groups/$org/members")
  users=$(echo "$members" | jq -r '')
  echo "$members"
fi

# members=$(github_request "orgs/$org/members")
# users=$(echo "$members" | jq -r '.[].login')

# for user in $users; do
#   user_key_response=$(github_request "users/$user/gpg_keys")
#   raw_key="$(echo "$user_key_response" | jq -r '.[0].raw_key')"

#   if [[ "$raw_key" != "null" ]]; then
#     # I don't know. GitHub gives annoying \r\n stuff and it's annoying.
#     # Did I mention it's annoying? It's annoying.
#     echo "$user_key_response" | jq -r '.[0].raw_key' > "keys/$user.pub"
#     gpg --import "keys/$user.pub"
#   fi
# don-s e
