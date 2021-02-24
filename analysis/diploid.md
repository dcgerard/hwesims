Genotype frequencies under alternative model

$\pmb{\text{q0}=(1-r){}^{\wedge}2+t}\\
\pmb{\text{q1}=2r(1-r)-2t}\\
\pmb{\text{q2}=r{}^{\wedge}2+t}$

$(1-r)^2+t$

$2 (1-r) r-2 t$

$r^2+t$

Simplify Update

$\pmb{\text{fq}=\text{Simplify}[\{\text{q0}{}^{\wedge}2+\text{q0} \text{q1}+\text{q1}{}^{\wedge}2/4,}\\
\pmb{\text{q0} \text{q1}+2\text{q0} \text{q2}+\text{q1}{}^{\wedge}2/2+\text{q1} \text{q2},}\\
\pmb{\text{q1}{}^{\wedge}2/4+\text{q1} \text{q2}+\text{q2}{}^{\wedge}2\}]}$

$\left\{(-1+r)^2,-2 (-1+r) r,r^2\right\}$

Obtain eigenvalue decomposition of covariance under alternative model

$\pmb{\text{bread}=\{}\\
\pmb{\{1-2\text{q0}-\text{q1},-\text{q1}-2\text{q2},0\},}\\
\pmb{\{-\text{q0}-\text{q1}/2,1-\text{q0}-\text{q1}-\text{q2},-\text{q1}/2-\text{q2}\},}\\
\pmb{\{0,-2\text{q0}-\text{q1},1-\text{q1}-2\text{q2}\}}\\
\pmb{\}}$

$\left\{\left\{1-2 (1-r) r+2 t-2 \left((1-r)^2+t\right),-2 (1-r) r+2 t-2 \left(r^2+t\right),0\right\},\left\{-(1-r)^2-t+\frac{1}{2} (-2
(1-r) r+2 t),1-(1-r)^2-2 (1-r) r-r^2,-r^2-t+\frac{1}{2} (-2 (1-r) r+2 t)\right\},\left\{0,-2 (1-r) r+2 t-2 \left((1-r)^2+t\right),1-2 (1-r) r+2 t-2
\left(r^2+t\right)\right\}\right\}$

$\pmb{Q=\{}\\
\pmb{\{\text{q0}(1-\text{q0}),-\text{q0} \text{q1},-\text{q0} \text{q2}\},}\\
\pmb{\{-\text{q0} \text{q1}, \text{q1}(1-\text{q1}),-\text{q1} \text{q2}\},}\\
\pmb{\{-\text{q0} \text{q2},-\text{q1} \text{q2},\text{q2}(1-\text{q2})\}}\\
\pmb{\}}$

$\left\{\left\{\left(1-(1-r)^2-t\right) \left((1-r)^2+t\right),(2 (1-r) r-2 t) \left(-(1-r)^2-t\right),\left(-(1-r)^2-t\right) \left(r^2+t\right)\right\},\left\{(2
(1-r) r-2 t) \left(-(1-r)^2-t\right),(2 (1-r) r-2 t) (1-2 (1-r) r+2 t),\left(r^2+t\right) (-2 (1-r) r+2 t)\right\},\left\{\left(-(1-r)^2-t\right)
\left(r^2+t\right),\left(r^2+t\right) (-2 (1-r) r+2 t),\left(1-r^2-t\right) \left(r^2+t\right)\right\}\right\}$

$\pmb{\text{covmat}=\text{Simplify}[\text{Transpose}[\text{bread}].Q.\text{bread}]}$

$\left\{\left\{r^2-2 r^3+r^4+t-4 r t+4 r^2 t-t^2,-2 \left(r^2-2 r^3+r^4+t-4 r t+4 r^2 t-t^2\right),r^2-2 r^3+r^4+t-4 r t+4 r^2 t-t^2\right\},\left\{-2
\left(r^2-2 r^3+r^4+t-4 r t+4 r^2 t-t^2\right),4 \left(r^2-2 r^3+r^4+t-4 r t+4 r^2 t-t^2\right),-2 \left(r^2-2 r^3+r^4+t-4 r t+4 r^2 t-t^2\right)\right\},\left\{r^2-2
r^3+r^4+t-4 r t+4 r^2 t-t^2,-2 \left(r^2-2 r^3+r^4+t-4 r t+4 r^2 t-t^2\right),r^2-2 r^3+r^4+t-4 r t+4 r^2 t-t^2\right\}\right\}$

$\pmb{\text{MatrixRank}[\text{covmat}]}$

$1$

$\pmb{\text{Eigenvectors}[\text{covmat}]}$

$\{\{1,-2,1\},\{-1,0,1\},\{2,1,0\}\}$

$\pmb{\text{Simplify}[\text{Eigenvalues}[\text{covmat}]]}$

$\left\{6 \left(r^2-2 r^3+r^4+t-4 r t+4 r^2 t-t^2\right),0,0\right\}$

Show that factorized form of eigenvalue is equal to expansion

$\pmb{\text{Simplify}[\text{Expand}[6(r{}^{\wedge}2(1-r){}^{\wedge}2+(1-2r){}^{\wedge}2t-t{}^{\wedge}2)]]}$

$6 \left(r^2-2 r^3+r^4+t-4 r t+4 r^2 t-t^2\right)$

Obtain eigenvalue decomposition of covariance under alternative model

$\pmb{\text{f0}=(1-r){}^{\wedge}2}\\
\pmb{\text{f1}=2r(1-r)}\\
\pmb{\text{f2}=r{}^{\wedge}2}\\
\pmb{\text{bread}=\text{Simplify}[\{}\\
\pmb{\{1-2\text{f0}-\text{f1},-\text{f1}-2\text{f2},0\},}\\
\pmb{\{-\text{f0}-\text{f1}/2,1-\text{f0}-\text{f1}-\text{f2},-\text{f1}/2-\text{f2}\},}\\
\pmb{\{0,-2\text{f0}-\text{f1},1-\text{f1}-2\text{f2}\}}\\
\pmb{\}]}\\
\pmb{Q=\text{Simplify}[\{}\\
\pmb{\{\text{f0}(1-\text{f0}),-\text{f0} \text{f1},-\text{f0} \text{f2}\},}\\
\pmb{\{-\text{f0} \text{f1}, \text{f1}(1-\text{f1}),-\text{f1} \text{f2}\},}\\
\pmb{\{-\text{f0} \text{f2},-\text{f1} \text{f2},\text{f2}(1-\text{f2})\}}\\
\pmb{\}]}\\
\pmb{\text{covmat}=\text{Simplify}[\text{Transpose}[\text{bread}].Q.\text{bread}]}\\
\pmb{\text{Eigenvectors}[\text{covmat}]}\\
\pmb{\text{Simplify}[\text{Eigenvalues}[\text{covmat}]]}$

$(1-r)^2$

$2 (1-r) r$

$r^2$

$\{\{-1+2 r,-2 r,0\},\{-1+r,0,-r\},\{0,2 (-1+r),1-2 r\}\}$

$\left\{\left\{-(-2+r) (-1+r)^2 r,2 (-1+r)^3 r,-(-1+r)^2 r^2\right\},\left\{2 (-1+r)^3 r,-2 (-1+r) r \left(1-2 r+2 r^2\right),2 (-1+r)
r^3\right\},\left\{-(-1+r)^2 r^2,2 (-1+r) r^3,r^2-r^4\right\}\right\}$

$\left\{\left\{(-1+r)^2 r^2,-2 (-1+r)^2 r^2,(-1+r)^2 r^2\right\},\left\{-2 (-1+r)^2 r^2,4 (-1+r)^2 r^2,-2 (-1+r)^2 r^2\right\},\left\{(-1+r)^2
r^2,-2 (-1+r)^2 r^2,(-1+r)^2 r^2\right\}\right\}$

$\{\{1,-2,1\},\{-1,0,1\},\{2,1,0\}\}$

$\left\{6 (-1+r)^2 r^2,0,0\right\}$
