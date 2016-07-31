# Stanford Cryptography I
Notes for the [Stanford Cryptography Course](https://www.coursera.org/learn/crypto) on coursera.

## Week 1: Overview
### What is Cryptography All About?
* Cryptography consists of 2 core parts:
    - Establish and exchange a secure key
    - Use it to communicate securely
* Digital Signatures
* Anonymous communication
    - MixNets are ways of encrypting traffic through multiple proxies
* Anonymous Digital Cash without double spending
* Secure multi-party computation
    - Theorem: any computation that can be done with a trusted authority can also be done without, in a cryptographically secure way.
* Privately outsourcing computation
* Zero knowledge proof of knowledge
    - Let's say we have N = p * q, where p and q are prime
    - There's a way for Alice to prove to Bob that she knows p and q for N, without telling Bob either p or q!
* Three steps in cryptography:
    1. Specify the threat model: what can an attacker do to attack, and what is the goal in forging
    1. Propose a construction
    1. Proof that breaking the construction under the threat model will solve an underlying hard problem.

#### History of Cryptography
The Code Breakers by David Kahn gives a great history of cryptography from ancient times to today.

Symmetric Ciphers: both Alice (the encrypter) and Bob (the decrypter) use the same key to their algorithm.

### Discrete Probability
* The Union Bound: `P(A U B) <= P(A) + P(B)`
* Events A and B are independent if `P(A ^ B) = P(A) * P(B)`
* XOR Theorem: Let Y be a random variable distributed over {0,1}^n, and let X be an independent uniform variable on {0,1}^n.  Then Z = (Y xor X) is a uniform random variable on {0,1}^n.

### Stream Ciphers
* A Cipher is defined over (K, M, C) is a pair of "efficient" algorithms `(E, D)` where
    - K is the set of all possible keys
    - M is the set of all possible messages
    - C is the set of all possible cipher texts
    - such that `D(k, E(k, m)) = m` (consistency property)
* E is often randomized, but D must always be deterministic to satisfy the consistency constraint
* The One Time Pad Cipher
    - `c := E(k, m) = k xor m`
    - Since xor is addition modulo 2, this very simple cipher satisfies the consistency property
        * Very fast encryption and decryption, BUT
        * The keys are as long as the plaintext, so it's inefficient
        * Satisfies the proof of "perfect secrecy": there are no cipher-text-only attacks possible
* Pseudorandom Keys
    - Rather than using a long key, we can use a seed to a pseudorandom number generator to generate a key, and share the seed securely.
    - We lose the definition of "perfect secrecy", and instead rely on the notion of it being "unpredictable"
* Attacks on Stream Ciphers
    - Note that the one time pad is a ONE TIME pad!  If I see two encrypted messages using the same pad, I can xor the ciphers to get m1 xor m2
        * Project Venona (1941-1946) is a good example of a failure of this kind
        * Same with WEP
        * In client server architectures, we need to have one key for client -> server requests, and one key for server -> client responses
    - Malleability
        * The OTP provides no integrity: attackers can intercept the cipher and xor it with their own p, to modify the message
        * Can essentially do sed substitutions on the stream, if we know the offset of what we're trying to change.
            - Example: changing "From: Ben" to "From: Bob" in a message where the attacker knows Ben will appear and the offset
    - CSS for DVD encryption
        * Based on a Linear Feedback Shift Register (LFSR)
        * Implemented in hardware, then badly broken :)
* Salsa20
    - Modern secure stream cipher designed for both software and hardware implementations
* PRGs
    - Let `G:K -> {0,1}^n` be a PRG
    - We define a number of statistical tests to determine if a binary string X "looks random"
    - Given a statistical test A and a generator G, we define the `advantage` of a truly random number over G as the probability that G passes the test - probability that a truly random number passes
        * An advantage close to 1 means that G is failing; close to 0 means that G is as good as a truly random number w.r.t. that statistical test
        * If the advantage for test A is significant for G, we say "A breaks G with advantage %"
        * We say that `G:k -> {0,1}^n` is a secure PRG if for all efficient statistical tests A, `Advantage[A, G] < epsilon` for some "negligible" epsilon
        * There are no provably secure PRGs, unless P = NP
    - A secure PRG is unpredictable
        * Thm: If for all i in {0, n-1}, PRG G is unpredictable at pos. i, then G is a secure PRG
        * If a next-bit predictor cannot distinguish G from random then no statistical test can
* Semantic Security for a one-time key
    - An adversary emits two messages, m1 and m2, which are encrypted with the algorithm. If the adversary is able to guess which message comes out given the encrypted text, the algorithm does not have semantic security.
    - This is a weaker definition than perfect security, because it requires the adversary to have an efficient algorithm to crack.
