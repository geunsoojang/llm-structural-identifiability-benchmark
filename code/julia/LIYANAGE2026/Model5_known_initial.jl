using StructuralIdentifiability
using Logging

ode = @ODEmodel(
    Sv'(t) = lambdav - beta*Sv(t)*I(t)/N - muv*Sv(t),
    Iv'(t) = beta*Sv(t)*I(t)/N - muv*Iv(t),
    S'(t) = -betav*Iv(t)*S(t)/N,
    I'(t) = betav*Iv(t)*S(t)/N - gamma*I(t),
    R'(t) = gamma*I(t),
    y1(t) = c - S(t),
    y2(t) = N,
    y3(t) = c
)

known_states = [Sv, Iv, S, I, R]

result_dir = joinpath(pwd(), "result")
mkpath(result_dir)
out_file = joinpath(result_dir, "Model5_known_initial.txt")

function print_classification(result)
    for (quantity, classification) in result
        println(quantity, " => ", classification)
    end
end

function print_functions(functions)
    for f in functions
        println(f)
    end
end

open(out_file, "w") do io
    redirect_stdout(io) do
        redirect_stderr(io) do
            println("LIYANAGE2026 Model5_known_initial")
            println()

            println("assess_identifiability(ode)")
            elapsed = @elapsed begin
                result = assess_identifiability(ode, known_ic = known_states, loglevel = Logging.Warn)
                print_classification(result)
            end
            println()
            println("elapsed_seconds = ", elapsed)

            println()
            println("find_identifiable_functions(ode)")
            funcs = find_identifiable_functions(ode, known_ic = known_states, loglevel = Logging.Warn)
            print_functions(funcs)
        end
    end
end

println("saved: ", out_file)
