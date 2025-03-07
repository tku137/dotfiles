function latest-pr --description 'View my latest PR'
    gh pr view (gh pr list --author="@me" -L 1 --json number --jq '.[0].number')
end

function my-prs --description 'View PRs authored by @me'
    gh pr list --author "@me"
end
