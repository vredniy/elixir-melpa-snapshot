defmodule MelpaSnapshot do
  def main(_) do
    response = HTTPotion.get "https://melpa.org/archive.json"
    map = Poison.Parser.parse!(response.body)
    traversed_map = Enum.reduce map, [], fn ({name, package}, acc) -> [%{ name: name, package: package} | acc] end
    Enum.reduce traversed_map, 0, fn(map, acc) -> acc + (map |> make_url |> file_size_by_url) end
  end

  def make_url(map) do
    suffix = if map[:package]["type"] == "single" do "el" else "tar" end
    versions = "#{List.first(map[:package]["ver"])}.#{List.last(map[:package]["ver"])}"
    "https://melpa.org/packages/#{map[:name]}-#{versions}.#{suffix}"
  end

  def file_size_by_url(url) do
    {size, _} = Integer.parse(HTTPotion.head(url).headers["content-length"])
    size
  end
end
