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

defmodule SAS.Helpers.Thread do
  @sticky_title_contains "simple questions simple answers"

  def get_link(sticky_response) do
    sticky_response
    |> List.first()
    |> Map.get("data")
    |> Map.get("children")
    |> List.first()
    |> Map.get("data")
  end

  def get_id(thread) do
    Map.get(thread, "id")
  end

  def get_title(thread) do
    Map.get(thread, "title")
  end

  def is_qa(thread) do
    get_title(thread)
    |> String.downcase()
    |> String.contains?(@sticky_title_contains)
  end
end
