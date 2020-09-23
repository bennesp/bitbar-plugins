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

IMAGE="iVBORw0KGgoAAAANSUhEUgAAACQAAAAkCAQAAABLCVATAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAmJLR0QA/4ePzL8AAAAJcEhZcwAAFiUAABYlAUlSJPAAAAAHdElNRQfkCRcNByjz81MNAAABvUlEQVRIx92WvUoDQRSFv4iktHRRg636ACms/AMTQQOW+iARtNBW00qeQbFLGhUiCDHaBEVJE9uoxDKloNdiJuzs7mwyK1Y5gcCee+7JnbPh7sLIIjWknsZjEviky9ffjHIsss6iwTS45oGrJHNuUkFiPhU2XW0OjbY3apxySo03gy0nsWmzTSZQybBNW1dvXG3OYtJLce4yVd9mZeCPrWrVYXzESjA/9PgLWhkTu7pTxRA7jfDDVIjd03fQgjyCUI/wywjCUiSrOwQh3yfGjJMDlIYeS0E4MboCRmsAPDoawZPRZSCNILxbGuxHA/hAENLBiTwAXp3n8dWezaiVyKhlM1L4SWT0DYCoi3FNdgGsf8VnLoAXS0WpP4OkCruTaKKOGbaPBoIwE5FPkCPHRITPIAiN/qWf0TUA2UjDAZdcsh/hs0ZXwOgegONIg2d8+0hp5b3tzFW9iYLYpUePnRB7hiBU7eFt6eWwHEkjE2JWBq8RONKCOQZhXquOBon6VsVYRdHFxrSqU2A2UJmlQN3VxrRS++CWMmVueTdYJxsVe/U/HpAKG5RoBiyalPzVGobLS4QHdIe9RIwwfgEBvdRQl7wQtQAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAyMC0wOS0yM1QxMzowNzo0MCswMDowMGl4RyEAAAAldEVYdGRhdGU6bW9kaWZ5ADIwMjAtMDktMjNUMTM6MDc6NDArMDA6MDAYJf+dAAAAAElFTkSuQmCC"

echo "$issueCount | image=$IMAGE"
echo "---"
echo "$titles"

