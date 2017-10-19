defmodule Servy.Handler do
  def handle(request) do
    request 
    |> parse
    |> rewrite_path
    |> log
    |> route
    |> track
    |> format_response
  end

  def log(conv), do: IO.inspect conv

  def parse(request) do
    [method, path, _] =
      request 
      |> String.split("\n")
      |> List.first
      |> String.split(" ")
    
    %{ 
      method: method, 
      status: nil,
      path: path, 
      resp_body: ""
    }
  end

  def track(%{ status: 404, path: path } = conv) do
    IO.puts "Warning: #{path} is on the loose!"
    conv
  end

  def track(conv), do: conv

  def rewrite_path(%{ method: "GET", path: "/wildlife" } = conv) do
    %{conv | path: "/wildthings" }
  end

  def rewrite_path(conv), do: conv
  
  def route(%{ method: "GET", path: "/wildthings" } = conv) do
    %{conv | status: 200, resp_body: "Bears, Lions, Tigers, Gorillas"}
  end

  def route(%{ method: "GET", path: "/bears" } = conv) do
    %{conv | status: 200, resp_body: "Bamse, Nalle Puh"}
  end

  def route(%{ method: "GET", path: "/bears/" <> id } = conv) do
    %{conv | status: 200, resp_body: "Bear #{id}"}
  end

  def route(%{ method: "GET", path: "/about" } = conv) do
    %{conv | status: 200, resp_body: "contents of a file"}
  end

  def route(%{ path: path } = conv) do
    %{conv | status: 404, resp_body: "404 #{path} not found"}
  end

  def format_response(conv) do
    """
    HTTP/1.1 #{conv.status} #{status_reason(conv.status)}
    Content-Type: text/html
    Content-Length: #{String.length(conv.resp_body)}

    #{conv.resp_body}
    """
  end

  defp status_reason(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not found",
      500 => "Internal Server Error"
    }[code]
  end
end

request = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
response = Servy.Handler.handle(request)

IO.puts response

request = """
GET /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
response = Servy.Handler.handle(request)

IO.puts response

request = """
GET /bigfoot HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
response = Servy.Handler.handle(request)

IO.puts response

response = Servy.Handler.handle(request)

IO.puts response

request = """
GET /bears/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
response = Servy.Handler.handle(request)

IO.puts response

request = """
GET /wildlife HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
response = Servy.Handler.handle(request)

IO.puts response


request = """
GET /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts response
