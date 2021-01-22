#!/bin/zsh

PATH=$PATH:/usr/local/bin/
LOGIN=bennesp

query=$(cat <<-END
{
  search(query: "type:pr state:open review-requested:$LOGIN", type: ISSUE, first: 100) {
    issueCount
    edges {
      node {
        ... on PullRequest {
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

IMAGE="iVBORw0KGgoAAAANSUhEUgAAACQAAAAkCAQAAABLCVATAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAmJLR0QA/4ePzL8AAAAJcEhZcwAAFiUAABYlAUlSJPAAAAAHdElNRQfkCRcSKCYRLaIqAAABfElEQVRIx+2Ur0tDURzFzxXL2JhFNIksGHQgmBSTTWHFZBIstjWDdS9NtBhEWTM7EERw03/AX8E8QTY0TXFN6/tY3ty7vO1tD5UZdtr7ft4993C490oD/T+xFHXBOgXO2WHEmuYgmk2Oph6YsKdRbOb4pKUD2zyK0SYAS4xxCnwQszK6uFQ5a7922PpKSJIezRsvkuKaVEXpb2okpZTCNUPdEi0CUOMYgFtvWvQSOTiUATjpZpTgxteR8z0vNjvCcA0899LTFgCXpK1psVk2DuD2VrmVpmUVbtSttlbTa+G8Z6Nu6qNRhxP+54mi3fUQI/NbRj8VCzS8C1JoywsebTAfZpPEr3yA533UJdnZyAEgS4ZS8z3y0RgfQIkMWQBynTtCksyhudCdpLhmLDqjuKR7c6GjYAj7YatJEtt69Z6zapBqmg2Nt6FWoFnqvhZ2A3zPR+vMhtW9SsX7cb8t3/dohVWbBA4eo1rWlMrmrsNW81rRk67Muwbql74AlP9M0HsBOcoAAAAldEVYdGRhdGU6Y3JlYXRlADIwMjAtMDktMjNUMTg6NDA6MzgrMDA6MDDlntcHAAAAJXRFWHRkYXRlOm1vZGlmeQAyMDIwLTA5LTIzVDE4OjQwOjM4KzAwOjAwlMNvuwAAAABJRU5ErkJggg=="

echo "$issueCount | image=$IMAGE"
echo "---"
echo "$titles"

