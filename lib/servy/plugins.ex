defmodule Servy.Plugins do
    @doc "Logs 404 errors"
    def log(conv), do: IO.inspect conv

    def track(%{ status: 404, path: path } = conv) do
      IO.puts "Warning: #{path} is on the loose!"
      conv
    end

    def track(conv), do: conv

    def rewrite_path(%{ method: "GET", path: "/wildlife" } = conv) do
        %{conv | path: "/wildthings" }
    end

    def rewrite_path(conv), do: conv
end
