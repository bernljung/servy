# server() ->
#     {ok, LSock} = gen_tcp:listen(5678, [binary, {packet, 0}, 
#                                         {active, false}]),
#     {ok, Sock} = gen_tcp:accept(LSock),
#     {ok, Bin} = do_recv(Sock, []),
#     ok = gen_tcp:close(Sock),
#     Bin.
defmodule Servy.HttpServer do
    def server do
        {:ok, lsock} = :gen_tcp.listen(5678, [:binary, packet: 0, 
                                            active: false])
        IO.inspect lsock
        {:ok, sock} = :gen_tcp.accept(lsock)
        {:ok, bin} = :gen_tcp.recv(sock, 0)
        # send response
        :ok = :gen_tcp.close(sock)
        bin
    end
end