#!/bin/zsh

PATH=$PATH:/usr/local/bin/
LOGIN=bennesp

query=$(cat <<-END
{
  search(query: "state:open is:issue assignee:$LOGIN", type:ISSUE, first:100) {
    issueCount
    edges {
      node {
        ... on Issue {
          repository {
            name
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

if [[ $1 = 'debug' ]]; then
  echo $response;
fi

issueCount=$(echo $response | jq -r '.data.search.issueCount')
titles=$(echo $response | jq -r '.data.search.edges[].node | ("[" + .repository.name + "] " + .title + " | href=" + .url)')

isDarkMode=$(osascript <<EOF
tell application "System Events"
    tell appearance preferences
        set theMode to dark mode
    end tell
end tell
return theMode
EOF
)

IMAGE="iVBORw0KGgoAAAANSUhEUgAAACQAAAAkCAQAAABLCVATAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAmJLR0QA/4ePzL8AAAAJcEhZcwAAFiUAABYlAUlSJPAAAAAHdElNRQfkCRcSKDmcJa/fAAAB00lEQVRIx92WPUscURSG3wlhS8sMSRZbzQ+wsPIjkDWggqX5IRvQQttkW9nfYEjnNkYwIGzWNJKg2JhWV9bSUtAnxb3r3Dtzd/ZOSOUpFuY95zxzzjvLnZGebCTlaWpK9ULSjQbJ3T+BaGhW7zTrSD0d6GfyrcKYLLPHqNhjORaz5bRdccgOOxxy5ajtKpgL1qh7mTprXNjs91jMLkH3SPgSMdUjZqH0Zou2amu0xSamx67/xlaGbbdPqplTXwEPvMypH80TDGGWAOgW9HkA5gpe/QBgaag8e8wtSpJa49YykaDPTpcHeitJ+hUHkvTb6XJGrQHQD6wcXE2SuAag5k+USpL+RM+TVach0Hkl0HkIZOKhEujebGgunltxIEkK/RVP9VXSWSBjqm9844zZl1UG4tI1O5N7ALwulE/QoMFEQa8D0BteZx4dSJJmCjfe1L72tVHQZ5wuD3QsSfpUaEid32yexFYeh3bumJMop37gllvWc+ouAJ2weSv2cJgvuFHPKQulx4jEti2YUkkwbau2y4qGqObIimYExkN1WWXSy0yySjcS46EA+hzRps0RfUeNwVjbO//hBWlh72lx4iFOaGVHaz5iPiJSSYNxHxFPOP4CCWTIbjnycrQAAAAldEVYdGRhdGU6Y3JlYXRlADIwMjAtMDktMjNUMTg6NDA6NTcrMDA6MDDVua5pAAAAJXRFWHRkYXRlOm1vZGlmeQAyMDIwLTA5LTIzVDE4OjQwOjU3KzAwOjAwpOQW1QAAAABJRU5ErkJggg=="

echo "$issueCount | image=$IMAGE"
echo "---"
echo "$titles"

