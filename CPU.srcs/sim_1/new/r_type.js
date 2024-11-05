function compareSigned(a, b) {
    const signedA = a | 0;
    const signedB = b | 0;
    return signedA === signedB ? 0 : (signedA < signedB ? -1 : 1);
}

function compareUnsigned(a, b) {
    const unsignedA = a >>> 0;
    const unsignedB = b >>> 0;
    return unsignedA === unsignedB ? 0 : (unsignedA < unsignedB ? -1 : 1);
}
  


t0 = 0 + 5
console.log(`t0 = 0 + 5: 0x${(t0 >>> 0).toString(16)}`)

t1 = t0 - 10
console.log(`t1 = t0 - 10: 0x${(t1 >>> 0).toString(16)}`)

t2 = t1 + 3
console.log(`t2 = t1 + 3: 0x${(t2 >>> 0).toString(16)}`)

t3 = t0 + t1
console.log(`t3 = t0 + t1: 0x${(t3 >>> 0).toString(16)}`)

t4 = t1 - t2
console.log(`t4 = t1 - t2: 0x${(t4 >>> 0).toString(16)}`)

t0 = t0 << t0;
console.log(`t0 = t0 << t0: 0x${(t0 >>> 0).toString(16)}`)

t6 = t2 >>> t4
console.log(`t6 = t2 srl t4: 0x${(t6 >>> 0).toString(16)}`)

t5 = t4 >> t3
console.log(`t5 = t4 sra t3: 0x${(t5 >>> 0).toString(16)}`)

t4 = t2 | t2;
console.log(`t4 = t2 | t2: 0x${(t4 >>> 0).toString(16)}`)

t3 = t5 & t6
console.log(`t3 = t5 & t6: 0x${(t3 >>> 0).toString(16)}`)

t2 = t4 ^ t1
console.log(`t2 = t4 ^ t1: 0x${(t2 >>> 0).toString(16)}`)

t5 = compareSigned(t3, t2) == -1
console.log(`t5 = t3 < t2: 0x${(t5 >>> 0).toString(16)}`)

t5 = compareUnsigned(t2, t3) == -1
console.log(`t5 = t2 < t3: 0x${(t5 >>> 0).toString(16)}`)


