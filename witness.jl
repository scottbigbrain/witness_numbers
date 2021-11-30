# uses the Miller-Rabin test to determine is a number is prime
# using the witness of a single number a
# Numberphile with Matt Parker gives a good explaination https://youtu.be/_MscGSN5J6o


# simplifies taking the mod of the exponential
function modexp(n, a, d)
    out = 1
    for i = 1:d
        out = (out * a) % n
    end
    return out
end

# dresses the numnber n in the form d*2^p + 1
function dressnumber(n)
    # increases what power of 2 we are dividing n-1 by until it finds
    # the highest power that works
    even_base = n - 1
    p = 1
    while  iswhole(even_base / 2^(p+1))
        p += 1
    end
    d = even_base / 2^p

    return d, p
end

iswhole(x) = x % 1 == 0

# finds whether n is prime according to the testimony of the number a
function getwitness(n, a)
    if iseven(n) return false end

    d = dressnumber(n)[1]

    testimony = modexp(n, a, d)
    return testimony == 1 || testimony == even_base
end

function getwitness(n, a, d)
    if iseven(n) return false end
    testimony = modexp(n, a, d)
    return testimony == 1 || testimony == n-1
end
