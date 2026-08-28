# BERGSTROM2026

`models.csv` marks this source model as not directly compatible because the paper's main identifiability result depends on parameter-dependent initial conditions:

- `S(0)=n*(1-pi_prior)-n*i0`
- `Ir(0)=n*i0`
- `Iu(0)=n*(1-p)*i0/p`
- `Rr(0)=n*p*pi_prior`
- `Ru(0)=n*(1-p)*pi_prior`

The Julia script is therefore a baseline ODE/output encoding, not a complete reproduction of the paper's parameter-dependent-IC proof.
