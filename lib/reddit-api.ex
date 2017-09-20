require Poison
require HTTPotion
require RedditUriHelper

# Big thanks to http://learningelixir.joekain.com/fetching-reddit-posts-from-elixir/
defmodule RedditApi do
  def get_oauth_token do
    request_oauth_token().body
      |> Poison.decode
      |> ok
      |> Map.get("access_token")
  end

  def get_stickied_thread(token, subreddit, num) do
    location = request({:uri, "/r/#{subreddit}/about/sticky"}, token, [ num: num ])
      |> Map.get(:headers)
      |> Map.get(:hdrs)
      |> Map.get("location")

    request({ :url, location }, token)
      |> Map.get(:body)
      |> Poison.decode
      |> get_thread_from_result
  end

  def get_new_threads(token, subreddit, opts \\ []) do
    uri = RedditUriHelper.get_new_threads(subreddit)
    request({ :uri, uri }, token, opts)
      |> Map.get(:body)
      |> get_request_body
  end

  def get_comments(token, subreddit, thread_id) do
    uri = RedditUriHelper.get_thread_comments(subreddit, thread_id)
    # TODO: Remove limit, or find a way to process more than the limit (I'm sure there is a max..limit)
    request({:uri, uri }, token, [ limit: 100 ])
      |> Map.get(:body)
      |> get_request_body
  end

  defp request_oauth_token do
    cfg = get_config()
    headers = get_auth_headers(cfg)
    HTTPotion.post("https://www.reddit.com/api/v1/access_token", headers)
  end

  defp get_config do
    %{
      username: System.get_env("REDDIT_USER"),
      password: System.get_env("REDDIT_PASS"),
      client_id: System.get_env("REDDIT_CLIENT_ID"),
      secret: System.get_env("REDDIT_SECRET")
    }
  end

  defp request({:url, url}, token) do
    headers = get_headers(token)
    HTTPotion.get(url, headers)
  end

  defp request({:uri, endpoint}, token, options) do
    query = get_query(options)
    url = "https://oauth.reddit.com#{endpoint}/#{query}"
    request({:url, url}, token)
  end

  defp get_request_body(""), do: ""
  defp get_request_body(body), do: Poison.decode(body) |> ok

  defp get_query(options) do
    query = options
      |> Enum.map(fn {key, value} -> "#{key}=#{value}" end) # TODO: Can this be cleaned up / shortened?
      |> Enum.join("&")
    "?#{query}"
  end

  defp get_auth_headers(config) do
    [
      body: "grant_type=password&username=#{config[:username]}&password=#{config[:password]}",
      headers: [
        "User-Agent": "summonerschool-alerts",
        "Content-Type": "application/x-www-form-urlencoded"
      ],
      basic_auth: {config[:client_id], config[:secret]}
    ]
  end

  defp get_headers(token) do
    [
      headers: [
        "User-Agent": "summonerschool-alerts/0.1 by yeamanz",
        "Authorization": "bearer #{token}"
      ]
    ]
  end

  defp ok({:ok, result}), do: result
  defp get_thread_from_result({:ok, [ thread, _ ] }), do: thread
end
