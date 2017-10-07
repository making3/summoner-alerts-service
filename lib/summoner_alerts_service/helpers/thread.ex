# Available data
# title
# permalink
# created_utc (linux timestamp I assume)
# subreddit_id
# ups,downs (votes)
# upvote_ratio
# score
# id
# name (somedata_id, no idea what this really returns...)
# url (permalink seems better)
# stickied

defmodule SummonerAlertsService.Helpers.Thread do
  @sticky_title_contains "simple questions simple answers"

  def parse(sticky_response) do
    Map.get(sticky_response, "data")
      |> Map.get("children")
      |> List.first
      |> Map.get("data")
  end

  def id(thread) do
    Map.get(thread, "id")
  end

  def title(thread) do
    Map.get(thread, "title")
  end

  def is_qa(thread) do
    title(thread)
      |> String.downcase
      |> String.contains?(@sticky_title_contains)
  end
end
