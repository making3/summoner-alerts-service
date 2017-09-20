defmodule RedditUriHelper do
  def get_sticky(subreddit), do: get_sticky(subreddit, 1)
  def get_sticky(_, num) when num < 1 or num > 2, do: raise ArgumentError, message: "num must be 1 or 2"
  def get_sticky(subreddit, num), do: "/r/#{subreddit}/sticky?num=#{num}"

  def get_new_threads(subreddit), do: "/r/#{subreddit}/new"

  def get_thread_comments(subreddit, thread_id), do: "/r/#{subreddit}/comments/#{thread_id}"
end
