using StructuralIdentifiability
using Logging

# Source: Massonis et al. (2021), Table 1 or Table 2.
# Parameters omitted from the table's Parameters column are encoded as
# constant outputs so they are treated as known quantities.
ode = @ODEmodel(
    S'(t) = -beta*S(t)*I(t)/N - q*beta_d*S(t)*Di(t)/N + nu*N - mu0*S(t),
    E'(t) = beta*S(t)*I(t)/N + q*beta_d*S(t)*Di(t)/N - sigma*E(t) - theta_e*phi_e*E(t) - mu0*E(t),
    I'(t) = sigma*E(t) - gamma*I(t) - mu_i*I(t) - theta_i*phi_i*I(t) - mu0*I(t),
    De'(t) = theta_e*phi_e*E(t) - sigma_d*De(t) - mu0*De(t),
    Di'(t) = theta_i*phi_i*I(t) + sigma_d*De(t) - gamma_d*Di(t) - mu_d*Di(t) - mu0*Di(t),
    R'(t) = gamma*I(t) + gamma_d*Di(t) - mu0*R(t),
    F'(t) = mu_i*I(t) + mu_d*Di(t),

    y1(t) = De(t),
    y2(t) = Di(t),
    y3(t) = F(t),
    y_nu(t) = nu,
    y_N(t) = N
)

known_states = [S, E, I, De, Di, R, F]

println("Massonis SEIR model 51 McGee output configuration 1 De,Di,F: unknown initial conditions")
unknown_ic_result = assess_identifiability(ode, loglevel = Logging.Warn)
show(stdout, "text/plain", unknown_ic_result)
println()

println("Massonis SEIR model 51 McGee output configuration 1 De,Di,F: known generic initial conditions")
known_ic_result = assess_identifiability(
    ode,
    known_ic = known_states,
    loglevel = Logging.Warn,
)
show(stdout, "text/plain", known_ic_result)
println()
