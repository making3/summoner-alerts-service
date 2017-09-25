# SummonerAlertsService

Service to parse /r/summonerschool threads and comments based on tags (i.e. champion (ziggs, ahri), lane (jungle, mid), season, and so on) for generating notifications 

Original idea started off from the other summonerschool project I had, but that was a dud and I stopped working on it. Picked it back up with Elixir for learning purposes.

# Running

## Environment Variables

- REDDIT_USER
- REDDIT_PASS
- REDDIT_CLIENT_ID
- REDDIT_SECRET

Haven't dug into how to run the service using "mix run", so use the interactive shell for now:

    iex -S mix
