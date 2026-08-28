using StructuralIdentifiability
using Logging

ode = @ODEmodel(
    S'(t) = -b*S(t)*In(t)/(S(t) + L(t) + In(t) + R(t) + Q(t)) - u(t)*S(t),
    L'(t) = b*S(t)*In(t)/(S(t) + L(t) + In(t) + R(t) + Q(t)) - a*L(t),
    In'(t) = a*L(t) - g*In(t),
    R'(t) = g*In(t) + e*Q(t),
    Q'(t) = u(t)*S(t) - s*Q(t) - e*Q(t),
    y1(t) = a*L(t) + s*Q(t),
    y2(t) = In(t)/(S(t) + L(t) + In(t) + R(t) + Q(t)),
    y_g(t) = g,
    y_a(t) = a,
    y_e(t) = e,
    y_s(t) = s
)

known_states = [S, L, In, R, Q]
result_dir = joinpath(pwd(), "result")
mkpath(result_dir)

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

function run_case(label, filename; known_ic = nothing)
    out_file = joinpath(result_dir, filename)
    open(out_file, "w") do io
        redirect_stdout(io) do
            redirect_stderr(io) do
                println("DANKWA2022 ", label)
                println()

                println("assess_identifiability(ode)")
                elapsed = @elapsed begin
                    if known_ic === nothing
                        result = assess_identifiability(ode, loglevel = Logging.Warn)
                    else
                        result = assess_identifiability(ode, known_ic = known_ic, loglevel = Logging.Warn)
                    end
                    print_classification(result)
                end
                println()
                println("elapsed_seconds = ", elapsed)

                println()
                println("find_identifiable_functions(ode)")
                if known_ic === nothing
                    funcs = find_identifiable_functions(ode, loglevel = Logging.Warn)
                else
                    funcs = find_identifiable_functions(ode, known_ic = known_ic, loglevel = Logging.Warn)
                end
                print_functions(funcs)
            end
        end
    end
    println("saved: ", out_file)
end

run_case("slirq_s4_incidence_prevalence_known_nh unknown initial conditions", "slirq_s4_incidence_prevalence_known_nh_unknown_initial.txt")
run_case("slirq_s4_incidence_prevalence_known_nh known initial conditions", "slirq_s4_incidence_prevalence_known_nh_known_initial.txt", known_ic = known_states)
