require RedditApi

defmodule RedditStream do
  defp fetch_100_new_threads(token, sub, opts) do
    result = RedditApi.get_new_threads(token, sub, [ limit: 100] ++ opts)
    IO.inspect(result["data"]["after"])
    { result["data"], result["data"]["after"] }
  end

  def fetch_new_threads_perpertually(token, sub) do
    Stream.resource(
      fn -> [] end,
      fn next -> fetch_100_new_threads(token, sub, [after: next]) end,
      fn _ -> true end
    )
  end
end
