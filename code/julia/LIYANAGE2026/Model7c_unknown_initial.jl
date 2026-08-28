using StructuralIdentifiability
using Logging

ode = @ODEmodel(
    E'(t) = (bI*I(t) + bH*H(t) + bD*D(t))*(C2 - E(t) - (I(t) + (a+gI+dI)/(dH*a + (gH+dH)*dI)*(dH*H(t) + (gH+dH)*D(t)) - C3))/(C - D(t)) - k*E(t),
    I'(t) = k*E(t) - (a+gI+dI)*I(t),
    H'(t) = a*I(t) - (gH+dH)*H(t),
    D'(t) = dI*I(t) + dH*H(t),
    y1(t) = k*E(t),
    y2(t) = I(t) + (a+gI+dI)/(dH*a + (gH+dH)*dI)*(dH*H(t) + (gH+dH)*D(t)) - C3,
    y3(t) = a*I(t),
    y4(t) = dI*I(t) + dH*H(t)
)

known_states = [E, I, H, D]

result_dir = joinpath(pwd(), "result")
mkpath(result_dir)
out_file = joinpath(result_dir, "Model7c_unknown_initial.txt")

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
            println("LIYANAGE2026 Model7c_unknown_initial")
            println()

            println("assess_identifiability(ode)")
            elapsed = @elapsed begin
                result = assess_identifiability(ode, loglevel = Logging.Warn)
                print_classification(result)
            end
            println()
            println("elapsed_seconds = ", elapsed)

            println()
            println("find_identifiable_functions(ode)")
            funcs = find_identifiable_functions(ode, loglevel = Logging.Warn)
            print_functions(funcs)
        end
    end
end

println("saved: ", out_file)
