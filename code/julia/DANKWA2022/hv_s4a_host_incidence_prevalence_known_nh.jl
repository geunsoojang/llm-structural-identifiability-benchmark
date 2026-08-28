using StructuralIdentifiability
using Logging

ode = @ODEmodel(
    Sh'(t) = mh*(Sh(t) + Lh(t) + Ih(t) + Rh(t)) - bv*Sh(t)*Iv(t)/(Sh(t) + Lh(t) + Ih(t) + Rh(t)) - mh*Sh(t),
    Lh'(t) = bv*Sh(t)*Iv(t)/(Sh(t) + Lh(t) + Ih(t) + Rh(t)) - ah*Lh(t) - mh*Lh(t),
    Ih'(t) = ah*Lh(t) - gh*Ih(t) - mh*Ih(t),
    Rh'(t) = gh*Ih(t) - mh*Rh(t),
    Sv'(t) = mv*(Sv(t) + Lv(t) + Iv(t)) - bh*Sv(t)*Ih(t)/(Sh(t) + Lh(t) + Ih(t) + Rh(t)) - mv*Sv(t),
    Lv'(t) = bh*Sv(t)*Ih(t)/(Sh(t) + Lh(t) + Ih(t) + Rh(t)) - av*Lv(t) - mv*Lv(t),
    Iv'(t) = av*Lv(t) - mv*Iv(t),
    y1(t) = ah*Lh(t),
    y2(t) = Ih(t)/(Sh(t) + Lh(t) + Ih(t) + Rh(t)),
    y_ah(t) = ah,
    y_gh(t) = gh,
    y_av(t) = av
)

known_states = [Sh, Lh, Ih, Rh, Sv, Lv, Iv]
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

run_case("hv_s4a_host_incidence_prevalence_known_nh unknown initial conditions", "hv_s4a_host_incidence_prevalence_known_nh_unknown_initial.txt")
run_case("hv_s4a_host_incidence_prevalence_known_nh known initial conditions", "hv_s4a_host_incidence_prevalence_known_nh_known_initial.txt", known_ic = known_states)
