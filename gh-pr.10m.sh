#!/bin/zsh

PATH=$PATH:/usr/local/bin/
LOGIN=bennesp

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

IMAGE="iVBORw0KGgoAAAANSUhEUgAAACQAAAAkCAQAAABLCVATAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAmJLR0QA/4ePzL8AAAAJcEhZcwAAFiUAABYlAUlSJPAAAAAHdElNRQfkCRcNCTfgeHN2AAABdklEQVRIx+2Uv0sCYRjHP0aLKLZETREODRkITUaTW4GLU1PQ0ubW0OpNRi0OUbg1JwQRqPUPVDY0G4RSk0Vutt7T4Nt5r/dDjwob/N50z+fe7z33vfd5YaJ/qHTQBduUuOKAGa2aR4LZ5BF1PbIwUA2gVT4tI+F4wDyAdhGENHNcIHQJaz2amDS5dF86rd1FAXjinVcgwiINViwaAuLEMZka1tE6gtDiDEG4V9Wy6sjAoIYgnA8zinJny8iw6mUroxC3CC+j5LSHIFzbPunbqicDwRwtcr2bvpWv0dDYLG3549GNhmiMRh47/M87Cjjr3kah3zL6sdboqAEpufKSoh1SfjYx26QJBQcv2KhJzNvIQBByZKha51FfYboIVTLkEIS8d0a9f3VChToQIaHRBBHggQqnzh70g60FwD5vavabLnSZHeZdqKYkbVsKhw5+ZKNtkn5xZ2moB4uuvKhog6wOnBtvlg2WqFH3eFWKTZ654YOJxqUvLBCba5CFqo8AAAAldEVYdGRhdGU6Y3JlYXRlADIwMjAtMDktMjNUMTM6MDk6NTUrMDA6MDDpI1irAAAAJXRFWHRkYXRlOm1vZGlmeQAyMDIwLTA5LTIzVDEzOjA5OjU1KzAwOjAwmH7gFwAAAABJRU5ErkJggg=="

echo "$issueCount | image=$IMAGE"
echo "---"
echo "$titles"

