#!/bin/zsh

# Requirements:
# - gh: brew install gh
# - jq: brew install jq

# Configure LOGIN with your username. Will be used as a filter in searching issues
LOGIN=bennesp

PATH=$PATH:/usr/local/bin/
query=$(cat <<-END
{
  search(query: "state:open assignee:$LOGIN", type: ISSUE, first: 100) {
    issueCount
    edges {
      node {
        ... on Issue {
          repository {
            nameWithOwner
          }
          author {
            login
          }
          createdAt
          number
          url
          title
          labels(first:100) {
            nodes {
              name
            }
          }
        }
      }
    }
  }
}
END
)

response=$(gh api graphql --paginate -f query="$query")

issueCount=$(echo $response | jq -r '.data.search.issueCount')
titles=$(echo $response | jq -r '.data.search.edges[].node | (.title + " | href=" + .url)')

echo $issueCount
echo "---"
echo "$titles"

