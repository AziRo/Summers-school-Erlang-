-define(Pow(Value, Power),
    begin
        Fun = fun
            Pow(_, 0) -> 1;
            Pow(V, P) when P > 0 ->
                Pow(V, P - 1) * V;
            Pow(V, P) when P < 0 ->
                Pow(V, P + 1) / V
        end,
        Fun(Value, Power)
    end).
