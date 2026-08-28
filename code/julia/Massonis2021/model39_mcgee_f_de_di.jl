using StructuralIdentifiability
using Logging

# Source: Massonis et al. (2021), Table 1 or Table 2.
# Parameters omitted from the table's Parameters column are encoded as
# constant outputs so they are treated as known quantities.
ode = @ODEmodel(
    S'(t) = -beta*S(t)*I(t)/N - q*beta_d*S(t)*Di(t)/N,
    E'(t) = beta*S(t)*I(t)/N + q*beta_d*S(t)*Di(t)/N - sigma*E(t) - theta_e*phi_e*E(t),
    I'(t) = sigma*E(t) - gamma*I(t) - mu_i*I(t) - theta_i*phi_i*I(t),
    De'(t) = theta_e*phi_e*E(t) - sigma_d*De(t),
    Di'(t) = theta_i*phi_i*I(t) + sigma_d*De(t) - gamma_d*Di(t) - mu_d*Di(t),
    R'(t) = gamma*I(t) + gamma_d*Di(t),
    F'(t) = mu_i*I(t) + mu_d*Di(t),

    y1(t) = F(t),
    y2(t) = De(t),
    y3(t) = Di(t),
    y_N(t) = N
)

known_states = [S, E, I, De, Di, R, F]

println("Massonis SEIR model 39 McGee output configuration 2 F,De,Di: unknown initial conditions")
unknown_ic_result = assess_identifiability(ode, loglevel = Logging.Warn)
show(stdout, "text/plain", unknown_ic_result)
println()

println("Massonis SEIR model 39 McGee output configuration 2 F,De,Di: known generic initial conditions")
known_ic_result = assess_identifiability(
    ode,
    known_ic = known_states,
    loglevel = Logging.Warn,
)
show(stdout, "text/plain", known_ic_result)
println()
