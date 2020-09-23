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

isDarkMode=$(osascript <<EOF
tell application "System Events"
    tell appearance preferences
        set theMode to dark mode
    end tell
end tell
return theMode
EOF
)

IMAGE="iVBORw0KGgoAAAANSUhEUgAAACQAAAAkCAQAAABLCVATAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAmJLR0QA/4ePzL8AAAAJcEhZcwAAFiUAABYlAUlSJPAAAAAHdElNRQfkCRcNCTfgeHN2AAABdklEQVRIx+2Uv0sCYRjHP0aLKLZETREODRkITUaTW4GLU1PQ0ubW0OpNRi0OUbg1JwQRqPUPVDY0G4RSk0Vutt7T4Nt5r/dDjwob/N50z+fe7z33vfd5YaJ/qHTQBduUuOKAGa2aR4LZ5BF1PbIwUA2gVT4tI+F4wDyAdhGENHNcIHQJaz2amDS5dF86rd1FAXjinVcgwiINViwaAuLEMZka1tE6gtDiDEG4V9Wy6sjAoIYgnA8zinJny8iw6mUroxC3CC+j5LSHIFzbPunbqicDwRwtcr2bvpWv0dDYLG3549GNhmiMRh47/M87Cjjr3kah3zL6sdboqAEpufKSoh1SfjYx26QJBQcv2KhJzNvIQBByZKha51FfYboIVTLkEIS8d0a9f3VChToQIaHRBBHggQqnzh70g60FwD5vavabLnSZHeZdqKYkbVsKhw5+ZKNtkn5xZ2moB4uuvKhog6wOnBtvlg2WqFH3eFWKTZ654YOJxqUvLBCba5CFqo8AAAAldEVYdGRhdGU6Y3JlYXRlADIwMjAtMDktMjNUMTM6MDk6NTUrMDA6MDDpI1irAAAAJXRFWHRkYXRlOm1vZGlmeQAyMDIwLTA5LTIzVDEzOjA5OjU1KzAwOjAwmH7gFwAAAABJRU5ErkJggg=="

if [[ $isDarkMode -eq "true" ]]; then
  IMAGE="iVBORw0KGgoAAAANSUhEUgAAACQAAAAkCAQAAABLCVATAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAmJLR0QA/4ePzL8AAAAJcEhZcwAAFiUAABYlAUlSJPAAAAAHdElNRQfkCRcSKCYRLaIqAAABfElEQVRIx+2Ur0tDURzFzxXL2JhFNIksGHQgmBSTTWHFZBIstjWDdS9NtBhEWTM7EERw03/AX8E8QTY0TXFN6/tY3ty7vO1tD5UZdtr7ft4993C490oD/T+xFHXBOgXO2WHEmuYgmk2Oph6YsKdRbOb4pKUD2zyK0SYAS4xxCnwQszK6uFQ5a7922PpKSJIezRsvkuKaVEXpb2okpZTCNUPdEi0CUOMYgFtvWvQSOTiUATjpZpTgxteR8z0vNjvCcA0899LTFgCXpK1psVk2DuD2VrmVpmUVbtSttlbTa+G8Z6Nu6qNRhxP+54mi3fUQI/NbRj8VCzS8C1JoywsebTAfZpPEr3yA533UJdnZyAEgS4ZS8z3y0RgfQIkMWQBynTtCksyhudCdpLhmLDqjuKR7c6GjYAj7YatJEtt69Z6zapBqmg2Nt6FWoFnqvhZ2A3zPR+vMhtW9SsX7cb8t3/dohVWbBA4eo1rWlMrmrsNW81rRk67Muwbql74AlP9M0HsBOcoAAAAldEVYdGRhdGU6Y3JlYXRlADIwMjAtMDktMjNUMTg6NDA6MzgrMDA6MDDlntcHAAAAJXRFWHRkYXRlOm1vZGlmeQAyMDIwLTA5LTIzVDE4OjQwOjM4KzAwOjAwlMNvuwAAAABJRU5ErkJggg=="
fi

echo "$issueCount | image=$IMAGE"
echo "---"
echo "$titles"

