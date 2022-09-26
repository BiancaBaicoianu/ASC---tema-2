# ASC---tema-2

Se citesc de la tastatura n, m si 3 · n elemente care pot fi sau 0, sau cuprinse intre 1 si n, unde se
respecta conditia 1 ≤ n, m ≤ 30. Se va genera cea mai mica permutare in sens lexicografic a
multimii {1, ..., n}, unde fiecare element apare de exact 3 ori, avand o distanta de minimum m
elemente intre oricare doua elemente egale, plecand de la anumite puncte fixe deja specificate.
De exemplu, pentru n = 5, m = 1 si secventa de 15 elemente
```
1 0 0 0 0 0 3 0 0 0 0 0 0 4 5
```
avem ca fiecare element din multimea {1, 2, 3, 4, 5} apare de 3 ori, si vrem sa fie cel putin m =
1 element distanta intre oricare doua elemente egale. Atunci, cea mai mica permutare in sens
lexicografic, pastrand punctele fixe, este urmatoarea:
```
1 2 1 2 1 2 3 4 3 5 3 4 5 4 5
```

Se vor afisa la standard output, dupa caz,
- sau permutarea, daca exista, in formatul de mai sus: elementele se vor afisa cu spatii intre ele
pe ecran, iar la final recomandam sa afisati un caracter backslash n, in locul utilizarii fflush;
- sau −1, in cazul in care nu exista o permutare care sa satisfaca toate conditiile.
